import 'package:flutter/material.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/dialog/dialog_utils.dart';
import 'package:go_list/view/dialog/edit_item_dialog.dart';
import 'package:go_list/view/dialog/edit_list_dialog.dart';
import 'package:go_list/view/shopping_list/item_list_viewer.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/shopping_list_item.dart';
import 'package:provider/provider.dart';

class MainItemListViewer extends StatelessWidget {
  const MainItemListViewer({super.key});

  @override
  Widget build(BuildContext context) {
    // SafeArea is required for the android toolbar not to overlap the title
    return SafeArea(
      child:
          Consumer<GlobalAppState>(builder: (context, globalAppState, child) {
        return ItemListViewer(
            darkBackground: false,
            onPullForRefresh: () => globalAppState.loadListsFromStorage(),
            header: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(globalAppState.selectedShoppingList.name,
                    style: const TextStyle(color: Colors.white, fontSize: 22)),
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.white,
                  onPressed: () => DialogUtils.showSmallAlertDialog(
                      context: context,
                      contentBuilder: (_) => EditListDialog(
                          shoppingList: globalAppState.selectedShoppingList)),
                )
              ],
            ),
            shoppingListItems: globalAppState.selectedShoppingList.items.entries
                .where((item) =>
                    item.deleted == false ||
                    globalAppState.recentlyDeletedItems.contains(item.id))
                .map((item) => ShoppingListItem(
                      item: item,
                      backgroundColor: GoListColors.itemBackground,
                      onItemTapped: () => item.deleted
                          ? Provider.of<GlobalAppState>(context, listen: false)
                              .unDeleteItem(item.id)
                          : Provider.of<GlobalAppState>(context, listen: false)
                              .deleteItem(item),
                      onItemTappedLong: () => item.deleted
                          ? {}
                          : EditItemDialog.show(context, item),
                    ))
                .toList());
      }),
    );
  }
}
