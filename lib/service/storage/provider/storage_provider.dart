import 'dart:async';

import 'package:go_list/model/item.dart';
import 'package:go_list/model/list_of.dart';
import 'package:go_list/model/shopping_list.dart';

abstract class StorageProvider {
  FutureOr<ListOf<ShoppingList>> loadShoppingLists();

  FutureOr<void> saveList(ShoppingList shoppingList);

  FutureOr<void> saveItems(ShoppingList shoppingList, ListOf<Item> items);
}
