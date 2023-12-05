import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_list/model/collections/recently_used_item_collection.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/service/items/input_to_item_parser.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/shopping_list/item_grid_view.dart';
import 'package:provider/provider.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();

  static void show({required BuildContext context}) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
                .animate(a1),
            child: widget,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) =>
            const AddItemDialog());
  }
}

class _AddItemDialogState extends State<AddItemDialog> {
  Item? previewItem;
  RecentlyUsedItemCollection _recentlyUsedItemsSorted =
      RecentlyUsedItemCollection();

  @override
  void initState() {
    super.initState();
    _recentlyUsedItemsSorted =
        Provider.of<GlobalAppState>(context, listen: false)
            .selectedShoppingList
            .recentlyUsedItems;
  }

  void addNewItemToList(Item? item) {
    if (item != null) {
      Provider.of<GlobalAppState>(context, listen: false)
          .upsertItem(item.copyAsNewItem());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // SafeArea is necessary to have some margin at the top
    return SafeArea(
      // Dialog is necessary to move up when keyboard opens
      child: Dialog(
        // Material is necessary for nice TextField
        child: Material(
          child: Container(
              padding: const EdgeInsets.all(8.0),
              color: GoListColors.addItemDialogBackground,
              child: Column(children: [
                TextField(
                  autofocus: true,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).what_to_buy,
                    hintStyle: const TextStyle(color: Colors.white),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white)),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  onSubmitted: (_) => addNewItemToList(previewItem),
                  textInputAction: TextInputAction.done,
                  onChanged: (searchText) {
                    setState(() {
                      _recentlyUsedItemsSorted.searchBy(searchText);
                      bool previewItemMatchesFirstRecentlyUsedItem =
                          searchText == _recentlyUsedItemsSorted.first()?.name;
                      bool previewItemDidChange =
                          previewItem?.name != searchText;
                      if (searchText.isEmpty ||
                          previewItemMatchesFirstRecentlyUsedItem) {
                        previewItem = null;
                      } else if (previewItemDidChange) {
                        previewItem =
                            InputToItemParser().parseInput(searchText);
                      }
                    });
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ItemGridView(
                    items: [
                      ...previewItem == null ? [] : [previewItem!],
                      ..._recentlyUsedItemsSorted.itemsToShow()
                    ],
                    animate: false,
                    onItemTapped: addNewItemToList,
                    itemBackgroundColor:
                        GoListColors.addItemDialogItemBackground,
                    maxItemSize: 125,
                  ),
                )
              ])),
        ),
      ),
    );
  }
}
