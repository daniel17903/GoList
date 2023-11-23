import 'package:collection/collection.dart';
import 'package:go_list/model/collections/golist_collection.dart';
import 'package:go_list/model/item.dart';

class ItemCollection extends GoListCollection<Item> {
  ItemCollection(super.entries);

  static ItemCollection fromJson(List<dynamic> json) {
    return ItemCollection(json.map<Item>(Item.fromJson).toList());
  }

  ItemCollection merge(ItemCollection other) {
    return ItemCollection(mergeLists(entries, other.entries));
  }

  ItemCollection copyForRecentlyUsed() {
    Set<String> uniqueNames = {};
    return ItemCollection(entries
        .where((item) => uniqueNames.add(item.name.toLowerCase().trim()))
        .map((entry) => entry.copyForRecentlyUsed())
        .toList());
  }

  void removeItemsWithIndexGreater(int limit) {
    var itemsToDelete = entries.length - limit;
    if (itemsToDelete > 0) {
      entries.length = entries.length - itemsToDelete;
    }
  }

  void removeItemsDeletedSinceTenDays() {
    removeWhere((e) => e.deleted == true && e.modifiedAtLeastNDaysBefore(10));
  }

  void prepend(Item item) {
    entries.insert(0, item);
  }

  @override
  bool equals(GoListCollection<Item> other) {
    return length == other.length &&
        IterableZip([entries, other.entries])
            .every((pair) => pair[0].equals(pair[1]));
  }
}
