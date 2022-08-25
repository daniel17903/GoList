import 'dart:async';
import 'dart:convert';

import 'package:go_list/model/item.dart';
import 'package:go_list/model/list_of.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/service/storage/provider/storage_provider.dart';

enum HttpMethod { get, post }

class RemoteStorageProvider extends StorageProvider {
  final GoListClient goListClient = GoListClient();

  @override
  Future<ListOf<ShoppingList>> loadShoppingLists() async {
    try {
      final response = await goListClient.sendRequest(
          endpoint: "/api/shoppinglists", httpMethod: HttpMethod.get);

      ListOf<ShoppingList> shoppingLists = ListOf(
          jsonDecode(utf8.decode(response.bodyBytes))
              .map<ShoppingList>((element) {
        if (element is ShoppingList) {
          return element;
        }
        return ShoppingList.fromJson(element);
      }).toList());

      return shoppingLists;
    } catch (e) {
      print("failed to load shopping lists from server: $e");
      rethrow;
    }
  }

  @override
  Future<void> saveItems(ShoppingList shoppingList, ListOf<Item> items) async {
    try {
      await goListClient.sendRequest(
          endpoint: "/api/shoppinglist/${shoppingList.id}/items",
          httpMethod: HttpMethod.post,
          body: items.toJson());
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
          body: shoppingList.toJson()..remove("items"));
    } catch (e) {
      print("failed to save shopping list on server: $e");
    }
  }
}
