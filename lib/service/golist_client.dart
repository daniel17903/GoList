import 'dart:convert';

import 'package:go_list/service/storage/provider/device_id.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GoListClient {
  static const String backendUrl = String.fromEnvironment("BACKEND_URL",
      defaultValue: "http://10.0.2.2:8000");
  static const String apiKey =
      String.fromEnvironment("API_KEY", defaultValue: "123");

  final Client client;
  final String deviceId;

  GoListClient({Client? client, String? deviceId})
      : client = client ?? Client(),
        deviceId = deviceId ?? DeviceId()();

  Future<Response> sendRequest(
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

  WebSocketChannel listenForChanges(String shoppingListId) {
    WebSocketChannel webSocketChannel = WebSocketChannel.connect(
        Uri.parse("$backendUrl/api/shoppinglist/$shoppingListId/listen"));
    webSocketChannel.sink.add(deviceId);
    return webSocketChannel;
  }
}
