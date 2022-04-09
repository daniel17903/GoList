import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/service/storage/storage.dart';
import 'package:go_list/service/storage/sync/websocket_sync.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShoppingListLoader extends StatefulHookConsumerWidget {
  final Widget child;

  const ShoppingListLoader({Key? key, required this.child}) : super(key: key);

  @override
  ConsumerState<ShoppingListLoader> createState() => _ShoppingListLoaderState();
}

class _ShoppingListLoaderState extends ConsumerState<ShoppingListLoader> {
  @override
  void initState() {
    super.initState();
    final appStateNotifier =
        ref.read(AppStateNotifier.appStateProvider.notifier);
    GetStorage.init().then(
        (_) => Storage().loadShoppingLists().listen((shoppingListsFromStorage) {
              appStateNotifier.setShoppingLists(shoppingListsFromStorage);
            }, onDone: appStateNotifier.initializeWithEmptyList));
  }

  @override
  Widget build(BuildContext context) {
    return WebsocketSync(child: widget.child);
  }
}
