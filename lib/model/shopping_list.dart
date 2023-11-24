import 'package:go_list/model/collections/item_collection.dart';
import 'package:go_list/model/collections/recently_used_item_collection.dart';
import 'package:go_list/model/golist_model.dart';

import 'item.dart';

class ShoppingList extends GoListModel {
  late ItemCollection items;
  late RecentlyUsedItemCollection recentlyUsedItems;

  ShoppingList(
      {required super.name,
      ItemCollection? items,
      RecentlyUsedItemCollection? recentlyUsedItems,
      super.deleted,
      super.modified,
      super.id}) {
    this.items = items ?? ItemCollection([]);
    this.items.sort();
    this.recentlyUsedItems =
        recentlyUsedItems ?? this.items.copyForRecentlyUsed();
  }

  ShoppingList.fromJson(dynamic json)
      : super(
            id: json["id"],
            name: json["name"],
            deleted: json["deleted"],
            modified: DateTime.parse(json["modified"])) {
    items = ItemCollection.fromJson(json["items"]);
    items.sort();
    recentlyUsedItems =
        RecentlyUsedItemCollection.fromJson(json["recentlyUsedItems"]);
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'items': items.toJson(),
        'recentlyUsedItems': recentlyUsedItems.toJson()
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

  void deleteItem(Item item) {
    item.deleted = true;
    modified = DateTime.now();
  }

  void upsertItem(Item item) {
    items.upsert(item);
    modified = DateTime.now();
    recentlyUsedItems.upsert(item.copyForRecentlyUsed());
    items.sort();
  }

  @override
  GoListModel merge(GoListModel other) {
    ShoppingList lastUpdatedShoppingList =
        lastModified(this, other as ShoppingList);
    return ShoppingList(
        id: lastUpdatedShoppingList.id,
        name: lastUpdatedShoppingList.name,
        items: items.merge(other.items),
        recentlyUsedItems: recentlyUsedItems.merge(other.recentlyUsedItems),
        deleted: lastUpdatedShoppingList.deleted,
        modified: lastUpdatedShoppingList.modified);
  }

  List<Item> itemsAsList() {
    return items.entries;
  }

  @override
  bool equals(GoListModel other) {
    return other is ShoppingList &&
        other.id == id &&
        other.name == name &&
        other.deleted == deleted &&
        items.equals(other.items) &&
        recentlyUsedItems.equals(other.recentlyUsedItems);
  }
}
