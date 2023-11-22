import 'package:go_list/model/golist_model.dart';
import 'package:go_list/service/items/category.dart';
import 'package:go_list/service/items/icon_mapping.dart';
import 'package:go_list/service/items/input_to_item_parser.dart';

class Item extends GoListModel implements Comparable<Item> {
  late String _iconName;
  late String? _amount;
  late Category _category;

  Item(
      {super.id,
      required super.name,
      required iconName,
      amount,
      required category,
      super.deleted,
      super.modified})
      : _iconName = iconName,
        _amount = amount,
        _category = category;

  Item.fromJson(dynamic json)
      : super(
            name: json['name'],
            deleted: json["deleted"],
            id: json["id"],
            modified: DateTime.parse(json["modified"])) {
    _iconName = json["iconName"];
    _amount = json["amount"];
    _category = json.containsKey("category")
        ? categoryFromString(json["category"])
        : Category.other;
  }

  Item.fromInput(String name, String? amount)
      : _amount = amount,
        super(name: name) {
    findMapping();
  }

  void findMapping() {
    IconMapping iconMapping = InputToItemParser().findMappingForName(name);
    _iconName = iconMapping.assetFileName;
    _category = iconMapping.category;
  }

  void setName(String name) {
    this.name = name;
    findMapping();
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'iconName': iconName,
        'amount': amount,
        'category': category.toString()
      };

  @override
  int compareTo(Item other) {
    if (category.index == other.category.index) {
      return name.toLowerCase().compareTo(other.name.toLowerCase());
    }
    return category.index.compareTo(other.category.index);
  }

  @override
  String toString() {
    return toJson().toString();
  }

  Item newFromTemplate() {
    return Item(
        name: name, iconName: iconName, amount: amount, category: category);
  }

  T copy<T extends GoListModel>() {
    return Item(
        name: name,
        iconName: iconName,
        amount: amount,
        category: category,
        deleted: deleted,
        modified: modified) as T;
  }

  @override
  GoListModel merge(GoListModel other) {
    return modified.isAfter(other.modified) ? this : other;
  }

  Item copyForRecentlyUsed() {
    return Item(
        name: name,
        amount: "",
        iconName: iconName,
        category: category,
        deleted: false);
  }

  Category get category => _category;

  set category(Category value) {
    modified = DateTime.now();
    _category = value;
  }

  String? get amount => _amount;

  set amount(String? value) {
    modified = DateTime.now();
    _amount = value;
  }

  String get iconName => _iconName;

  set iconName(String value) {
    modified = DateTime.now();
    _iconName = value;
  }
}
