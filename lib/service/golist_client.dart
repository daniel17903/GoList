import 'dart:convert';

import 'package:go_list/service/backend_url.dart';
import 'package:go_list/service/storage/provider/device_id.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GoListClient {
  late Client client;
  late DeviceId deviceId;

  GoListClient() {
    deviceId = DeviceId();
    client = Client();
  }

  Future<Response> sendRequest(
      {required String endpoint,
      required HttpMethod httpMethod,
      Object? body}) async {
    Map<String, String> headers = {
      "api-key": "aJIakfQ8skIHRT1586Xl8jF8L9FkpC3f",
      "user-id": await deviceId()
    };
    String? jsonBody;
    if (body != null) {
      jsonBody = json.encode(body);
      headers["Content-Type"] = "application/json";
    }
    Uri uri = Uri.parse("${BackendUrl.httpUrl()}$endpoint");
    Response response;
    try {
      switch (httpMethod) {
        case HttpMethod.get:
          response = await client.get(uri, headers: headers);
          break;
        case HttpMethod.post:
          response = await client.post(uri, body: jsonBody, headers: headers);
      }
    } catch (_) {
      throw Exception("$httpMethod request to '$endpoint' failed");
    }
    if ((response.statusCode ~/ 100) != 2) {
      throw Exception(
          "Request to '$endpoint' failed, response code was ${response.statusCode}");
    }
    return response;
  }

  WebSocketChannel listenForChanges(String shoppingListId) {
    WebSocketChannel webSocketChannel = WebSocketChannel.connect(Uri.parse(
        "${BackendUrl.websocketUrl()}/api/shoppinglist/${shoppingListId}/listen"));
    deviceId().then(webSocketChannel.sink.add);
    return webSocketChannel;
  }
}
