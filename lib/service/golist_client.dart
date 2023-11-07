import 'dart:convert';

import 'package:go_list/model/collections/shopping_list_collection.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GoListClient {
  static const String backendUrl = String.fromEnvironment("BACKEND_URL",
      defaultValue: "http://10.0.2.2:8000");
  static const String apiKey =
      String.fromEnvironment("API_KEY", defaultValue: "123");

  final Client client;
  String deviceId = "";

  GoListClient([Client? client]) : client = client ?? Client();

  Future<Response> _sendRequest(
      {required String endpoint,
      required HttpMethod httpMethod,
      Object? body}) async {
    Map<String, String> headers = {"api-key": apiKey, "user-id": deviceId};
    String? jsonBody;
    if (body != null) {
      jsonBody = json.encode(body);
      headers["Content-Type"] = "application/json";
    }
    Uri uri = Uri.parse("$backendUrl$endpoint");
    Response response;
    try {
      switch (httpMethod) {
        case HttpMethod.get:
          response = await client.get(uri, headers: headers);
          break;
        case HttpMethod.post:
          response = await client.post(uri, body: jsonBody, headers: headers);
          break;
        case HttpMethod.put:
          response = await client.put(uri, body: jsonBody, headers: headers);
        case HttpMethod.delete:
          response = await client.delete(uri, body: jsonBody, headers: headers);
      }
    } catch (e) {
      throw Exception("$httpMethod request to '$endpoint' failed: $e");
    }
    if ((response.statusCode ~/ 100) != 2) {
      throw Exception(
          "$httpMethod '$uri' failed, response code was ${response.statusCode}");
    }
    return response;
  }

  Future<String> createTokenToShareList(String shoppingListId) {
    return _sendRequest(
            endpoint: "/tokens",
            httpMethod: HttpMethod.post,
            body: {"shopping_list_id": shoppingListId})
        .then((response) => jsonDecode(utf8.decode(response.bodyBytes)))
        .then((responseJson) => responseJson["token"])
        .then((token) => "$backendUrl/join?token=$token");
  }

  Future<ShoppingList> joinListWithToken(String token) {
    return _sendRequest(
            endpoint: "/tokens/join/$token", httpMethod: HttpMethod.post)
        .then((response) =>
            ShoppingList.fromJson(jsonDecode(utf8.decode(response.bodyBytes))));
  }

  Future<ShoppingList> getShoppingList(String shoppingListId) {
    return _sendRequest(
            endpoint: "/shopping-lists/$shoppingListId",
            httpMethod: HttpMethod.get)
        .then((response) =>
            ShoppingList.fromJson(jsonDecode(utf8.decode(response.bodyBytes))));
  }

  Future<ShoppingListCollection> getShoppingLists() {
    return _sendRequest(endpoint: "/shopping-lists", httpMethod: HttpMethod.get)
        .then((response) => ShoppingListCollection.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes))));
  }

  Future<void> upsertShoppingList(ShoppingList shoppingList) async {
    await _sendRequest(
        endpoint: "/shopping-lists",
        httpMethod: HttpMethod.put,
        body: shoppingList.toJson());
  }

  Future<void> deleteShoppingList(String shoppingListId) async {
    await _sendRequest(
        endpoint: "/shopping-lists/$shoppingListId",
        httpMethod: HttpMethod.delete);
  }

  WebSocketChannel listenForChanges(String shoppingListId) {
    WebSocketChannel webSocketChannel = WebSocketChannel.connect(
        Uri.parse("$backendUrl/api/shoppinglist/$shoppingListId/listen"));
    webSocketChannel.sink.add(deviceId);
    return webSocketChannel;
  }
}
