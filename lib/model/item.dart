import 'package:flutter/foundation.dart' show immutable;
import 'package:go_list/model/golist_model.dart';
import 'package:go_list/service/items/category.dart';

@immutable
class Item extends GoListModel implements Comparable<Item> {
  late final String name;
  late final String iconName;
  late final String? amount;
  late final Category category;

  Item(
      {String? id,
      required this.name,
      required this.iconName,
      this.amount,
      required this.category,
      bool? deleted,
      int? modified})
      : super(id: id, deleted: deleted, modified: modified);

  Item.fromJson(Map<String, dynamic> json)
      : super(
            deleted: json["deleted"],
            id: json["id"],
            modified: json["modified"]) {
    name = json['name'];
    iconName = json["iconName"];
    amount = json["amount"];
    category = json.containsKey("category")
        ? categoryFromString(json["category"])
        : Category.other;
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'iconName': iconName,
        'amount': amount,
        'deleted': deleted,
        'modified': modified,
        'category': category.toString()
      };

  Item copyWith(
      {String? name,
      String? iconName,
      String? amount,
      bool? deleted,
      int? modified,
      String? id,
      Category? category}) {
    return Item(
        name: name ?? this.name,
        iconName: iconName ?? this.iconName,
        amount: amount ?? this.amount,
        deleted: deleted ?? this.deleted,
        modified: modified ?? DateTime.now().millisecondsSinceEpoch,
        id: id ?? this.id,
        category: category ?? this.category);
  }

  @override
  int compareTo(Item other) {
    if (category.index == other.category.index) {
      return name.compareTo(other.name);
    }
    return category.index.compareTo(other.category.index);
  }
}
