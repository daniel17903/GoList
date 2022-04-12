import 'package:collection/collection.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/sync/diff.dart';
import 'package:go_list/service/storage/provider/storage_provider.dart';

class StorageProviderSync {
  static ShoppingList? _shoppingListById(List<ShoppingList> shoppingLists, id) {
    return shoppingLists.firstWhereOrNull((sl) => sl.id == id);
  }

  static Future<List<ShoppingList>> syncStorageProviders(
      StorageProvider localStorageProvider,
      List<ShoppingList> shoppingListsFromLocal,
      StorageProvider remoteStorageProvider,
      List<ShoppingList> shoppingListsFromRemote) async {
    Diff<ShoppingList, Item> diff = Diff.diff(shoppingListsFromLocal, shoppingListsFromRemote);

    // same ShoppingLists from both Storage Providers
    if (diff.isEmpty()) {
      return shoppingListsFromLocal;
    }

    // sync ShoppingLists
    await Future.wait([
      ...diff.elementsToUpdateIn1
          .map((el) async => await localStorageProvider.saveList(el)),
      ...diff.elementsToUpdateIn2
          .map((el) async => await remoteStorageProvider.saveList(el))
    ]);

    // sync Items
    await Future.wait([
      ...diff.subElementDiffs.keys.map((shoppingListId) async {
        await localStorageProvider.saveItems(
            _shoppingListById(shoppingListsFromRemote, shoppingListId)!,
            diff.subElementDiffs[shoppingListId]!.elementsToUpdateIn1);
      }),
      ...diff.subElementDiffs.keys.map((shoppingListId) async {
        await remoteStorageProvider.saveItems(
            _shoppingListById(shoppingListsFromLocal, shoppingListId)!,
            diff.subElementDiffs[shoppingListId]!.elementsToUpdateIn2);
      })
    ]);

    return await localStorageProvider.loadShoppingLists();
  }
}
