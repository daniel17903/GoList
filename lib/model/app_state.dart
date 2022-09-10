import 'package:flutter/cupertino.dart';
import 'package:go_list/model/list_of.dart';
import 'package:go_list/model/shopping_list.dart';

@immutable
class AppState {
  late final ListOf<ShoppingList> shoppingLists;
  late final int selectedList;

  AppState(
      {ListOf<ShoppingList>? shoppingLists,
      this.selectedList = 0,
      List<String>? shoppingListOrder}) {
    shoppingLists = shoppingLists ?? ListOf<ShoppingList>([]);
    shoppingListOrder = shoppingListOrder ?? [];
    this.shoppingLists = shoppingLists.sort((a, b) => shoppingListOrder!
        .indexOf(a.id)
        .compareTo(shoppingListOrder.indexOf(b.id)));
  }

  ShoppingList? get currentShoppingList =>
      selectedList < notDeletedShoppingLists.length
          ? notDeletedShoppingLists[selectedList]
          : null;

  ListOf<ShoppingList> get notDeletedShoppingLists =>
      shoppingLists.whereEntry((sl) => !sl.deleted);

  AppState copyWith(
      {ListOf<ShoppingList>? shoppingLists,
      int? selectedList,
      List<String>? shoppingListOrder}) {
    return AppState(
        shoppingLists:
            shoppingLists ?? ListOf<ShoppingList>([...this.shoppingLists]),
        selectedList: selectedList ?? this.selectedList,
        shoppingListOrder: shoppingListOrder);
  }

  AppState withShoppingList(
      {required ShoppingList updatedShoppingList, int? updatedSelectedList}) {
    return copyWith(
        shoppingLists: shoppingLists.updateEntry(updatedShoppingList),
        selectedList: updatedSelectedList ?? selectedList);
  }

  AppState withChangedListOrder(
      {required List<String> shoppingListOrder, int? selectedList}) {
    return copyWith(
        shoppingListOrder: shoppingListOrder, selectedList: selectedList);
  }
}
