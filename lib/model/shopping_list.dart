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
    notifyListeners();
  }

  String get name => _name;

  List<Item> get items => _items;

  List<Item> get recentlyUsedItems => _recentlyUsedItems;

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

  void addItem(Item item) {
    _items.add(item);
    _listenForItemChanges(item);
    notifyListeners();
    // TODO sort
  }

  void addRecentlyUsedItem(Item recentlyUsedItem) {
    _recentlyUsedItems.insert(0, recentlyUsedItem);
  }

  void removeItem(Item item) {
    items.removeWhere((i) => i.id == item.id);
    item.removeListener(notifyListeners);
    notifyListeners();
  }

  void removeRecentlyUsedItem(Item recentlyUsedItem) {
    _recentlyUsedItems.removeWhere((i) => i.id == recentlyUsedItem.id);
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
