import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_list/model/app_state.dart';
import 'package:go_list/service/input_to_item_parser.dart';
import 'package:go_list/view/item_list_viewer.dart';
import 'package:provider/provider.dart';

import '../../model/item.dart';

class SearchDialog extends StatefulWidget {
  const SearchDialog({Key? key}) : super(key: key);

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  Item? newItem;
  Timer? _debounce;
  List<Item> recentlyUsedItemsSorted = [];

  void _debounced(Function function) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () => function());
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      recentlyUsedItemsSorted = Provider.of<AppState>(context, listen: false)
          .currentShoppingList
          .recentlyUsedItems;
    });
    super.initState();
  }

  void addNewItemToList(Item? item) {
    if (item != null) {
      Provider.of<AppState>(context, listen: false)
          .currentShoppingList
          .addItem(item);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Theme.of(context).backgroundColor,
          child: TextField(
            autofocus: true,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Was möchtest du einkaufen?',
              hintStyle: TextStyle(color: Colors.white),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.white)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.white)),
            ),
            onSubmitted: (_) => addNewItemToList(newItem),
            onChanged: (text) {
              _debounced(() {
                setState(() {
                  if (recentlyUsedItemsSorted.isNotEmpty) {
                    recentlyUsedItemsSorted.sort((item1, item2) {
                      startsWithIgnoreCase(String value, String start) {
                        return value
                            .toLowerCase()
                            .startsWith(start.toLowerCase());
                      }

                      if (startsWithIgnoreCase(item2.name, text)) {
                        return 1;
                      } else if (startsWithIgnoreCase(item1.name, text)) {
                        return -1;
                      }
                      return 0;
                    });
                  }
                  if (text.isEmpty ||
                      recentlyUsedItemsSorted.isNotEmpty &&
                          text == recentlyUsedItemsSorted[0].name) {
                    newItem = null;
                  } else {
                    newItem = InputToItemParser.parseInput(text);
                  }
                });
              });
            },
          ),
        ),
        Expanded(
          child: ItemListViewer(
              onItemTapped: (item) => addNewItemToList(item),
              items: [
                if (newItem != null) newItem!,
                ...recentlyUsedItemsSorted
              ]),
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
