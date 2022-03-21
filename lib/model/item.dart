import 'package:go_list/model/golist_model.dart';

class Item extends GoListModel {
  late String _name;

  late String _iconName;

  String? _amount = "";

  Item(
      {required String name,
      required String iconName,
      String? amount,
      bool? deleted,
      int? modified})
      : super(deleted: deleted, modified: modified) {
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
      : super(
            deleted: json["deleted"],
            id: json["id"],
            modified: json["modified"]) {
    _name = json['name'];
    _iconName = json["iconName"];
    _amount = json["amount"];
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

  /// returns an item with same name and icon
  Item copy() {
    return Item(name: name, iconName: iconName, amount: '');
  }
}
