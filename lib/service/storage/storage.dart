import 'dart:async';

import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/provider/storage_provider.dart';
import 'package:go_list/service/storage/sync/storage_provider_sync.dart';

class Storage {
  static final Storage _singleton = Storage._internal();

  final List<StorageProvider> _storageProviders = [];

  Storage._internal();

  factory Storage() {
    return _singleton;
  }

  Future<void> init(List<StorageProvider> storageProviders) {
    _storageProviders.addAll(storageProviders);
    return Future.wait(_storageProviders.map((sp) => sp.init()));
  }

  Stream<List<ShoppingList>> loadShoppingLists() {
    StorageProvider? previousStorageProvider;
    List<ShoppingList>? shoppingListsFromPreviousStorageProvider;

    StreamController<List<ShoppingList>> streamController = StreamController();
    Future.forEach(_storageProviders,
        (StorageProvider currentStorageProvider) async {
      try {
        List<ShoppingList> shoppingLists =
            await currentStorageProvider.loadShoppingLists();
        streamController.add(shoppingLists);
        if (previousStorageProvider != null) {
          await StorageProviderSync.syncStorageProviders(
                  previousStorageProvider!,
                  shoppingListsFromPreviousStorageProvider!,
                  currentStorageProvider,
                  shoppingLists)
              .then(streamController.add);
        }
        previousStorageProvider = currentStorageProvider;
        shoppingListsFromPreviousStorageProvider = shoppingLists;
      } catch (e) {
        print("Failed to load from storage provider: $e");
      }
    }).then((value) => streamController.close());
    return streamController.stream;
  }

  Future<void> saveItems(ShoppingList shoppingList, List<Item> items) async {
    await Future.wait(_storageProviders
        .map((sp) async => await sp.saveItems(shoppingList, items)));
  }

  Future<void> saveList(ShoppingList shoppingList) async {
    await Future.wait(
        _storageProviders.map((sp) async => await sp.saveList(shoppingList)));
  }
}
