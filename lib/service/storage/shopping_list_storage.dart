import 'dart:async';

import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/model/shopping_list_collection.dart';
import 'package:go_list/service/storage/provider/local_storage_provider.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';

class ShoppingListStorage {
  static final ShoppingListStorage _singleton = ShoppingListStorage._internal();

  final localStorageProvider = LocalStorageProvider();
  final remoteStorageProvider = RemoteStorageProvider();

  ShoppingListStorage._internal();

  factory ShoppingListStorage() {
    return _singleton;
  }

  ShoppingListCollection loadShoppingListsFromLocalStorage() {
    return localStorageProvider.loadShoppingLists();
  }

  ShoppingList loadShoppingListFromLocalStorage(String shoppingListId) {
    return localStorageProvider.loadShoppingList(shoppingListId);
  }

  Stream<ShoppingListCollection> loadShoppingLists() async* {
    ShoppingListCollection shoppingListsFromLocalStorage =
        loadShoppingListsFromLocalStorage();
    yield shoppingListsFromLocalStorage;

    //GoListCollection<ShoppingList> shoppingListsFromRemoteStorage =
    //await remoteStorageProvider.loadShoppingLists();

    // TODO update storage if diff
    //yield shoppingListsFromLocalStorage.merge(shoppingListsFromRemoteStorage);
  }

  Stream<ShoppingList> loadShoppingList(String shoppingListId) async* {
    ShoppingList shoppingListFromLocalStorage =
        loadShoppingListFromLocalStorage(shoppingListId);
    yield shoppingListFromLocalStorage;

    //ShoppingList shoppingListFromRemoteStorage = await remoteStorageProvider
    //  .loadShoppingList(shoppingListId);
    // TODO update storage if diff
    //yield shoppingListFromLocalStorage.merge(shoppingListFromRemoteStorage)
  }

  Future<void> upsertItem(String shoppingListId, Item item) async {
    localStorageProvider.upsertItem(shoppingListId, item);
    //await remoteStorageProvider.upsertItem(shoppingListId, item);
  }

  Future<void> upsertShoppingList(ShoppingList shoppingList) async {
    localStorageProvider.upsertShoppingList(shoppingList);
    //await remoteStorageProvider.upsertShoppingList(shoppingList);
  }
}
