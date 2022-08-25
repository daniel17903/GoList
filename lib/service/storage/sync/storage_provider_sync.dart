import 'package:collection/collection.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/list_of.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/sync/diff.dart';
import 'package:go_list/service/storage/provider/storage_provider.dart';

class StorageProviderSync {
  static ShoppingList? _shoppingListById(
      ListOf<ShoppingList> shoppingLists, id) {
    return shoppingLists.firstWhereOrNull((sl) => sl.id == id);
  }

  static Future<ListOf<ShoppingList>> syncStorageProviders(
      StorageProvider localStorageProvider,
      ListOf<ShoppingList> shoppingListsFromLocal,
      StorageProvider remoteStorageProvider,
      ListOf<ShoppingList> shoppingListsFromRemote,
      {updateRemoteStorage: true}) async {
    Diff<ShoppingList, Item> diff =
        Diff.diff(shoppingListsFromLocal, shoppingListsFromRemote);

    // same ShoppingLists from both Storage Providers
    if (diff.isEmpty()) {
      return shoppingListsFromLocal;
    }

    // sync ShoppingLists
    await Future.wait([
      ...diff.elementsToUpdateInLocalStorage
          .map((el) async => await localStorageProvider.saveList(el)),
      if (updateRemoteStorage)
        ...diff.elementsToUpdateInRemoteStorage
            .map((el) async => await remoteStorageProvider.saveList(el))
    ]);

    // sync Items
    await Future.wait([
      ...diff.subElementDiffs.keys.map((shoppingListId) async {
        await localStorageProvider.saveItems(
            _shoppingListById(shoppingListsFromRemote, shoppingListId)!,
            diff.subElementDiffs[shoppingListId]!
                .elementsToUpdateInLocalStorage);
      }),
      if (updateRemoteStorage)
        ...diff.subElementDiffs.keys.map((shoppingListId) async {
          print("syncing items to remote storage");
          await remoteStorageProvider.saveItems(
              _shoppingListById(shoppingListsFromLocal, shoppingListId)!,
              diff.subElementDiffs[shoppingListId]!
                  .elementsToUpdateInRemoteStorage);
        })
    ]);

    return await localStorageProvider.loadShoppingLists();
  }
}
