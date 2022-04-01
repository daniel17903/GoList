import 'package:flutter/material.dart';
import 'package:go_list/model/app_state.dart';
import 'package:go_list/service/storage/storage.dart';
import 'package:go_list/view/dialog/dialog_utils.dart';
import 'package:go_list/view/dialog/edit_item_dialog.dart';
import 'package:go_list/view/shopping_list/item_list_viewer.dart';
import 'package:provider/provider.dart';

class ShoppingListWidget extends StatelessWidget {
  const ShoppingListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState appState = context.watch<AppState>();
    if (appState.shoppingLists.isEmpty) {
      print("new appstate without list");
    } else {
      print(
          "ShoppingListWidget: ${appState.shoppingLists.length} lists with list id ${appState.currentShoppingList!.id} and ${appState.currentShoppingList!.items.length} items");
    }
    return appState.currentShoppingList != null
        ? ItemListViewer(
            items: [...appState.currentShoppingList!.items]
              ..retainWhere((i) => i.deleted == false),
            title: appState.currentShoppingList!.name,
            onItemTapped: (tappedItem) {
              print(
                  "ShoppingListWidget: ${appState.shoppingLists.length} lists with list id ${appState.currentShoppingList!.id} and ${appState.currentShoppingList!.items.length} items");
              appState.currentShoppingList!.deleteItem(tappedItem);
              Storage().saveItems(appState.currentShoppingList!, [tappedItem]);
            },
            onItemTappedLong: (item) => DialogUtils.showSmallAlertDialog(
                context: context, content: EditItemDialog(item: item)),
            delayItemTap: true,
          )
        : Text("lädt");
  }
}
