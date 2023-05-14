import 'dart:async';
import 'dart:convert';

import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/model/shopping_list_collection.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/service/storage/provider/storage_provider.dart';

enum HttpMethod { get, post }

class RemoteStorageProvider extends StorageProvider {
  final GoListClient goListClient = GoListClient();

  @override
  Future<ShoppingListCollection> loadShoppingLists() async {
    try {
      final response = await goListClient.sendRequest(
          endpoint: "/api/shoppinglists", httpMethod: HttpMethod.get);

      return ShoppingListCollection.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    } catch (e) {
      print("failed to load shopping lists from server: $e");
      rethrow;
    }
  }

  // TODO check if this also saves items
  @override
  Future<void> upsertShoppingList(ShoppingList shoppingList) async {
    try {
      await goListClient.sendRequest(
          endpoint: "/api/shoppinglist",
          httpMethod: HttpMethod.post,
          body: shoppingList.toJson()..remove("items"));
    } catch (e) {
      print("failed to save shopping list on server: $e");
    }
  }

  @override
  Future<ShoppingList> loadShoppingList(String shoppingListId) {
    // TODO: implement loadShoppingList
    throw UnimplementedError();
  }

  @override
  Future<void> upsertItem(String shoppingListId, Item item) {
    // TODO: implement upsertItem
    throw UnimplementedError();
  }
}
