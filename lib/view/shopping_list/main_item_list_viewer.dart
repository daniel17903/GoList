import 'package:flutter/material.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/dialog/dialog_utils.dart';
import 'package:go_list/view/dialog/edit_item_dialog.dart';
import 'package:go_list/view/dialog/edit_list_dialog.dart';
import 'package:go_list/view/shopping_list/item_grid_view.dart';
import 'package:go_list/view/undo_button.dart';
import 'package:provider/provider.dart';

class MainItemListViewer extends StatelessWidget {
  const MainItemListViewer({super.key});

  @override
  Widget build(BuildContext context) {
    // SafeArea is required for the android toolbar not to overlap the title
    return SafeArea(
      child:
          Consumer<GlobalAppState>(builder: (context, globalAppState, child) {
        return Container(
            constraints: const BoxConstraints.expand(),
            child: RefreshIndicator(
                onRefresh: () => globalAppState.loadListsFromStorage(),
                child: Container(
                    padding: const EdgeInsets.only(
                        left: spacing, right: spacing, top: 6),
                    alignment: Alignment.center,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(globalAppState.selectedShoppingList.name,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 22)),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: Colors.white,
                                onPressed: () =>
                                    DialogUtils.showSmallAlertDialog(
                                        context: context,
                                        contentBuilder: (_) => EditListDialog(
                                            shoppingList: globalAppState
                                                .selectedShoppingList)),
                              )
                            ],
                          ),
                          Expanded(
                              child: ItemGridView(
                            // by using this key, the state of ItemGridView is
                            // recreated for each shopping list, preventing item
                            // animations when selecting another list
                            key: Key(globalAppState.selectedShoppingList.id),
                            items: globalAppState
                                .selectedShoppingList.items.entries
                                .where((item) => item.deleted == false)
                                .toList(),
                            onItemTapped: (item) => Provider.of<GlobalAppState>(
                                    context,
                                    listen: false)
                                .deleteItem(item.id),
                            onItemTappedLong: (item) =>
                                EditItemDialog.show(context, item),
                            itemBackgroundColor: GoListColors.itemBackground,
                            maxItemSize: 140,
                            animate: true,
                          )),
                          const UndoButton()
                        ]))));
      }),
    );
  }
}
