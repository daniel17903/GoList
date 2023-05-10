import 'package:flutter/cupertino.dart';
import 'package:go_list/model/golist_collection.dart';
import 'package:go_list/model/golist_model.dart';
import 'package:go_list/model/mergeable.dart';

import 'item.dart';

class ShoppingList extends GoListModel implements MergeAble<ShoppingList> {
  late GoListCollection<Item> items;
  late GoListCollection<Item> recentlyUsedItems;
  late int deviceCount;

  ShoppingList(
      {required String name,
      GoListCollection<Item>? items,
      GoListCollection<Item>? recentlyUsedItems,
      bool? deleted,
      DateTime? modified,
      String? id,
      int? deviceCount})
      : super(name: name, modified: modified, deleted: deleted, id: id) {
    this.items = items ?? GoListCollection<Item>();
    this.recentlyUsedItems = recentlyUsedItems ?? this.items;
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
    items = _itemsFromJson(json, "items");
    recentlyUsedItems = _itemsFromJson(json, "recently_used_items");
    deviceCount = json.containsKey("device_count") ? json["device_count"] : 1;
  }

  GoListCollection<Item> _itemsFromJson(Map<String, dynamic> json, String key) {
    if (json.containsKey(key) && json["key"] is Map<String, dynamic>) {
      return GoListCollection<Item>(
          json[key].map<Item>((element) => Item.fromJson(element)).toList());
    }
    return GoListCollection();
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
      GoListCollection<Item>? items,
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
    items = items.upsert(item).sort();
    recentlyUsedItems = recentlyUsedItems.upsert(item).sort()..skip(100);
    return this;
  }

  @override
  ShoppingList merge(ShoppingList other) {
    ShoppingList merged = lastModified(this, other);
    merged.items = items.merge(other.items);
    return merged;
  }

  List<Item> itemsAsList() {
    return items.entries();
  }
}
