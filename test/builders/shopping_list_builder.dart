import 'package:go_list/model/item.dart';
import 'package:go_list/model/golist_collection.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:uuid/uuid.dart';

class ShoppingListBuilder {
  String _id = const Uuid().v4();
  String _name = "name";
  GoListCollection<Item> _items = GoListCollection<Item>([]);
  DateTime _modified = DateTime(2020, 1, 1);

  withItems(List<Item> items) {
    _items = GoListCollection(items);
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

  withName(String name){
    _name = name;
    return this;
  }

  build() {
    return ShoppingList(
        id: _id, name: _name, items: _items, modified: _modified);
  }
}
