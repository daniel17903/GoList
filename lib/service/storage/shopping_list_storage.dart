import 'dart:async';

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

    ShoppingListCollection shoppingListsFromRemoteStorage =
        (await remoteStorageProvider.loadShoppingLists())
            .merge(shoppingListsFromLocalStorage);

    // TODO return if no diff

    // update local storage with changes from remote
    shoppingListsFromRemoteStorage.entries
        .forEach(localStorageProvider.upsertShoppingList);

    yield shoppingListsFromRemoteStorage;
  }

  Stream<ShoppingList> loadShoppingList(String shoppingListId) async* {
    ShoppingList shoppingListFromLocalStorage =
        loadShoppingListFromLocalStorage(shoppingListId);
    yield shoppingListFromLocalStorage;

    ShoppingList shoppingListFromRemoteStorage =
        (await remoteStorageProvider.loadShoppingList(shoppingListId))
            .merge(shoppingListFromLocalStorage);
    // TODO return if no diff
    localStorageProvider.upsertShoppingList(shoppingListFromRemoteStorage);

    yield shoppingListFromRemoteStorage;
  }

  Future<void> upsertShoppingList(ShoppingList shoppingList) async {
    localStorageProvider.upsertShoppingList(shoppingList);
    await remoteStorageProvider.upsertShoppingList(shoppingList);
  }
}
