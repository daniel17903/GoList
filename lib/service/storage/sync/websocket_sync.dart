import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/service/storage/storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketSync extends StatefulHookConsumerWidget {
  final Widget child;

  const WebsocketSync({Key? key, required this.child}) : super(key: key);

  @override
  ConsumerState<WebsocketSync> createState() => _WebsocketSyncState();
}

class _WebsocketSyncState extends ConsumerState<WebsocketSync>
    with WidgetsBindingObserver {
  WebSocketChannel? websocketChannel;
  String? subscribedToShoppingListWithId;
  bool connected = false;
  int retries = 0;
  Future<void>? loadingFuture;

  Future<void> listenForChanges(ShoppingList? currentShoppingList) async {
    if (currentShoppingList == null || currentShoppingList.deviceCount == 1) {
      return;
    }
    if (retries < 3 &&
        (subscribedToShoppingListWithId != currentShoppingList.id ||
            !connected)) {
      retries = subscribedToShoppingListWithId == currentShoppingList.id
          ? retries + 1
          : 0;
      if (connected) {
        await websocketChannel?.sink.close();
      }
      subscribedToShoppingListWithId = currentShoppingList.id;
      connected = true;
      websocketChannel =
          GoListClient().listenForChanges(currentShoppingList.id);
      websocketChannel?.stream.listen((data) {
        print("updating shoppinglist from websocket: $data");

        Storage()
            // update list and items in local storage
            .syncWithListFromRemote(ShoppingList.fromJson(jsonDecode(data)))
            .then((updatedList) {
          // update list and items in state
          ref
              .read(AppStateNotifier.appStateProvider.notifier)
              .updateShoppingList(updatedList,
                  updateRemoteStorage: false, updateStorage: false);
        });
      }, onError: (e) {
        print("ws closed with error: $e");
        retries++;
        listenForChanges(currentShoppingList);
      }, onDone: () {
        websocketChannel = null;
        print("ws closed: done");
        connected = false;
      });
    }
  }

  void disconnect() {
    if (connected) {
      websocketChannel?.sink.close();
    }
    websocketChannel = null;
    connected = false;
    retries = 0;
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      await ref
          .read(AppStateNotifier.appStateProvider.notifier)
          .loadAllFromStorage();

      if (!mounted) return;

      ref
          .read(AppStateNotifier.appStateProvider.notifier)
          .initializeWithEmptyList(context);
      retries = 0;
      listenForChanges(
          ref.read(AppStateNotifier.appStateProvider).currentShoppingList);
    }
  }

  Future<void> loadListsAndListenForChanges(
      {bool onlyIfNotLoadedBefore = false}) async {
    // if a loadingFuture exists Lists have been loaded before
    if (onlyIfNotLoadedBefore && loadingFuture != null) return;

    // wait until previous loadingFuture finishes
    if (loadingFuture != null) await loadingFuture;

    final completer = Completer<void>();
    loadingFuture = completer.future;

    await ref
        .read(AppStateNotifier.appStateProvider.notifier)
        .loadAllFromStorage();

    if (!mounted) {
      loadingFuture = null;
      return;
    }

    ref
        .read(AppStateNotifier.appStateProvider.notifier)
        .initializeWithEmptyList(context);
    retries = 0;
    listenForChanges(
        ref.read(AppStateNotifier.appStateProvider).currentShoppingList);

    completer.complete();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadListsAndListenForChanges(onlyIfNotLoadedBefore: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ShoppingList? currentShoppingList =
        ref.watch(AppStateNotifier.appStateProvider).currentShoppingList;
    listenForChanges(currentShoppingList);
    return widget.child;
  }
}
