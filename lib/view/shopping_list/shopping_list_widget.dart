import 'package:flutter/material.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/view/dialog/dialog_utils.dart';
import 'package:go_list/view/dialog/edit_item_dialog.dart';
import 'package:go_list/view/shopping_list/item_list_viewer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShoppingListWidget extends HookConsumerWidget {
  const ShoppingListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(AppStateNotifier.appStateProvider);
    if (appState.shoppingLists.isEmpty) {
      print("new appstate without list");
    } else {
      print(
          "ShoppingListWidget: ${appState.shoppingLists.length} lists with list id ${appState.currentShoppingList!.id} and ${appState.shoppingLists[0].items.length} items");
    }
    return appState.currentShoppingList != null
        ? ItemListViewer(
            items: appState.currentShoppingList!.items
                .where((i) => !i.deleted)
                .toList(),
            title: appState.currentShoppingList!.name,
            onItemTapped: (tappedItem) {
              ref
                  .read(AppStateNotifier.appStateProvider.notifier)
                  .deleteItem(tappedItem);
            },
            onItemTappedLong: (item) => DialogUtils.showSmallAlertDialog(
                context: context, content: EditItemDialog(item: item)),
            delayItemTap: true,
          )
        : Text("lädt");
  }
}
