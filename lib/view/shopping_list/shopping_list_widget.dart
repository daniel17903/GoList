import 'package:flutter/material.dart';
import 'package:go_list/service/storage/storage.dart';
import 'package:go_list/view/dialog/dialog_utils.dart';
import 'package:go_list/view/dialog/edit_item_dialog.dart';
import 'package:go_list/view/shopping_list/item_list_viewer.dart';
import 'package:provider/provider.dart';

import '../../model/app_state.dart';

class ShoppingListWidget extends StatelessWidget {
  const ShoppingListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (BuildContext context, AppState appState, Widget? child) =>
          appState.isLoading
              ? const Text("lädt...")
              : ItemListViewer(
                  items: appState.currentShoppingList.items,
                  onItemTapped: (tappedItem) {
                    Storage()
                        .removeItem(appState.currentShoppingList, tappedItem);
                    appState.currentShoppingList.removeItem(tappedItem);
                  },
                  onItemTappedLong: (item) => DialogUtils.showSmallAlertDialog(
                      context: context, content: EditItemDialog(item: item)),
                  delayItemTap: true,
                ),
    );
  }
}
