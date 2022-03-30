import 'dart:async';
import 'dart:convert';

import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/service/storage/provider/storage_provider.dart';

enum HttpMethod { get, post }

class RemoteStorageProvider extends StorageProvider {
  late GoListClient goListClient;

  @override
  Future<void> init() async {
    goListClient = GoListClient();
    await goListClient.init();
  }

  @override
  Future<List<ShoppingList>> loadShoppingLists() async {
    try {
      final response = await goListClient.sendRequest(
          endpoint: "/api/shoppinglists", httpMethod: HttpMethod.get);

      return jsonDecode(utf8.decode(response.bodyBytes))
          .map<ShoppingList>((element) {
        if (element is ShoppingList) {
          return element;
        }
        return ShoppingList.fromJson(element);
      }).toList();
    } catch (e) {
      print("failed to load shopping lists from server: $e");
      rethrow;
    }
  }

  @override
  Future<void> saveItems(ShoppingList shoppingList, List<Item> items) async {
    try {
      await goListClient.sendRequest(
          endpoint: "/api/shoppinglist/${shoppingList.id}/items",
          httpMethod: HttpMethod.post,
          body: items.map((i) => i.toJson()).toList());
    } catch (e) {
      print("failed to save items on server: $e");
    }
  }

  @override
  Future<void> saveList(ShoppingList shoppingList) async {
    try {
      await goListClient.sendRequest(
          endpoint: "/api/shoppinglist",
          httpMethod: HttpMethod.post,
          body: shoppingList.toJson());
    } catch (e) {
      print("failed to save shopping list on server: $e");
    }
  }
}
