import 'package:flutter/cupertino.dart';
import 'package:go_list/model/shopping_list.dart';

@immutable
class AppState {
  late final List<ShoppingList> shoppingLists;
  late final int selectedList;

  AppState({List<ShoppingList>? shoppingLists, int? selectedList}) {
    this.shoppingLists = shoppingLists ?? [];
    this.selectedList = selectedList ?? 0;
  }

  ShoppingList? get currentShoppingList =>
      selectedList < notDeletedShoppingLists.length
          ? notDeletedShoppingLists[selectedList]
          : null;

  List<ShoppingList> get notDeletedShoppingLists =>
      shoppingLists.where((sl) => !sl.deleted).toList();

  AppState copyWith({List<ShoppingList>? shoppingLists, int? selectedList}) {
    return AppState(
        shoppingLists: shoppingLists ?? [...this.shoppingLists],
        selectedList: selectedList ?? this.selectedList);
  }

  AppState withShoppingList(
      {required ShoppingList updatedShoppingList, int? updatedSelectedList}) {
    return copyWith(shoppingLists: [
      for (ShoppingList shoppingList in shoppingLists)
        if (shoppingList.id == updatedShoppingList.id)
          updatedShoppingList
        else
          shoppingList
    ], selectedList: updatedSelectedList ?? selectedList);
  }
}
