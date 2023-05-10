import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_list/model/golist_collection.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/selected_shopping_list_state.dart';
import 'package:go_list/service/items/input_to_item_parser.dart';
import 'package:go_list/view/shopping_list/item_list_viewer.dart';
import 'package:provider/provider.dart';

class SearchDialog extends StatefulWidget {
  const SearchDialog({Key? key}) : super(key: key);

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  Item? previewItem;
  Timer? _debounce;
  GoListCollection<Item> _recentlyUsedItemsSorted = GoListCollection();

  void _debounced(Function function) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () => function());
  }

  @override
  void initState() {
    super.initState();
    _recentlyUsedItemsSorted =
        Provider.of<SelectedShoppingListState>(context, listen: false)
            .selectedShoppingList
            .recentlyUsedItems;
  }

  void addNewItemToList([Item? item]) {
    if (previewItem != null || item != null) {
      Provider.of<SelectedShoppingListState>(context, listen: false)
          .upsertItem(item ?? previewItem!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Theme.of(context).dialogBackgroundColor,
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
            onSubmitted: (_) => addNewItemToList(),
            textInputAction: TextInputAction.done,
            onChanged: (text) {
              _debounced(() {
                setState(() {
                  _recentlyUsedItemsSorted.searchBy(text);
                  if (text.isEmpty ||
                      _recentlyUsedItemsSorted.isNotEmpty() &&
                          text == _recentlyUsedItemsSorted.first()!.name) {
                    previewItem = null;
                  } else {
                    previewItem = InputToItemParser().parseInput(text);
                  }
                });
              });
            },
          ),
        ),
        Expanded(
          child: ItemListViewer(
              parentWidth: MediaQuery.of(context).size.width - 80.0,
              itemColor: const Color(0x63d5feb5),
              darkBackground: true,
              onItemTapped: addNewItemToList,
              items: GoListCollection([
                if (previewItem != null) previewItem!,
                ..._recentlyUsedItemsSorted.entries()
              ].toList())),
        )
      ]),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
