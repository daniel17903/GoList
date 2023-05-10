import 'package:go_list/model/item.dart';
import 'package:go_list/service/items/category.dart';
import 'package:uuid/uuid.dart';

class ItemBuilder {
  String _id = const Uuid().v4();
  String _name = "name";
  Category _category = Category.beverages;
  String _iconName = "iconName";
  DateTime _modified = DateTime(2020, 1, 1);
  bool _deleted = false;
  String _amount = "1";

  withId(String id) {
    _id = id;
    return this;
  }

  withName(String name) {
    _name = name;
    return this;
  }

  withDeleted(bool deleted) {
    _deleted = deleted;
    return this;
  }

  withModified(DateTime modified) {
    _modified = modified;
    return this;
  }

  withCategory(Category category) {
    _category = category;
    return this;
  }

  withIconName(String iconName) {
    _iconName = iconName;
    return this;
  }

  withAmount(String amount) {
    _amount = amount;
    return this;
  }

  Item build() {
    return Item(
        id: _id,
        name: _name,
        category: _category,
        iconName: _iconName,
        modified: _modified,
        deleted: _deleted,
        amount: _amount);
  }
}
