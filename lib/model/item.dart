import 'package:uuid/uuid.dart';

class Item {
  Item({required this.name, required this.iconName, this.amount});

  String id = const Uuid().v4();

  String name;

  String iconName;

  String? amount = "";

  Item.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        iconName = json["iconName"],
        amount = json["amount"];

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'iconName': iconName, 'amount': amount};

  /// returns a copy of this object with new id
  Item copy() {
    return Item(name: name, iconName: iconName, amount: '');
  }
}
