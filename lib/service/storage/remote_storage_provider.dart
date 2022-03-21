import 'dart:async';
import 'dart:convert';

import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/storage_provider.dart';
import 'package:http/http.dart';

enum HttpMethod { GET, POST }

class RemoteStorageProvider extends StorageProvider {
  late Client client;

  Future<Response> _sendHttpRequest(
      {required String endpoint,
      required HttpMethod httpMethod,
      Object? body}) async {
    Map<String, String> headers = {"api_key": "secure", "user-id": "dev"};
    String? jsonBody;
    if (body != null) {
      jsonBody = json.encode(body);
      headers["Content-Type"] = "application/json";
    }
    Uri uri = Uri.parse(const String.fromEnvironment('BACKEND_URL') + endpoint);
    Response response;
    try {
      switch (httpMethod) {
        case HttpMethod.GET:
          response = await client.get(uri, headers: headers);
          break;
        case HttpMethod.POST:
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
  }

  @override
  Future<List<ShoppingList>> loadShoppingLists() async {
    final response = await _sendHttpRequest(
        endpoint: "/api/shoppinglists", httpMethod: HttpMethod.GET);

    return jsonDecode(utf8.decode(response.bodyBytes))
        .map<ShoppingList>((element) {
      if (element is ShoppingList) {
        return element;
      }
      return ShoppingList.fromJson(element);
    }).toList();
  }

  @override
  Future<void> saveItems(ShoppingList shoppingList, List<Item> items) {
    return _sendHttpRequest(
        endpoint: "/api/shoppinglist/${shoppingList.id}/items",
        httpMethod: HttpMethod.POST,
        body: items.map((i) => i.toJson()).toList());
  }

  @override
  Future<void> saveList(ShoppingList shoppingList) {
    return _sendHttpRequest(
        endpoint: "/api/shoppinglist",
        httpMethod: HttpMethod.POST,
        body: shoppingList.toJson());
  }
}
