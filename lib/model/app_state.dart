import 'package:flutter/cupertino.dart';
import 'package:go_list/model/list_of.dart';
import 'package:go_list/model/shopping_list.dart';

@immutable
class AppState {
  late final ListOf<ShoppingList> shoppingLists;
  late final int selectedList;

  AppState({ListOf<ShoppingList>? shoppingLists, int? selectedList}) {
    this.shoppingLists = shoppingLists ?? ListOf<ShoppingList>([]);
    this.selectedList = selectedList ?? 0;
  }

  ShoppingList? get currentShoppingList =>
      selectedList < notDeletedShoppingLists.length
          ? notDeletedShoppingLists[selectedList]
          : null;

  ListOf<ShoppingList> get notDeletedShoppingLists =>
      shoppingLists.whereEntry((sl) => !sl.deleted);

  AppState copyWith({ListOf<ShoppingList>? shoppingLists, int? selectedList}) {
    return AppState(
        shoppingLists:
            shoppingLists ?? ListOf<ShoppingList>([...this.shoppingLists]),
        selectedList: selectedList ?? this.selectedList);
  }

  AppState withShoppingList(
      {required ShoppingList updatedShoppingList, int? updatedSelectedList}) {
    return copyWith(
        shoppingLists: shoppingLists.updateEntry(updatedShoppingList),
        selectedList: updatedSelectedList ?? selectedList);
  }
}
