import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool connected = false;
  int retries = 0;

  Future<void> listenForChanges() async {
    ShoppingList? currentShoppingList = ref
        .read(AppStateNotifier.appStateProvider)
        .currentShoppingList;
    if (retries < 3 &&
        currentShoppingList != null &&
        (subscribedToShoppingListWithId != currentShoppingList.id ||
            !connected)) {
      retries = subscribedToShoppingListWithId == currentShoppingList.id
          ? retries + 1
          : 0;
      if (connected) await websocketChannel?.sink.close();
      setState(() {
        subscribedToShoppingListWithId = currentShoppingList.id;
        connected = true;
      });
      print("connecting to ws");
      websocketChannel =
          await GoListClient().listenForChanges(currentShoppingList.id);
      websocketChannel?.stream.listen((data) {
        print("updating shoppinglist from websocket: ${jsonDecode(data)}");
        ref.read(AppStateNotifier.appStateProvider.notifier).updateShoppingList(
            ShoppingList.fromJson(jsonDecode(data)),
            updateRemoteStorage: false);
      },
          onError: print,
          onDone: () => setState(() {
                websocketChannel = null;
                print("ws closed");
                connected = false;
              }));
    }
  }

  @override
  void dispose() {
    print("dispose sync widget");
    super.dispose();
    if (connected) websocketChannel?.sink.close();
    websocketChannel = null;
  }

  @override
  Widget build(BuildContext context) {
    listenForChanges();
    return widget.child;
  }
}
