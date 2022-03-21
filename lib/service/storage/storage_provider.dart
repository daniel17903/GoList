import 'dart:async';

import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';

abstract class StorageProvider {
  Future<void> init() async {}

  FutureOr<List<ShoppingList>> loadShoppingLists();

  FutureOr<void> saveList(ShoppingList shoppingList);

  FutureOr<void> saveItems(ShoppingList shoppingList, List<Item> items);
}
