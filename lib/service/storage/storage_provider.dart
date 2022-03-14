import 'dart:async';

import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';

abstract class StorageProvider {
  Future<void> init() async {}

  FutureOr<List<ShoppingList>> loadShoppingLists();

  FutureOr<void> saveList(ShoppingList shoppingList);

  FutureOr<void> removeList(ShoppingList shoppingList);

  FutureOr<void> saveItem(ShoppingList shoppingList, Item item);

  FutureOr<void> saveRecentlyUsedItem(
      ShoppingList shoppingList, Item recentlyUsedItem);

  FutureOr<void> removeRecentlyUsedItem(
      ShoppingList shoppingList, Item recentlyUsedItem);

  FutureOr<void> removeItem(ShoppingList shoppingList, Item item);
}
