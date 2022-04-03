import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_list/model/app_state.dart';
import 'package:go_list/service/storage/storage.dart';
import 'package:go_list/service/storage/sync/websocket_sync.dart';
import 'package:provider/provider.dart';

class ShoppingListLoader extends StatefulWidget {
  final Widget child;

  const ShoppingListLoader({Key? key, required this.child}) : super(key: key);

  @override
  State<ShoppingListLoader> createState() => _ShoppingListLoaderState();
}

class _ShoppingListLoaderState extends State<ShoppingListLoader> {
  @override
  void initState() {
    GetStorage.init().then((_) {
      Storage().loadShoppingLists().listen((shoppingListsFromStorage) {
        context.read<AppState>().shoppingLists = shoppingListsFromStorage;
      }, onDone: () {
        context.read<AppState>().initializeWithEmptyList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebsocketSync(child: widget.child);
  }
}
