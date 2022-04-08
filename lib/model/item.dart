import 'package:flutter/foundation.dart' show immutable;
import 'package:go_list/model/golist_model.dart';

@immutable
class Item extends GoListModel {
  late final String name;
  late final String iconName;
  late final String? amount;

  Item(
      {String? id,
      required this.name,
      required this.iconName,
      this.amount,
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
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'iconName': iconName,
        'amount': amount,
        'deleted': deleted,
        'modified': modified
      };

  Item copyWith(
      {String? name,
      String? iconName,
      String? amount,
      bool? deleted,
      int? modified,
      String? id}) {
    return Item(
        name: name ?? this.name,
        iconName: iconName ?? this.iconName,
        amount: amount ?? this.amount,
        deleted: deleted ?? this.deleted,
        modified: modified ?? DateTime.now().millisecondsSinceEpoch,
        id: id ?? this.id);
  }
}
