import 'package:flutter/cupertino.dart';
import 'package:go_list/model/golist_collection.dart';
import 'package:go_list/model/golist_model.dart';
import 'package:go_list/model/item_collection.dart';
import 'package:go_list/model/mergeable.dart';
import 'package:go_list/model/recently_used_item_collection.dart';

import 'item.dart';

class ShoppingList extends GoListModel implements MergeAble<ShoppingList> {
  late ItemCollection items;
  late RecentlyUsedItemCollection recentlyUsedItems;
  late int deviceCount;

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
    this.deviceCount = deviceCount ?? 1;
  }

  ShoppingList.fromJson(Map<String, dynamic> json)
      : super(
            id: json["id"],
            name: json["name"],
            deleted: json["deleted"],
            modified: json["modified"] is String
                ? DateTime.parse(json["modified"])
                : DateTime.fromMillisecondsSinceEpoch(json["modified"])) {
    items = ItemCollection.fromJson(json["items"]);
    recentlyUsedItems =
        RecentlyUsedItemCollection(_itemsFromJson(json, "recently_used_items"))
            .sort();
    deviceCount = json.containsKey("device_count") ? json["device_count"] : 1;
  }

  List<Item> _itemsFromJson(Map<String, dynamic> json, String key) {
    if (json.containsKey(key)) {
      return json[key].map<Item>((element) => Item.fromJson(element)).toList();
    }
    return [];
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'items': items.map((item) => item.toJson()).toList(),
        'recently_used_items':
            recentlyUsedItems.map((item) => item.toJson()).toList(),
        'device_count': deviceCount
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
        id: id ?? this.id,
        deviceCount: deviceCount ?? this.deviceCount);
  }

  ShoppingList upsertItem(Item item) {
    items.upsert(item);
    recentlyUsedItems.upsert(item.copyAsRecenltyUsedItem());
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

  @override
  T copy<T extends GoListModel>() {
    // TODO: implement copy
    throw UnimplementedError();
  }
}
