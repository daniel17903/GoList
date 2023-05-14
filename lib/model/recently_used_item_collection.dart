import 'dart:math';

import 'package:go_list/model/golist_collection.dart';
import 'package:go_list/model/item.dart';

import 'golist_model.dart';

class RecentlyUsedItemCollection extends GoListCollection<Item> {
  static const maxItems = 100;

  RecentlyUsedItemCollection([List<Item>? items]) : super(items ?? []);

  static RecentlyUsedItemCollection fromItemCollection(
      GoListCollection<Item> itemCollection) {
    return RecentlyUsedItemCollection(itemCollection.copyEntries());
  }

  searchBy(String? searchText) {
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

  @override
  RecentlyUsedItemCollection sort([int Function(Item, Item)? compare]) {
    super.sort(GoListModel.compareByModified);
    return this;
  }

  @override
  RecentlyUsedItemCollection upsert(Item entry) {
    entries.removeWhere(GoListModel.equalsByName(entry));
    super.upsert(entry);
    sort();
    entries.removeRange(maxItems - 1, max(entries.length, maxItems - 1));
    return this;
  }
}
