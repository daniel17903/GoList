import 'package:go_list/model/golist_model.dart';
import 'package:go_list/model/item_collection.dart';
import 'package:go_list/model/mergeable.dart';
import 'package:go_list/model/recently_used_item_collection.dart';

import 'item.dart';

class ShoppingList extends GoListModel implements MergeAble<ShoppingList> {
  late ItemCollection items;
  late RecentlyUsedItemCollection recentlyUsedItems;

  ShoppingList(
      {required String name,
      ItemCollection? items,
      RecentlyUsedItemCollection? recentlyUsedItems,
      bool? deleted,
      DateTime? modified,
      String? id,
      int? deviceCount})
      : super(name: name, modified: modified, deleted: deleted, id: id) {
    this.items = items ?? ItemCollection();
    this.recentlyUsedItems = recentlyUsedItems ??
        RecentlyUsedItemCollection.fromItemCollection(this.items);
    this.items.sort();
    this.recentlyUsedItems.sort();
  }

  ShoppingList.fromJson(dynamic json)
      : super(
            id: json["id"],
            name: json["name"],
            deleted: json["deleted"],
            modified: json["modified"] is String
                ? DateTime.parse(json["modified"])
                : DateTime.fromMillisecondsSinceEpoch(json["modified"])) {
    items = ItemCollection.fromJson(json["items"]);
    recentlyUsedItems =
        RecentlyUsedItemCollection.fromJson(json["recentlyUsedItems"]);
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'items': items.map((item) => item.toJson()).toList(),
        'recentlyUsedItems':
            recentlyUsedItems.map((item) => item.toJson()).toList()
      };

  ShoppingList copyWith(
      {String? name,
      ItemCollection? items,
      bool? deleted,
      DateTime? modified,
      String? id,
      int? deviceCount}) {
    return ShoppingList(
        name: name ?? this.name,
        items: items ?? this.items,
        deleted: deleted ?? this.deleted,
        modified: modified ?? DateTime.now(),
        id: id ?? this.id);
  }

  ShoppingList upsertItem(Item item) {
    items.upsert(item);
    recentlyUsedItems.upsert(item.copyAsRecentlyUsedItem());
    return this;
  }

  @override
  ShoppingList merge(ShoppingList other) {
    ShoppingList merged = lastModified(this, other);
    merged.items = items.merge(other.items);
    return merged;
  }

  List<Item> itemsAsList() {
    return items.entries;
  }
}
