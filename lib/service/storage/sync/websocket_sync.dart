import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:go_list/model/app_state.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketSync extends StatefulWidget {
  final Widget child;

  const WebsocketSync({Key? key, required this.child}) : super(key: key);

  @override
  State<WebsocketSync> createState() => _WebsocketSyncState();
}

class _WebsocketSyncState extends State<WebsocketSync> {
  WebSocketChannel? websocketChannel;
  String? subscribedToShoppingListWithId;
  bool connected = false;
  int retries = 0;

  Future<void> listenForChanges(AppState appState) async {
    ShoppingList? currentShoppingList = appState.currentShoppingList;
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
        appState.currentShoppingList = ShoppingList.fromJson(jsonDecode(data));
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
    AppState appState = context.watch<AppState>();
    listenForChanges(appState);
    return widget.child;
  }
}
