import 'dart:async';
import 'dart:convert';

import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/provider/device_id.dart';
import 'package:go_list/service/storage/provider/storage_provider.dart';
import 'package:http/http.dart';

enum HttpMethod { get, post }

class RemoteStorageProvider extends StorageProvider {
  late Client client;
  late DeviceId deviceId;

  Future<Response> _sendHttpRequest(
      {required String endpoint,
      required HttpMethod httpMethod,
      Object? body}) async {
    Map<String, String> headers = {"api_key": "secure", "user-id": deviceId()};
    String? jsonBody;
    if (body != null) {
      jsonBody = json.encode(body);
      headers["Content-Type"] = "application/json";
    }
    Uri uri = Uri.parse(const String.fromEnvironment('BACKEND_URL') + endpoint);
    Response response;
    try {
      switch (httpMethod) {
        case HttpMethod.get:
          response = await client.get(uri, headers: headers);
          break;
        case HttpMethod.post:
          response = await client.post(uri, body: jsonBody, headers: headers);
      }
      if (response.statusCode != 200) {
        throw Exception(
            "Request to '$endpoint' failed, response code was ${response.statusCode}");
      }
      return response;
    } catch (_) {
      throw Exception("$httpMethod request to '$endpoint' failed");
    }
  }

  @override
  Future<void> init() async {
    client = Client();
    deviceId = DeviceId();
    await deviceId.init();
  }

  @override
  Future<List<ShoppingList>> loadShoppingLists() async {
    try {
      final response = await _sendHttpRequest(
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
  Future<void> saveItems(ShoppingList shoppingList, List<Item> items) {
    try {
      return _sendHttpRequest(
          endpoint: "/api/shoppinglist/${shoppingList.id}/items",
          httpMethod: HttpMethod.post,
          body: items.map((i) => i.toJson()).toList());
    } catch (e) {
      print("failed to save items on server: $e");
    }
    return Future.value();
  }

  @override
  Future<void> saveList(ShoppingList shoppingList) {
    try {
      return _sendHttpRequest(
          endpoint: "/api/shoppinglist",
          httpMethod: HttpMethod.post,
          body: shoppingList.toJson());
    } catch (e) {
      print("failed to save shopping list on server: $e");
    }
    return Future.value();
  }
}
