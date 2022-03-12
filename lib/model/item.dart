import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class Item extends ChangeNotifier {
  String id = const Uuid().v4();

  late String _name;

  late String _iconName;

  String? _amount = "";

  Item({required String name, required String iconName, String? amount}) {
    _name = name;
    _iconName = iconName;
    _amount = amount;
  }

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  set iconName(String iconName) {
    _iconName = iconName;
    notifyListeners();
  }

  set amount(String? amount) {
    _amount = amount;
    notifyListeners();
  }

  String get name => _name;

  String get iconName => _iconName;

  String? get amount => _amount;

  Item.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _name = json['name'],
        _iconName = json["iconName"],
        _amount = json["amount"];

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'iconName': iconName, 'amount': amount};

  /// returns a copy of this object with new id
  Item copy() {
    return Item(name: name, iconName: iconName, amount: '');
  }
}
