import 'package:go_list/model/golist_model.dart';
import 'package:collection/collection.dart';

import 'item.dart';

class ShoppingList extends GoListModel {
  late String _name;

  late List<Item> _items;

  ShoppingList(
      {required String name, List<Item>? items, bool? deleted, int? modified})
      : super(modified: modified, deleted: deleted) {
    _name = name;
    _items = items ?? [];
    subscribeToItems();
  }

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  String get name => _name;

  List<Item> get items => _items;

  void _listenForItemChanges(Item item) {
    item.addListener(() {
      notifyListeners();
    });
  }

  void subscribeToItems() {
    for (Item item in items) {
      _listenForItemChanges(item);
    }
  }

  void deleteItem(Item item) {
    int indexToDelete = items.indexWhere((i) => i.id == item.id);
    items[indexToDelete].deleted = true;
    items[indexToDelete].modified = DateTime.now().millisecondsSinceEpoch;
    items[indexToDelete].removeListener(notifyListeners);
    notifyListeners();
  }

  void addItem(Item item) {
    _items.add(item);
    _listenForItemChanges(item);
    notifyListeners();
    // TODO sort
  }

  ShoppingList.fromJson(Map<String, dynamic> json)
      : super(
            id: json["id"],
            deleted: json["deleted"],
            modified: json["modified"]) {
    _name = json['name'];
    _items =
        json["items"].map<Item>((element) => Item.fromJson(element)).toList();
    subscribeToItems();
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'items': items.map((item) => item.toJson()).toList(),
        'deleted': deleted,
        'modified': modified
      };
}
