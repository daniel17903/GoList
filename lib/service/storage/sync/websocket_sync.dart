import 'dart:convert';

import 'package:flutter/cupertino.dart';
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

class _WebsocketSyncState extends ConsumerState<WebsocketSync> {
  WebSocketChannel? websocketChannel;
  String? subscribedToShoppingListWithId;
  int retries = 0;

  Future<void> listenForChanges(String shoppingListId) async {
    if (retries < 3 &&
        (subscribedToShoppingListWithId != shoppingListId ||
            !ref.read(AppStateNotifier.connectedProvider))) {
      retries =
          subscribedToShoppingListWithId == shoppingListId ? retries + 1 : 0;
      if (ref.read(AppStateNotifier.connectedProvider))
        await websocketChannel?.sink.close();
      subscribedToShoppingListWithId = shoppingListId;
      Future.delayed(
          Duration.zero,
          () => ref
              .read(AppStateNotifier.appStateProvider.notifier)
              .setConnected(true));
      print("connecting to ws");
      websocketChannel = await GoListClient().listenForChanges(shoppingListId);
      websocketChannel?.stream.listen((data) {
        print("updating shoppinglist from websocket: $data");
        ref.read(AppStateNotifier.appStateProvider.notifier).updateShoppingList(
            ShoppingList.fromJson(jsonDecode(data)),
            updateRemoteStorage: false);
      }, onError: (e) {
        print("ws closed with error: $e");
        retries++;
        listenForChanges(shoppingListId);
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
    if (ref.read(AppStateNotifier.connectedProvider))
      websocketChannel?.sink.close();
    websocketChannel = null;
    ref.read(AppStateNotifier.appStateProvider.notifier).setConnected(false);
    retries = 0;
  }

  @override
  void dispose() {
    print("dispose sync widget");
    disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ShoppingList? currentShoppingList =
        ref.watch(AppStateNotifier.appStateProvider).currentShoppingList;
    if (currentShoppingList != null) {
      listenForChanges(currentShoppingList.id);
    }
    return widget.child;
  }
}
