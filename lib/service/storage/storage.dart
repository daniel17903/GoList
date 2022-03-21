import 'dart:async';

import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/storage_provider.dart';
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
    Map<StorageProvider, List<ShoppingList>> shoppingListsFromStorageProvider =
        {};
    StreamController<List<ShoppingList>> streamController = StreamController();
    Future.wait(_storageProviders.map((currentStorageProvider) async {
      List<ShoppingList> shoppingLists =
          await currentStorageProvider.loadShoppingLists();
      shoppingListsFromStorageProvider[currentStorageProvider] = shoppingLists;
      streamController.add(shoppingLists);
      if (shoppingListsFromStorageProvider.length > 1) {
        StorageProvider otherStorageProvider = shoppingListsFromStorageProvider
            .keys
            .firstWhere((sp) => sp != currentStorageProvider);

        await StorageProviderSync.syncStorageProviders(
                otherStorageProvider,
                shoppingListsFromStorageProvider[otherStorageProvider]!,
                currentStorageProvider,
                shoppingLists)
            .then(streamController.add);
      }
    })).then((value) => streamController.close());
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
