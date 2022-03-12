import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'item.dart';

class ShoppingList with ChangeNotifier {
  String id = const Uuid().v4();

  late String _name;

  late List<Item> _items;

  late List<Item> _recentlyUsedItems;

  ShoppingList(
      {required String name,
      List<Item>? items,
      List<Item>? recentlyUsedItems}) {
    _name = name;
    _items = items ?? [];
    _recentlyUsedItems = recentlyUsedItems ?? [];
    subscribeToItems();
  }

  set name(String name) {
    _name = name;
  }

  String get name => _name;

  List<Item> get items => _items;

  List<Item> get recentlyUsedItems => _recentlyUsedItems;

  void subscribeToItems() {
    for (Item item in items) {
      item.addListener(notifyListeners);
    }
  }

  void addItem(Item item) {
    _items.add(item);
    _recentlyUsedItems.insert(0, item);
    while (_recentlyUsedItems.length > 20) {
      _recentlyUsedItems.removeLast();
    }
    item.addListener(notifyListeners);
    notifyListeners();
    // TODO sort
    // TODO save
  }

  void removeItem(Item item) {
    items.removeWhere((i) => i.id == item.id);
    item.removeListener(notifyListeners);
    notifyListeners();
    //TODO save
  }

  ShoppingList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    _name = json['name'];
    _items =
        json["items"].map<Item>((element) => Item.fromJson(element)).toList();
    _recentlyUsedItems = json["recentlyUsedItems"]
        .map<Item>((element) => Item.fromJson(element))
        .toList();
    subscribeToItems();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'items': items.map((item) => item.toJson()).toList(),
        'recentlyUsedItems':
            recentlyUsedItems.map((item) => item.toJson()).toList()
      };
}
