import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/recently_used_item_collection.dart';
import 'package:go_list/model/selected_shopping_list_state.dart';
import 'package:go_list/service/items/input_to_item_parser.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/shopping_list/item_list_viewer.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/shopping_list_item.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/shopping_list_item_wrap.dart';
import 'package:provider/provider.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({Key? key}) : super(key: key);

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
  static const horizontalPadding = 40.0;
  Item? previewItem;
  RecentlyUsedItemCollection _recentlyUsedItemsSorted =
      RecentlyUsedItemCollection();

  @override
  void initState() {
    super.initState();
    _recentlyUsedItemsSorted =
        Provider.of<SelectedShoppingListState>(context, listen: false)
            .selectedShoppingList
            .recentlyUsedItems;
  }

  void addNewItemToList(Item? item) {
    if (item != null) {
      Provider.of<SelectedShoppingListState>(context, listen: false)
          .upsertItem(item.newFromTemplate());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(
          left: horizontalPadding, right: horizontalPadding, top: 45),
      child: Material(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            color: GoListColors.addItemDialogBackground,
            child: TextField(
              autofocus: true,
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.what_to_buy,
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
                      _recentlyUsedItemsSorted.isNotEmpty() &&
                          searchText == _recentlyUsedItemsSorted.first()!.name;
                  bool previewItemDidChange = previewItem?.name != searchText;
                  if (searchText.isEmpty ||
                      previewItemMatchesFirstRecentlyUsedItem) {
                    previewItem = null;
                  } else if (previewItemDidChange) {
                    previewItem = InputToItemParser().parseInput(searchText);
                  }
                });
              },
            ),
          ),
          Expanded(
              child: ItemListViewer(
            darkBackground: true,
            horizontalPadding: horizontalPadding,
            body: ShoppingListItemWrap(
                children: (previewItem == null
                        ? _recentlyUsedItemsSorted
                        : _recentlyUsedItemsSorted.prepend(previewItem!))
                    .entries
                    .map((item) => ShoppingListItem(
                          backgroundColor:
                              GoListColors.addItemDialogItemBackground,
                          item: item,
                          onItemTapped: addNewItemToList,
                          horizontalPadding: horizontalPadding,
                        ))
                    .toList()),
          ))
        ]),
      ),
    );
  }
}