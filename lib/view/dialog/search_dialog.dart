import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_list/model/app_state.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/list_of.dart';
import 'package:go_list/service/items/icon_mapping.dart';
import 'package:go_list/service/items/input_to_item_parser.dart';
import 'package:go_list/view/shopping_list/item_list_viewer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

const recentlyUsedItemsSize = 50;

class SearchDialog extends StatefulHookConsumerWidget {
  const SearchDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends ConsumerState<SearchDialog> {
  Item? newItem;
  Timer? _debounce;
  ListOf<Item> recentlyUsedItemsSorted = ListOf([]);

  void _debounced(Function function) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () => function());
  }

  @override
  void initState() {
    AppState appState = ref.read<AppState>(AppStateNotifier.appStateProvider);
    setState(() {
      String normalize(String s) => s.trim().toLowerCase();
      Set<String> addedLowerCaseItemNames = {};
      recentlyUsedItemsSorted =
          ListOf<Item>([...appState.currentShoppingList!.items])
              .whereEntry((e) => e.deleted)
              .sort(compareItems())
              .whereEntry((e) => addedLowerCaseItemNames.add(normalize(e.name)))
              .take(recentlyUsedItemsSize)
              .mapEntries((e) => e.copyWith(amount: "", modified: e.modified));

      // if there is a newer item with this name use the new icon and category
      recentlyUsedItemsSorted =
          recentlyUsedItemsSorted.mapEntries((recentlyUsedItem) {
        Item latestItemWithSameName = appState.currentShoppingList!.items
            .whereEntry(
                (e) => normalize(e.name) == normalize(recentlyUsedItem.name))
            .sort((a, b) => b.modified.compareTo(a.modified))
            .first;
        return recentlyUsedItem.copyWith(
            iconName: latestItemWithSameName.iconName,
            category: latestItemWithSameName.category);
      });
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

  int Function(Item, Item) compareItems({String? inputText}) {
    return (item1, item2) {
      startsWithIgnoreCase(String value, String start) {
        return value.toLowerCase().startsWith(start.toLowerCase());
      }

      if (inputText != null && inputText.isNotEmpty) {
        if (startsWithIgnoreCase(item2.name, inputText)) {
          return 1;
        } else if (startsWithIgnoreCase(item1.name, inputText)) {
          return -1;
        }
        return 0;
      } else {
        return item2.modified.compareTo(item1.modified);
      }
    };
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
            onSubmitted: (_) => addNewItemToList(newItem, appStateNotifier),
            textInputAction: TextInputAction.done,
            onChanged: (text) {
              _debounced(() {
                setState(() {
                  recentlyUsedItemsSorted.sort(compareItems(inputText: text));
                  if (text.isEmpty ||
                      recentlyUsedItemsSorted.isNotEmpty &&
                          text == recentlyUsedItemsSorted[0].name) {
                    newItem = null;
                  } else {
                    newItem = InputToItemParser().parseInput(text);
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
                    InputToItemParser().findMappingForName(item.name);
                addNewItemToList(
                    item.copyWith(
                        id: const Uuid().v4(),
                        iconName: iconMapping.assetFileName,
                        category: iconMapping.category),
                    appStateNotifier);
              },
              items: ListOf([
                if (newItem != null) newItem!,
                ...recentlyUsedItemsSorted
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
