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
    streamController.add(localStorageProvider.loadShoppingLists());
    remoteStorageProvider
        .loadShoppingLists()
        .then(updateWithListsFromRemote)
        .then(streamController.add)
        .catchError((_) => print("failed to load shoppinglists from remote"))
        .whenComplete(streamController.close);

    return streamController.stream;
  }

  Future<void> saveItems(ShoppingList shoppingList, List<Item> items,
      {bool updateRemoteStorage = true}) async {
    await Future.wait([
      localStorageProvider,
      if (updateRemoteStorage) remoteStorageProvider
    ].map((sp) async => await sp.saveItems(shoppingList, items)));
  }

  Future<void> saveList(ShoppingList shoppingList,
      {bool updateRemoteStorage = true}) async {
    await Future.wait([
      localStorageProvider,
      if (updateRemoteStorage) remoteStorageProvider
    ].map((sp) async => await sp.saveList(shoppingList)));
  }

  Future<void> updateWithListFromRemote(
      ShoppingList shoppingListFromRemote) async {
    await updateWithListsFromRemote([
      for (ShoppingList shoppingList
          in localStorageProvider.loadShoppingLists())
        if (shoppingList.id == shoppingListFromRemote.id)
          shoppingListFromRemote
        else
          shoppingList
    ]);
  }

  Future<List<ShoppingList>> updateWithListsFromRemote(
      List<ShoppingList> shoppingListsFromRemote) async {
    return StorageProviderSync.syncStorageProviders(
        localStorageProvider,
        localStorageProvider.loadShoppingLists(),
        remoteStorageProvider,
        shoppingListsFromRemote);
  }

  void saveSelectedListIndex(int index) {
    localStorageProvider.saveSelectedListIndex(index);
  }

  int loadSelectedListIndex() {
    return localStorageProvider.loadSelectedListIndex();
  }
}
