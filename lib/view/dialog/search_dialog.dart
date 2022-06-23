import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_list/model/app_state.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/service/items/icon_mapping.dart';
import 'package:go_list/service/items/input_to_item_parser.dart';
import 'package:go_list/view/shopping_list/item_list_viewer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../model/item.dart';

class SearchDialog extends StatefulHookConsumerWidget {
  const SearchDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends ConsumerState<SearchDialog> {
  Item? newItem;
  Timer? _debounce;
  List<Item> recentlyUsedItemsSorted = [];

  void _debounced(Function function) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () => function());
  }

  @override
  void initState() {
    AppState appState = ref.read<AppState>(AppStateNotifier.appStateProvider);
    setState(() {
      recentlyUsedItemsSorted = [...appState.currentShoppingList!.items]
          .where((e) => e.deleted)
          .map((e) => e.copyWith(amount: ""))
          .toList();
      sortItems();

      // remove items with same name
      Set<String> addedLowerCaseItemNames = {};
      for (int i = 0; i < recentlyUsedItemsSorted.length; i++) {
        if (addedLowerCaseItemNames
            .contains(recentlyUsedItemsSorted[i].name.toLowerCase().trim())) {
          recentlyUsedItemsSorted.removeAt(i);
          i--;
        } else {
          addedLowerCaseItemNames
              .add(recentlyUsedItemsSorted[i].name.toLowerCase().trim());
        }
      }
    });

    super.initState();
  }

  void addNewItemToList(Item? item, AppStateNotifier appStateNotifier) {
    if (item != null) {
      item = item.copyWith(deleted: false);
      Navigator.pop(context);
      ref.read(AppStateNotifier.appStateProvider.notifier).addItem(item);
    }
  }

  void sortItems({String? inputText}) {
    if (recentlyUsedItemsSorted.isNotEmpty) {
      recentlyUsedItemsSorted.sort((item1, item2) {
        startsWithIgnoreCase(String value, String start) {
          return value.toLowerCase().startsWith(start.toLowerCase());
        }

        if (inputText != null) {
          if (startsWithIgnoreCase(item2.name, inputText)) {
            return 1;
          } else if (startsWithIgnoreCase(item1.name, inputText)) {
            return -1;
          }
          return 0;
        } else {
          return item2.modified.compareTo(item1.modified);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppStateNotifier appStateNotifier =
        ref.watch(AppStateNotifier.appStateProvider.notifier);
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
            onSubmitted: (_) => addNewItemToList(newItem, appStateNotifier),
            textInputAction: TextInputAction.done,
            onChanged: (text) {
              _debounced(() {
                setState(() {
                  sortItems(inputText: text);
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
              parentWidth: MediaQuery.of(context).size.width - 80.0,
              itemColor: const Color(0x63d5feb5),
              darkBackground: true,
              onItemTapped: (item) {
                // parse icon name from history again in case mapping changed
                IconMapping iconMapping =
                    InputToItemParser.findMappingForName(item.name);
                addNewItemToList(
                    item.copyWith(
                        id: const Uuid().v4(),
                        iconName: iconMapping.assetFileName,
                        category: iconMapping.category),
                    appStateNotifier);
              },
              items: [if (newItem != null) newItem!, ...recentlyUsedItemsSorted]
                  .take(20)
                  .toList()),
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
