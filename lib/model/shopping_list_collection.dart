import 'package:go_list/model/extended_golist_collection.dart';
import 'package:go_list/model/golist_collection.dart';
import 'package:go_list/model/shopping_list.dart';

class ShoppingListCollection extends ExtendedGoListCollection<ShoppingList> {
  late List<String> _order;

  ShoppingListCollection(
      {List<ShoppingList>? entries,
      List<ShoppingList>? deletedEntries,
      List<String>? order})
      : super(entries: entries, deletedEntries: deletedEntries) {
    _order = order ?? entries?.map((e) => e.id).toList() ?? [];
  }

  static ShoppingListCollection fromJson(List<dynamic> json) {
    ShoppingListCollection shoppingListCollection = ShoppingListCollection();
    json.map<ShoppingList>(ShoppingList.fromJson).forEach((shoppingList) {
      shoppingListCollection.upsert(shoppingList);
    });
    return shoppingListCollection;
  }

  @override
  ExtendedGoListCollection<ShoppingList> upsert(ShoppingList entry) {
    _order.add(entry.id);
    return super.upsert(entry);
  }

  @override
  ShoppingListCollection copyWith(List<ShoppingList> entries,
      [List<ShoppingList>? deletedEntries]) {
    return ShoppingListCollection(
        entries: entries, deletedEntries: deletedEntries, order: _order);
  }

  void setOrder(List<String> order) {
    _order = order;
    sort();
  }

  List<String> get order => _order;

  void moveListInOrder(int fromIndex, int toIndex) {
    if (fromIndex < toIndex) {
      // removing the item at fromIndex will shorten the list by 1.
      toIndex -= 1;
    }
    String shoppingListIdAtFrom = _order.removeAt(fromIndex);
    _order.insert(toIndex, shoppingListIdAtFrom);
    sort();
  }

  @override
  GoListCollection<ShoppingList> sort(
      [int Function(ShoppingList p1, ShoppingList p2)? compare]) {
    entries
        .sort((a, b) => _order.indexOf(a.id).compareTo(_order.indexOf(b.id)));
    return this;
  }
}
