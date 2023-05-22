import 'package:go_list/model/item.dart';
import 'package:go_list/model/item_collection.dart';
import 'package:go_list/model/recently_used_item_collection.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:uuid/uuid.dart';

class ShoppingListBuilder {
  String _id = const Uuid().v4();
  String _name = "name";
  ItemCollection _items = ItemCollection();
  RecentlyUsedItemCollection _recentlyUsedItems = RecentlyUsedItemCollection();
  DateTime _modified = DateTime(2020, 1, 1);

  withItems(List<Item> items) {
    _items = ItemCollection(entries: items);
    return this;
  }

  withRecentlyUsedItems(List<Item> recentlyUsedItems) {
    _recentlyUsedItems = RecentlyUsedItemCollection(recentlyUsedItems);
    return this;
  }

  withId(String id) {
    _id = id;
    return this;
  }

  withModified(DateTime modified) {
    _modified = modified;
    return this;
  }

  withName(String name) {
    _name = name;
    return this;
  }

  build() {
    return ShoppingList(
        id: _id,
        name: _name,
        items: _items,
        recentlyUsedItems: _recentlyUsedItems,
        modified: _modified);
  }
}
