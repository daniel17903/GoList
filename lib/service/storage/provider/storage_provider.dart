import 'dart:async';

import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/model/collections/shopping_list_collection.dart';

abstract class StorageProvider {
  FutureOr<ShoppingListCollection> loadShoppingLists();

  FutureOr<ShoppingList> loadShoppingList(String shoppingListId);

  FutureOr<void> upsertShoppingList(ShoppingList shoppingList);

  FutureOr<void> deleteShoppingList(String shoppingListId);
}
