import 'package:go_list/model/golist_model.dart';
import 'package:go_list/model/mergeable.dart';
import 'package:go_list/service/items/category.dart';
import 'package:go_list/service/items/icon_mapping.dart';
import 'package:go_list/service/items/input_to_item_parser.dart';

class Item extends GoListModel implements Comparable<Item>, MergeAble<Item> {
  late String iconName;
  late String? amount;
  late Category category;

  Item(
      {String? id,
      required String name,
      required this.iconName,
      this.amount,
      required this.category,
      bool? deleted,
      DateTime? modified})
      : super(name: name, id: id, deleted: deleted, modified: modified);

  Item.fromJson(Map<String, dynamic> json)
      : super(
            name: json['name'],
            deleted: json["deleted"],
            id: json["id"],
            modified: json["modified"] is String
                ? DateTime.parse(json["modified"])
                : DateTime.fromMillisecondsSinceEpoch(json["modified"])) {
    iconName = json["iconName"];
    amount = json["amount"];
    category = json.containsKey("category")
        ? categoryFromString(json["category"])
        : Category.other;
  }

  Item.fromInput(String name, this.amount) : super(name: name) {
    findMapping();
  }

  Item copyAsRecentlyUsedItem() {
    return Item(name: name, iconName: iconName, category: category);
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

  @override
  Item merge(Item other) {
    return lastModified(this, other);
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
}
