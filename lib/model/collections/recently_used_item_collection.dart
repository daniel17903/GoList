import 'package:go_list/model/collections/item_collection.dart';
import 'package:go_list/model/item.dart';

import '../golist_model.dart';

class RecentlyUsedItemCollection {
  static const maxItems = 1000;
  final ItemCollection items;
  String? previewItemId;

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
    return RecentlyUsedItemCollection(itemCollection.copyForRecentlyUsed());
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
        if (startsWithIgnoreCase(entry2.name, searchText)) {
          return 1;
        } else if (startsWithIgnoreCase(entry1.name, searchText)) {
          return -1;
        }
        return 0;
      } else {
        return GoListModel.compareByModified(entry1, entry2);
      }
    });
    return this;
  }

  RecentlyUsedItemCollection optionalPrepend(Item? item) {
    if (previewItemId != null) {
      items.removeEntryWithId(previewItemId!);
    }
    if (item != null) {
      previewItemId = item.id;
      items.prepend(item);
    }
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

  bool equals(RecentlyUsedItemCollection other) {
    return items.equals(other.items);
  }

  List<Item> itemsToShow() {
    return items.entries.take(50).toList();
  }
}
