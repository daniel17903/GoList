import 'package:flutter/cupertino.dart';
import 'package:go_list/model/shopping_list.dart';

@immutable
class AppState {
  late final List<ShoppingList> shoppingLists;
  late final int selectedList;
  late final bool connected;

  AppState(
      {List<ShoppingList>? shoppingLists, int? selectedList, bool? connected}) {
    this.shoppingLists = shoppingLists ?? [];
    this.selectedList = selectedList ?? 0;
    this.connected = connected ?? false;
  }

  ShoppingList? get currentShoppingList =>
      selectedList < notDeletedShoppingLists.length
          ? notDeletedShoppingLists[selectedList]
          : null;

  List<ShoppingList> get notDeletedShoppingLists =>
      shoppingLists.where((sl) => !sl.deleted).toList();

  AppState copyWith(
      {List<ShoppingList>? shoppingLists, int? selectedList, bool? connected}) {
    return AppState(
        shoppingLists: shoppingLists ?? [...this.shoppingLists],
        selectedList: selectedList ?? this.selectedList,
        connected: connected ?? this.connected);
  }
}
