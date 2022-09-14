import 'dart:async';

import 'package:go_list/model/item.dart';
import 'package:go_list/model/list_of.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/provider/local_storage_provider.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:go_list/service/storage/sync/storage_provider_sync.dart';

class Storage {
  static final Storage _singleton = Storage._internal();

  final LocalStorageProvider localStorageProvider = LocalStorageProvider();
  final RemoteStorageProvider remoteStorageProvider = RemoteStorageProvider();

  Storage._internal();

  factory Storage() {
    return _singleton;
  }

  Stream<ListOf<ShoppingList>> loadShoppingLists() {
    StreamController<ListOf<ShoppingList>> streamController =
        StreamController();
    streamController.add(localStorageProvider.loadShoppingLists());
    remoteStorageProvider
        .loadShoppingLists()
        .then(updateWithListsFromRemote)
        .then(streamController.add)
        .catchError(
            (e) => print("failed to load shoppinglists from remote: $e"))
        .whenComplete(streamController.close);

    return streamController.stream;
  }

  Future<void> saveItems(ShoppingList shoppingList, ListOf<Item> items,
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

  Future<ShoppingList> syncWithListFromRemote(
      ShoppingList shoppingListFromRemote) {
    return updateWithListsFromRemote(localStorageProvider
            .loadShoppingLists()
            .updateEntry(shoppingListFromRemote))
        .then((updatedLists) =>
            updatedLists.firstWhere((e) => e.id == shoppingListFromRemote.id));
  }

  Future<ListOf<ShoppingList>> updateWithListsFromRemote(
      ListOf<ShoppingList> shoppingListsFromRemote) async {
    return StorageProviderSync.syncStorageProviders(
        localStorageProvider,
        localStorageProvider.loadShoppingLists(),
        remoteStorageProvider,
        shoppingListsFromRemote,
        updateRemoteStorage: false);
  }

  void saveSelectedListIndex(int index) {
    localStorageProvider.saveSelectedListIndex(index);
  }

  int loadSelectedListIndex() {
    return localStorageProvider.loadSelectedListIndex();
  }

  void saveSelectedLanguage(String language) {
    localStorageProvider.saveSelectedLanguage(language);
  }

  String? loadSelectedLanguage() {
    return localStorageProvider.loadSelectedLanguage();
  }

  void saveShoppingListOrder(List<String> shoppingListOrder) {
    localStorageProvider.saveShoppingListOrder(shoppingListOrder);
  }

  List<String> loadShoppingListOrder() {
    return localStorageProvider.loadShoppingListOrder();
  }
}
