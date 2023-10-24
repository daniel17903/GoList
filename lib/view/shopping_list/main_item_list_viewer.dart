import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/selected_shopping_list_state.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/dialog/dialog_utils.dart';
import 'package:go_list/view/dialog/edit_item_dialog.dart';
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
        footer: selectedShoppingListState.selectedShoppingList.deviceCount != 1
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.0),
                      color: GoListColors.sharedDevicesTextBackground,
                    ),
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
                    child: Text(
                        AppLocalizations.of(context)!.shared_devices_info(
                            selectedShoppingListState
                                    .selectedShoppingList.deviceCount -
                                1),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontStyle: FontStyle.italic)),
                  ),
                ),
              )
            : null,
      );
    });
  }
}
