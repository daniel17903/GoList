import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/shopping_list_storage.dart';

import '../item.dart';

class SelectedShoppingListState extends ChangeNotifier {
  late ShoppingList selectedShoppingList;

  SelectedShoppingListState(this.selectedShoppingList);

  Future<ShoppingList> loadListFromStorage() async {
    selectedShoppingList = await ShoppingListStorage()
        .loadShoppingList(selectedShoppingList.id)
        .last;
    notifyListeners();
    return selectedShoppingList;
  }

  void deleteItem(Item item){
    item.deleted = true;
    ShoppingListStorage().upsertShoppingList(selectedShoppingList);
    notifyListeners();
  }

  void upsertItem(Item item) {
    selectedShoppingList.upsertItem(item);
    ShoppingListStorage().upsertShoppingList(selectedShoppingList);
    notifyListeners();
  }
}
