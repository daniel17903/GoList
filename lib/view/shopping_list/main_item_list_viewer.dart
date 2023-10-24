import 'package:flutter/material.dart';
import 'package:go_list/model/selected_shopping_list_state.dart';
import 'package:go_list/view/dialog/dialog_utils.dart';
import 'package:go_list/view/dialog/edit_list_dialog.dart';
import 'package:go_list/view/shopping_list/item_list_viewer.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/shopping_list_item.dart';
import 'package:provider/provider.dart';

import 'shopping_list_item/shopping_list_item_wrap.dart';

class MainItemListViewer extends StatelessWidget {
  final double parentWidth;

  const MainItemListViewer({Key? key, required this.parentWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedShoppingListState>(
        builder: (context, selectedShoppingListState, child) {
      return ItemListViewer(
        darkBackground: false,
        parentWidth: parentWidth,
        onPullForRefresh: () =>
            Provider.of<SelectedShoppingListState>(context, listen: false)
                .loadListFromStorage(),
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedShoppingListState.selectedShoppingList.name,
                style: const TextStyle(color: Colors.white, fontSize: 22)),
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.white,
              onPressed: () => DialogUtils.showSmallAlertDialog(
                  context: context,
                  contentBuilder: (_) => EditListDialog(
                      shoppingList:
                          selectedShoppingListState.selectedShoppingList)),
            )
          ],
        ),
        body: ShoppingListItemWrap(
            children: selectedShoppingListState
                .selectedShoppingList.items.entries
                .map((item) =>
                    ShoppingListItem.forItem(item, context, parentWidth))
                .toList()),
      );
    });
  }
}
