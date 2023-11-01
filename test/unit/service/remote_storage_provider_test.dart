import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remote_storage_provider_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient client;
  const deviceId = "deviceId";
  const shoppingListJson = {
    "id": "id",
    "deleted": false,
    "modified": "2023-11-01T21:13:57.946519",
    "name": "name",
    "items": [
      {
        "id": "item-id",
        "deleted": false,
        "modified": "2023-11-01T21:13:57.946519",
        "name": "item-name",
        "iconName": "iconName",
        "amount": "2",
        "category": "Category.fruitsVegetables"
      }
    ],
    "recentlyUsedItems": [
      {
        "id": "recently used id",
        "deleted": false,
        "modified": "2023-11-01T21:13:57.946519",
        "name": "recently used item",
        "iconName": "iconName",
        "amount": "4",
        "category": "Category.bread"
      }
    ]
  };

  setUp(() => client = MockClient());

  test("Loads shopping lists", () async {
    when(client.get(Uri.parse("${GoListClient.backendUrl}/shopping-lists"),
            headers: {"api-key": GoListClient.apiKey, "user-id": deviceId}))
        .thenAnswer((_) async =>
            http.Response('[${json.encode(shoppingListJson)}]', 200));

    var loadedShoppingLists = await RemoteStorageProvider(
            goListClient: GoListClient(client: client, deviceId: deviceId))
        .loadShoppingLists();
    expect(loadedShoppingLists.length(), 1);
    expect(loadedShoppingLists.first()!.toJson(), shoppingListJson);
  });

  test("Loads shopping list", () async {
    when(client.get(
        Uri.parse(
            "${GoListClient.backendUrl}/shopping-lists/${shoppingListJson["id"]}"),
        headers: {
          "api-key": GoListClient.apiKey,
          "user-id": deviceId
        })).thenAnswer(
        (_) async => http.Response(json.encode(shoppingListJson), 200));

    var loadedShoppingList = await RemoteStorageProvider(
            goListClient: GoListClient(client: client, deviceId: deviceId))
        .loadShoppingList(shoppingListJson["id"] as String);
    expect(loadedShoppingList.toJson(), shoppingListJson);
  });

  test("Upserts a shopping list", () async {
    await RemoteStorageProvider(
            goListClient: GoListClient(client: client, deviceId: deviceId))
        .upsertShoppingList(ShoppingList.fromJson(shoppingListJson));

    verify(client.put(Uri.parse("${GoListClient.backendUrl}/shopping-lists"),
            headers: {
              "api-key": GoListClient.apiKey,
              "user-id": deviceId,
              "Content-Type": "application/json"
            },
            body: jsonEncode(shoppingListJson),
            encoding: null))
        .called(1);
  });
}
