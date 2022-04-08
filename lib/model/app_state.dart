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
      selectedList < shoppingLists.length ? shoppingLists[selectedList] : null;

  AppState copyWith({List<ShoppingList>? shoppingLists, int? selectedList}) {
    return AppState(
        shoppingLists: shoppingLists ?? [...this.shoppingLists],
        selectedList: selectedList ?? this.selectedList);
  }
}
