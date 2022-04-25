import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/golist_client.dart';
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
  int retries = 0;

  Future<void> listenForChanges(ShoppingList? currentShoppingList) async {
    if (currentShoppingList == null) return;
    if (retries < 3 &&
        (subscribedToShoppingListWithId != currentShoppingList.id ||
            !ref.read(AppStateNotifier.connectedProvider))) {
      retries = subscribedToShoppingListWithId == currentShoppingList.id
          ? retries + 1
          : 0;
      if (ref.read(AppStateNotifier.connectedProvider)) {
        await websocketChannel?.sink.close();
      }
      subscribedToShoppingListWithId = currentShoppingList.id;
      Future.delayed(
          Duration.zero,
          () => ref
              .read(AppStateNotifier.appStateProvider.notifier)
              .setConnected(true));
      print("connecting to ws");
      websocketChannel =
          GoListClient().listenForChanges(currentShoppingList.id);
      websocketChannel?.stream.listen((data) {
        print("updating shoppinglist from websocket: $data");
        ref.read(AppStateNotifier.appStateProvider.notifier).updateShoppingList(
            ShoppingList.fromJson(jsonDecode(data)),
            updateRemoteStorage: false);
      }, onError: (e) {
        print("ws closed with error: $e");
        retries++;
        listenForChanges(currentShoppingList);
      },
          onDone: () => setState(() {
                websocketChannel = null;
                print("ws closed: done");
                ref
                    .read(AppStateNotifier.appStateProvider.notifier)
                    .setConnected(false);
              }));
    }
  }

  void disconnect() {
    if (ref.read(AppStateNotifier.connectedProvider)) {
      websocketChannel?.sink.close();
    }
    websocketChannel = null;
    ref.read(AppStateNotifier.appStateProvider.notifier).setConnected(false);
    retries = 0;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      ref.read(AppStateNotifier.appStateProvider.notifier).loadAllFromStorage();
      print("resuming");
      retries = 0;
      listenForChanges(
          ref.read(AppStateNotifier.appStateProvider).currentShoppingList);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    print("dispose sync widget");
    WidgetsBinding.instance!.removeObserver(this);
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
