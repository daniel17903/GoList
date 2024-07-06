import 'package:collection/collection.dart';
import 'package:go_list/model/collections/golist_collection.dart';
import 'package:go_list/model/golist_model.dart';
import 'package:go_list/model/shopping_list.dart';

class ShoppingListCollection extends GoListCollection<ShoppingList> {
  List<String> _order;

  ShoppingListCollection(super.entries, [List<String>? order])
      : _order = order ?? entries.map((e) => e.id).toList() {
    fixOrder();
    sortByOrder();
  }

  static ShoppingListCollection fromJson(List<dynamic> json) {
    return ShoppingListCollection(
        json.map<ShoppingList>(ShoppingList.fromJson).toList());
  }

  List<String> get order => _order;

  ShoppingListCollection merge(ShoppingListCollection other) {
    // normally only one list (the one from local storage) has an order
    var mergedOrder = _order.length > other.order.length ? order : other.order;
    return ShoppingListCollection(
        mergeLists(entries, other.entries), mergedOrder);
  }

  void sortByOrder() {
    super.sort((a, b) => _order.indexOf(a.id).compareTo(_order.indexOf(b.id)));
  }

  void fixOrder() {
    // remove ids not in list from order
    _order.removeWhere((id) => !containsEntryWithId(id));
    // remove duplicates
    _order = _order.toSet().toList();
    // add missing ids
    _order.addAll(entries.map((e) => e.id).whereNot(_order.contains));
  }

  void cleanup() {
    for (var shoppingList in entries) {
      shoppingList.items.removeItemsDeletedSinceDays();
      shoppingList.recentlyUsedItems.removeDuplicateNamesAndAmount();
    }
  }

  void setOrder(List<String> order) {
    _order = order;
    fixOrder();
    sortByOrder();
  }

  void moveEntryInOrder(int fromIndex, int toIndex) {
    if (fromIndex < toIndex) {
      // removing the item at fromIndex will shorten the list by 1.
      toIndex -= 1;
    }
    String idAtFrom = _order.removeAt(fromIndex);
    _order.insert(toIndex, idAtFrom);
    sortByOrder();
  }

  @override
  ShoppingList removeAt(int index) {
    _order.remove(entries[index].id);
    return super.removeAt(index);
  }

  @override
  void removeEntryWithId(String id) {
    int indexToRemove = entries.indexWhere(GoListModel.equalsById(id));
    if (indexToRemove != -1) {
      removeAt(indexToRemove);
    }
  }

  @override
  void upsert(ShoppingList entry) {
    super.upsert(entry);
    _order.add(entry.id);
  }
}
