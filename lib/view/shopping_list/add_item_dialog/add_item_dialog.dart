import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/recently_used_item_collection.dart';
import 'package:go_list/model/selected_shopping_list_state.dart';
import 'package:go_list/service/items/input_to_item_parser.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/shopping_list/add_item_dialog/add_item_list_viewer.dart';
import 'package:provider/provider.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({Key? key}) : super(key: key);

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
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
    return Material(
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
              bool previewItemMatchesFirstRecentlyUsedItem =
                  _recentlyUsedItemsSorted.isNotEmpty() &&
                      searchText == _recentlyUsedItemsSorted.first()!.name;
              bool previewItemDidChange = previewItem?.name != searchText;
              setState(() {
                _recentlyUsedItemsSorted.searchBy(searchText);
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
          child: AddItemListViewer(
              parentWidth: MediaQuery.of(context).size.width - 80.0,
              onItemTapped: addNewItemToList,
              recentlyUsedItemsSorted: previewItem == null
                  ? _recentlyUsedItemsSorted
                  : _recentlyUsedItemsSorted.prepend(previewItem!)),
        )
      ]),
    );
  }
}
