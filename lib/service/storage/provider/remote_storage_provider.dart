import 'dart:async';
import 'dart:convert';

import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/model/shopping_list_collection.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/service/storage/provider/storage_provider.dart';

enum HttpMethod { get, post, put }

class RemoteStorageProvider extends StorageProvider {
  final GoListClient goListClient;

  RemoteStorageProvider({GoListClient? goListClient})
      : goListClient = goListClient ?? GoListClient();

  @override
  Future<ShoppingListCollection> loadShoppingLists() async {
    try {
      final response = await goListClient.sendRequest(
          endpoint: "/shopping-lists", httpMethod: HttpMethod.get);

      return ShoppingListCollection.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    } catch (e) {
      print("failed to load shopping lists from server: $e");
      rethrow;
    }
  }

  @override
  Future<void> upsertShoppingList(ShoppingList shoppingList) async {
    try {
      await goListClient.sendRequest(
          endpoint: "/shopping-lists",
          httpMethod: HttpMethod.put,
          body: shoppingList.toJson());
    } catch (e) {
      print("failed to save shopping list ${shoppingList.id} on server: $e");
    }
  }

  @override
  Future<ShoppingList> loadShoppingList(String shoppingListId) async {
    try {
      final response = await goListClient.sendRequest(
          endpoint: "/shopping-lists/$shoppingListId",
          httpMethod: HttpMethod.get);

      return ShoppingList.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } catch (e) {
      print("failed to load shopping list $shoppingListId from server: $e");
      rethrow;
    }
  }
}
