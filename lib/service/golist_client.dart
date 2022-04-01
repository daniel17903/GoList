import 'dart:convert';

import 'package:go_list/service/storage/provider/device_id.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:http/http.dart';

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
      "api-key": "secure",
      "user-id": await deviceId()
    };
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
      if ((response.statusCode ~/ 100) != 2) {
        throw Exception(
            "Request to '$endpoint' failed, response code was ${response.statusCode}");
      }
      return response;
    } catch (_) {
      throw Exception("$httpMethod request to '$endpoint' failed");
    }
  }
}
