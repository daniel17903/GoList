import 'dart:async';

import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/provider/local_storage_provider.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:go_list/service/storage/provider/storage_provider.dart';
import 'package:go_list/service/storage/sync/storage_provider_sync.dart';

class Storage {
  static final Storage _singleton = Storage._internal();

  final LocalStorageProvider localStorageProvider = LocalStorageProvider();
  final RemoteStorageProvider remoteStorageProvider = RemoteStorageProvider();

  Storage._internal();

  factory Storage() {
    return _singleton;
  }

  Stream<List<ShoppingList>> loadShoppingLists() {
    StreamController<List<ShoppingList>> streamController = StreamController();
    List<ShoppingList> shoppingListsFromLocal =
        localStorageProvider.loadShoppingLists();
    streamController.add(shoppingListsFromLocal);
    remoteStorageProvider
        .loadShoppingLists()
        .then((shoppingListsFromRemote) =>
            StorageProviderSync.syncStorageProviders(
                    localStorageProvider,
                    shoppingListsFromLocal,
                    remoteStorageProvider,
                    shoppingListsFromRemote)
                .then(streamController.add))
        .catchError((_) => print("failed to load shoppinglists from remote"))
        .whenComplete(streamController.close);

    return streamController.stream;
  }

  Future<void> saveItems(ShoppingList shoppingList, List<Item> items) async {
    await Future.wait([localStorageProvider, remoteStorageProvider]
        .map((sp) async => await sp.saveItems(shoppingList, items)));
  }

  Future<void> saveList(ShoppingList shoppingList) async {
    await Future.wait([localStorageProvider, remoteStorageProvider]
        .map((sp) async => await sp.saveList(shoppingList)));
  }
}
