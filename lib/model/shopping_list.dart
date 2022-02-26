import 'package:uuid/uuid.dart';

import 'item.dart';

class ShoppingList {
  ShoppingList(
      {required this.name,
      required this.items,
      required this.recentlyUsedItems});

  String id = const Uuid().v4();

  String name;

  List<Item> items;

  List<Item> recentlyUsedItems;

  ShoppingList.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        items = json["items"]
            .map<Item>((element) => Item.fromJson(element))
            .toList(),
        recentlyUsedItems = json["recentlyUsedItems"]
            .map<Item>((element) => Item.fromJson(element))
            .toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'items': items.map((item) => item.toJson()).toList(),
        'recentlyUsedItems':
            recentlyUsedItems.map((item) => item.toJson()).toList()
      };
}
