import 'dart:async';

import 'package:go_list/model/collections/shopping_list_collection.dart';
import 'package:go_list/model/settings.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/provider/local_storage_provider.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';

class ShoppingListStorage {
  final LocalStorageProvider localStorageProvider;
  final RemoteStorageProvider remoteStorageProvider;

  ShoppingListStorage(this.localStorageProvider, this.remoteStorageProvider);

  ShoppingListCollection loadShoppingListsFromLocalStorage() {
    ShoppingListCollection shoppingListsFromLocalStorage =  localStorageProvider.loadShoppingLists();
    shoppingListsFromLocalStorage.removeDeletedItemsNotModifiedSinceTenDays();
    return shoppingListsFromLocalStorage;
  }

  ShoppingList loadShoppingListFromLocalStorage(String shoppingListId) {
    ShoppingList shoppingListsFromLocalStorage = localStorageProvider.loadShoppingList(shoppingListId);
    shoppingListsFromLocalStorage.items.removeItemsDeletedSinceTenDays();
    return shoppingListsFromLocalStorage;
  }

  Stream<ShoppingListCollection> loadShoppingLists() async* {
    ShoppingListCollection shoppingListsFromLocalStorage =
        loadShoppingListsFromLocalStorage();
    yield shoppingListsFromLocalStorage;

    ShoppingListCollection shoppingListsFromRemoteStorage =
        (await remoteStorageProvider.loadShoppingLists());
    shoppingListsFromRemoteStorage.removeDeletedItemsNotModifiedSinceTenDays();

    if (!shoppingListsFromRemoteStorage.equals(shoppingListsFromLocalStorage)) {
      ShoppingListCollection merged =
          shoppingListsFromLocalStorage.merge(shoppingListsFromRemoteStorage);

      // update local storage with changes from remote
      merged.entries.forEach(localStorageProvider.upsertShoppingList);
      merged.entries.forEach(remoteStorageProvider.upsertShoppingList);

      yield merged;
    }
  }

  Future<Stream<ShoppingList>> listenForChanges(String shoppingListId) async {
    return (await remoteStorageProvider.listenForChanges(shoppingListId))
        .map((shoppingList) {
      ShoppingList mergedWithLocal =
          loadShoppingListFromLocalStorage(shoppingList.id).merge(shoppingList)
              as ShoppingList;
      localStorageProvider.upsertShoppingList(mergedWithLocal);
      return mergedWithLocal;
    });
  }

  Future<void> upsertShoppingList(ShoppingList shoppingList) async {
    localStorageProvider.upsertShoppingList(shoppingList);
    await remoteStorageProvider.upsertShoppingList(shoppingList);
  }

  void saveSettings(Settings settings) {
    localStorageProvider.saveSettings(settings);
  }

  Settings? loadSettings() {
    return localStorageProvider.loadSettings();
  }

  Future<void> deleteShoppingList(String shoppingListId) async {
    localStorageProvider.deleteShoppingList(shoppingListId);
    await remoteStorageProvider.deleteShoppingList(shoppingListId);
  }
}
