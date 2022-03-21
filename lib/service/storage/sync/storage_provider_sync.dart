import 'package:collection/collection.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/sync/diff.dart';
import 'package:go_list/service/storage/storage_provider.dart';

class StorageProviderSync {
  static ShoppingList? _shoppingListById(List<ShoppingList> shoppingLists, id) {
    return shoppingLists.firstWhereOrNull((sl) => sl.id == id);
  }

  static Future<List<ShoppingList>> syncStorageProviders(
      StorageProvider storageProvider1,
      List<ShoppingList> shoppingLists1,
      StorageProvider storageProvider2,
      List<ShoppingList> shoppingLists2) async {
    Diff<ShoppingList, Item> diff = Diff.diff(shoppingLists1, shoppingLists2);

    // same ShoppingLists from both Storage Providers
    if (diff.isEmpty()) {
      return shoppingLists1;
    }

    // sync ShoppingLists
    await Future.wait([
      ...diff.elementsToUpdateIn1
          .map((el) async => await storageProvider1.saveList(el)),
      ...diff.elementsToUpdateIn2
          .map((el) async => await storageProvider2.saveList(el))
    ]);

    // sync Items
    await Future.wait([
      ...diff.subElementDiffs.keys.map((shoppingListId) async {
        await storageProvider1.saveItems(
            _shoppingListById(shoppingLists2, shoppingListId)!,
            diff.subElementDiffs[shoppingListId]!.elementsToUpdateIn1);
      }),
      ...diff.subElementDiffs.keys.map((shoppingListId) async {
        await storageProvider2.saveItems(
            _shoppingListById(shoppingLists1, shoppingListId)!,
            diff.subElementDiffs[shoppingListId]!.elementsToUpdateIn2);
      })
    ]);

    return storageProvider1.loadShoppingLists();
  }
}
