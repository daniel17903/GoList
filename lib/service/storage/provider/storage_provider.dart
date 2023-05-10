import 'dart:async';

import 'package:go_list/model/golist_collection.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';

abstract class StorageProvider {
  FutureOr<GoListCollection<ShoppingList>> loadShoppingLists();

  FutureOr<ShoppingList> loadShoppingList(String shoppingListId);

  FutureOr<void> upsertShoppingList(ShoppingList shoppingList);

  FutureOr<void> upsertItem(String shoppingListId, Item item);
}
