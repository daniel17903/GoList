import 'dart:math';

import 'package:go_list/model/golist_collection.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/item_collection.dart';

import 'golist_model.dart';

class RecentlyUsedItemCollection extends GoListCollection<Item> {
  static const maxItems = 1000;

  RecentlyUsedItemCollection([List<Item>? items]) : super(items ?? []);

  static RecentlyUsedItemCollection fromJson(List<dynamic>? json) {
    RecentlyUsedItemCollection recentlyUsedItemCollection =
        RecentlyUsedItemCollection();
    if (json != null) {
      json.map<Item>((itemJson) => Item.fromJson(itemJson)).forEach((item) {
        recentlyUsedItemCollection.upsert(item);
      });
    }
    return recentlyUsedItemCollection;
  }

  static RecentlyUsedItemCollection fromItemCollection(
      ItemCollection itemCollection) {
    return RecentlyUsedItemCollection(itemCollection.copyEntries());
  }

  RecentlyUsedItemCollection searchBy(String? searchText) {
    super.sort((entry1, entry2) {
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

  RecentlyUsedItemCollection prepend(Item item) {
    return RecentlyUsedItemCollection([item, ...entries]);
  }

  @override
  void sort([int Function(Item, Item)? compare]) {
    super.sort(GoListModel.compareByModified);
  }

  @override
  void upsert(Item entry) {
    if(entry.name.isEmpty){
      // Items can have an empty name, either if the user deleted it after
      // creation or if the item only has an amount.
      return;
    }
    entries.removeWhere(GoListModel.equalsByName(entry));
    super.upsert(entry);
    sort();
    if (entries.length > maxItems) {
      entries.removeRange(maxItems - 1, max(entries.length, maxItems - 1));
    }
  }
}
