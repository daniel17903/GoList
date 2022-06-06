import 'package:flutter/cupertino.dart';
import 'package:go_list/model/golist_model.dart';

import 'item.dart';

@immutable
class ShoppingList extends GoListModel {
  late final String name;
  late final List<Item> items;
  late final int deviceCount;

  ShoppingList(
      {required this.name,
      List<Item>? items,
      bool? deleted,
      int? modified,
      String? id,
      int? deviceCount})
      : super(modified: modified, deleted: deleted, id: id) {
    this.items = items ?? [];
    this.deviceCount = deviceCount ?? 1;
  }

  ShoppingList.fromJson(Map<String, dynamic> json)
      : super(
            id: json["id"],
            deleted: json["deleted"],
            modified: json["modified"]) {
    name = json['name'];
    items =
        json["items"].map<Item>((element) => Item.fromJson(element)).toList();
    deviceCount = json.containsKey("device_count") ? json["device_count"] : 1;
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'items': items.map((item) => item.toJson()).toList(),
        'deleted': deleted,
        'modified': modified,
        'device_count': deviceCount
      };

  ShoppingList copyWith(
      {String? name,
      List<Item>? items,
      bool? deleted,
      int? modified,
      String? id,
      int? deviceCount}) {
    return ShoppingList(
        name: name ?? this.name,
        items: items ?? this.items,
        deleted: deleted ?? this.deleted,
        modified: modified ?? DateTime.now().millisecondsSinceEpoch,
        id: id ?? this.id,
        deviceCount: deviceCount ?? this.deviceCount);
  }

  ShoppingList withItems(List<Item> updatedItems) {
    return copyWith(items: [
      for (final item in items)
        if (updatedItems.any((e) => e.id == item.id))
          updatedItems
              .firstWhere((e) => e.id == item.id)
              .copyWith(deleted: true)
        else
          item
    ]);
  }
}
