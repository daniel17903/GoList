import 'package:go_list/model/collections/item_collection.dart';
import 'package:go_list/model/item.dart';

import '../golist_model.dart';

class RecentlyUsedItemCollection {
  static const maxItems = 1000;
  final ItemCollection items;

  RecentlyUsedItemCollection([ItemCollection? items])
      : items = items ?? ItemCollection([]) {
    sort();
  }

  static RecentlyUsedItemCollection fromJson(List<dynamic>? json) {
    return RecentlyUsedItemCollection(ItemCollection(json != null
        ? json.map<Item>((itemJson) => Item.fromJson(itemJson)).toList()
        : []));
  }

  static RecentlyUsedItemCollection fromItemCollection(
      ItemCollection itemCollection) {
    return itemCollection.copyForRecentlyUsed();
  }

  List<Map<String, dynamic>> toJson() {
    return items.toJson();
  }

  Item? first() => items.first();

  int get length => items.length;

  RecentlyUsedItemCollection merge(RecentlyUsedItemCollection other) {
    return RecentlyUsedItemCollection(items.merge(other.items));
  }

  List map<T>(T Function(Item) mapFunc) {
    return items.map(mapFunc).toList();
  }

  RecentlyUsedItemCollection searchBy(String? searchText) {
    items.sort((entry1, entry2) {
      startsWithIgnoreCase(String value, String start) {
        return value.toLowerCase().startsWith(start.toLowerCase());
      }

      if (searchText != null && searchText.isNotEmpty) {
        bool entry1StartWithSearchText =
            startsWithIgnoreCase(entry1.name, searchText);
        bool entry2StartWithSearchText =
            startsWithIgnoreCase(entry2.name, searchText);
        if (entry2StartWithSearchText && !entry1StartWithSearchText) {
          return 1;
        } else if (entry1StartWithSearchText && !entry2StartWithSearchText) {
          return -1;
        }
        // both start with search text or both do not start with search text
        // -> use alphabetic order
        return entry1.name.compareTo(entry2.name);
      } else {
        return GoListModel.compareByModified(entry1, entry2);
      }
    });
    return this;
  }

  void sort() {
    items.sort(GoListModel.compareByModified);
  }

  void upsert(Item entry) {
    if (entry.name.isEmpty) {
      // Items can have an empty name, either if the user deleted it after
      // creation or if the item only has an amount.
      return;
    }
    items.removeWhere(GoListModel.equalsByName(entry));
    items.upsert(entry);
    sort();
    items.removeItemsWithIndexGreater(maxItems);
  }

  void removeDuplicateNamesAndAmount() {
    Set<Item> existingItems = {};
    items.removeWhere((Item item) {
      bool nameExists = existingItems.any(GoListModel.equalsByName(item));
      existingItems.add(item);
      return nameExists;
    });
    items.entries.where((item) => item.amount != "").forEach((item) {
      item.amount = "";
    });
    items.entries
        .where((item) => item.name.startsWith(" ") || item.name.endsWith(" "))
        .forEach((item) {
      item.name = item.name.trim();
    });
  }

  bool equals(RecentlyUsedItemCollection other) {
    return items.equals(other.items);
  }

  List<Item> itemsToShow() {
    return items.entries.take(50).toList();
  }
}
