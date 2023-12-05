import 'dart:async';
import 'dart:convert';

import 'package:go_list/model/collections/shopping_list_collection.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GoListClient {
  static const String backend =
      String.fromEnvironment("BACKEND", defaultValue: "192.168.178.58:8000");
  static const String originalBackend = String.fromEnvironment(
      "ORIGINAL_BACKEND",
      defaultValue: "192.168.178.58:8000");
  static const String environment =
      String.fromEnvironment("ENV", defaultValue: "dev");
  static const String apiKey =
      String.fromEnvironment("API_KEY", defaultValue: "123");

  WebSocketChannel? webSocketChannel;
  final Client client;
  String deviceId = "";

  GoListClient([Client? client]) : client = client ?? Client();

  String get httpProtocol => environment != "dev" ? "https" : "http";

  String get wsProtocol => environment != "dev" ? "wss" : "ws";

  Future<Response> _sendRequest(
      {required String endpoint,
      required HttpMethod httpMethod,
      Object? body}) async {
    String? jsonBody;
    if (body != null) {
      jsonBody = json.encode(body);
    }
    Uri uri = Uri.parse("$httpProtocol://$backend$endpoint");
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
        // this must be the original backend url because only this one opens the app
        // the new backend url is only used as a temporary second api during the migration
        .then((token) => "$httpProtocol://$originalBackend/join?token=$token");
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

  Map<String, String> get headers => {
        "api-key": apiKey,
        "user-id": deviceId,
        "Content-Type": "application/json"
      };

  Future<Stream<ShoppingList>> listenForChanges(String shoppingListId) async {
    // see https://github.com/dart-lang/http/issues/551
    Stream<ShoppingList>? stream =
        await runZonedGuarded<Future<Stream<ShoppingList>>>(() async {
      if (webSocketChannel != null) {
        webSocketChannel?.sink.close();
      }
      webSocketChannel = WebSocketChannel.connect(Uri.parse(
          "$wsProtocol://$backend/shopping-lists/$shoppingListId/listen"));
      webSocketChannel!.sink.add(json.encode(headers));
      return webSocketChannel!.stream.map((shoppingListJson) {
        return ShoppingList.fromJson(jsonDecode(shoppingListJson));
      });
    }, (error, stack) {
      throw Exception('Failed to connect to websocket');
    });
    if (stream == null) {
      throw Exception("Failed to connect to websocket");
    }
    return stream;
  }
}
