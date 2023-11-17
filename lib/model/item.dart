import 'package:go_list/model/golist_model.dart';
import 'package:go_list/service/items/category.dart';
import 'package:go_list/service/items/icon_mapping.dart';
import 'package:go_list/service/items/input_to_item_parser.dart';

class Item extends GoListModel implements Comparable<Item> {
  late String iconName;
  late String? amount;
  late Category category;

  Item(
      {super.id,
      required super.name,
      required this.iconName,
      this.amount,
      required this.category,
      super.deleted,
      super.modified});

  Item.fromJson(dynamic json)
      : super(
            name: json['name'],
            deleted: json["deleted"],
            id: json["id"],
            modified: DateTime.parse(json["modified"])) {
    iconName = json["iconName"];
    amount = json["amount"];
    category = json.containsKey("category")
        ? categoryFromString(json["category"])
        : Category.other;
  }

  Item.fromInput(String name, this.amount) : super(name: name) {
    findMapping();
  }

  void findMapping() {
    IconMapping iconMapping = InputToItemParser().findMappingForName(name);
    iconName = iconMapping.assetFileName;
    category = iconMapping.category;
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
}
