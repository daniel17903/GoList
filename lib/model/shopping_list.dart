import 'package:flutter/cupertino.dart';
import 'package:go_list/model/golist_model.dart';

import 'item.dart';

@immutable
class ShoppingList extends GoListModel {
  late final String name;
  late final List<Item> items;

  ShoppingList(
      {required this.name,
      List<Item>? items,
      bool? deleted,
      int? modified,
      String? id})
      : super(modified: modified, deleted: deleted, id: id) {
    this.items = items ?? [];
  }

  ShoppingList.fromJson(Map<String, dynamic> json)
      : super(
            id: json["id"],
            deleted: json["deleted"],
            modified: json["modified"]) {
    name = json['name'];
    items =
        json["items"].map<Item>((element) => Item.fromJson(element)).toList();
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'items': items.map((item) => item.toJson()).toList(),
        'deleted': deleted,
        'modified': modified
      };

  ShoppingList copyWith(
      {String? name,
      List<Item>? items,
      bool? deleted,
      int? modified,
      String? id}) {
    return ShoppingList(
        name: name ?? this.name,
        items: items ?? this.items,
        deleted: deleted ?? this.deleted,
        modified: modified ?? DateTime.now().millisecondsSinceEpoch,
        id: id ?? this.id);
  }
}
