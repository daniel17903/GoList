import 'dart:async';

import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/storage_provider.dart';

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
    StreamController<List<ShoppingList>> streamController = StreamController();
    Future.wait(_storageProviders.map((sp) async {
      streamController.add(await sp.loadShoppingLists());
    })).then((value) => streamController.close());
    return streamController.stream;
  }

  Future<void> removeItem(ShoppingList shoppingList, Item item) async {
    Future.wait(_storageProviders
        .map((sp) async => await sp.removeItem(shoppingList, item)));
  }

  Future<void> removeList(ShoppingList shoppingList) async {
    Future.wait(
        _storageProviders.map((sp) async => await sp.removeList(shoppingList)));
  }

  Future<void> saveItem(ShoppingList shoppingList, Item item) async {
    Future.wait(_storageProviders
        .map((sp) async => await sp.saveItem(shoppingList, item)));
  }

  Future<void> saveRecentlyUsedItem(
      ShoppingList shoppingList, Item recentlyUsedItem) async {
    Future.wait(_storageProviders.map((sp) async =>
        await sp.saveRecentlyUsedItem(shoppingList, recentlyUsedItem)));
  }

  Future<void> removeRecentlyUsedItem(
      ShoppingList shoppingList, Item recentlyUsedItem) async {
    Future.wait(_storageProviders.map((sp) async =>
        await sp.removeRecentlyUsedItem(shoppingList, recentlyUsedItem)));
  }

  Future<void> saveList(ShoppingList shoppingList) async {
    Future.wait(
        _storageProviders.map((sp) async => await sp.saveList(shoppingList)));
  }
}
