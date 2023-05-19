import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_list/model/selected_shopping_list_state.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/dialog/dialog_utils.dart';
import 'package:go_list/view/dialog/edit_item_dialog.dart';
import 'package:go_list/view/dialog/edit_list_dialog.dart';
import 'package:go_list/view/shopping_list/item_list_viewer.dart';
import 'package:provider/provider.dart';

class ShoppingListWidget extends StatelessWidget {
  const ShoppingListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedShoppingListState>(
        builder: (context, selectedShoppingListState, child) => ItemListViewer(
              itemColor: GoListColors.itemBackground,
              parentWidth: MediaQuery.of(context).size.width,
              darkBackground: false,
              items: selectedShoppingListState.selectedShoppingList.items,
              header: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(selectedShoppingListState.selectedShoppingList.name,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 22)),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: Colors.white,
                    onPressed: () => DialogUtils.showSmallAlertDialog(
                        context: context,
                        contentBuilder: (_) => EditListDialog(
                            shoppingList: selectedShoppingListState
                                .selectedShoppingList)),
                  )
                ],
              ),
              footer: selectedShoppingListState
                          .selectedShoppingList.deviceCount !=
                      1
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
              onPullForRefresh: () =>
                  selectedShoppingListState.loadListFromStorage(),
              onItemTapped: (tappedItem) =>
                  selectedShoppingListState.deleteItem(tappedItem),
              onItemTappedLong: (item) => DialogUtils.showSmallAlertDialog(
                  context: context,
                  contentBuilder: (_) => EditItemDialog(item: item)),
              delayItemTap: true,
            ));
  }
}
