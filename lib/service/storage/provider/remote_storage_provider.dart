import 'dart:async';

import 'package:go_list/model/collections/shopping_list_collection.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/service/storage/provider/storage_provider.dart';

enum HttpMethod { get, post, put, delete }

class RemoteStorageProvider extends StorageProvider {
  final GoListClient goListClient;

  RemoteStorageProvider(this.goListClient);

  @override
  Future<ShoppingListCollection> loadShoppingLists() async {
    try {
      return await goListClient.getShoppingLists();
    } catch (e) {
      print("failed to load shopping lists from server: $e");
      rethrow;
    }
  }

  @override
  Future<void> upsertShoppingList(ShoppingList shoppingList) async {
    try {
      await goListClient.upsertShoppingList(shoppingList);
    } catch (e) {
      print("failed to save shopping list ${shoppingList.id} on server: $e");
    }
  }

  @override
  Future<void> deleteShoppingList(String shoppingListId) async {
    try {
      await goListClient.deleteShoppingList(shoppingListId);
    } catch (e) {
      print("failed to delete shopping list $shoppingListId on server: $e");
    }
  }

  @override
  Future<ShoppingList> loadShoppingList(String shoppingListId) async {
    try {
      return await goListClient.getShoppingList(shoppingListId);
    } catch (e) {
      print("failed to load shopping list $shoppingListId from server: $e");
      rethrow;
    }
  }
}
