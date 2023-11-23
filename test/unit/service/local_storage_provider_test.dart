import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_list/service/storage/provider/local_storage_provider.dart';
import 'package:mockito/mockito.dart';

class MockGetStorage extends Mock implements GetStorage {
  Map<String, dynamic> data = {
    "language": "de",
    "deviceId": "a3111272-04c2-494d-ab52-125b85700f1b",
    "selectedList": 0,
    "shoppingLists": [
      {
        "id": "01f0a6c8-779e-40c7-9a49-f3c321f81aad",
        "name": "Einkaufsliste",
        "items": [
          {
            "id": "4c9649af-c79a-4e1b-acfb-13d88bbdf482",
            "name": "Item ",
            "iconName": "default",
            "amount": "1",
            "deleted": false,
            "modified": 1700329531933,
            "category": "Category.other"
          },
          {
            "id": "1ab34d81-d3a9-43e9-b4cb-72af96fea6ff",
            "name": "apfel",
            "iconName": "apple",
            "amount": null,
            "deleted": false,
            "modified": 1700329545154,
            "category": "Category.fruitsVegetables"
          },
          {
            "id": "1ab34d81-d3a9-43e9-b4cb-72af96fea6f3",
            "name": "apfel",
            "iconName": "apple",
            "amount": null,
            "deleted": false,
            "modified": 1700329545154,
            "category": "Category.fruitsVegetables"
          }
        ],
        "deleted": false,
        "modified": 1700329545155,
        "device_count": 1
      }
    ],
    "shoppingListOrder":
        "[\"722de25f-5ce3-442f-9b94-9ebc1c0c63ed\",\"01f0a6c8-779e-40c7-9a49-f3c321f81aad\"]"
  };

  @override
  bool hasData(String key) {
    return data.containsKey(key);
  }

  @override
  T? read<T>(String key) {
    return data[key];
  }

  @override
  Future<void> write(String key, value) {
    data[key] = value;
    return Future.value();
  }
}

void main() {
  test("Migrates shopping lists from old data", () async {
    MockGetStorage mockGetStorage = MockGetStorage();
    const expectedShoppingListsInNewFormat = [
      {
        "id": "01f0a6c8-779e-40c7-9a49-f3c321f81aad",
        "deleted": false,
        "modified": "2023-11-18T18:45:45.155",
        "name": "Einkaufsliste",
        "items": [
          {
            "id": "1ab34d81-d3a9-43e9-b4cb-72af96fea6ff",
            "deleted": false,
            "modified": "2023-11-18T18:45:45.154",
            "name": "apfel",
            "iconName": "apple",
            "amount": null,
            "category": "Category.fruitsVegetables"
          },
          {
            "id": "1ab34d81-d3a9-43e9-b4cb-72af96fea6f3",
            "name": "apfel",
            "iconName": "apple",
            "amount": null,
            "deleted": false,
            "modified": "2023-11-18T18:45:45.154",
            "category": "Category.fruitsVegetables"
          },
          {
            "id": "4c9649af-c79a-4e1b-acfb-13d88bbdf482",
            "deleted": false,
            "modified": "2023-11-18T18:45:31.933",
            "name": "Item ",
            "iconName": "default",
            "amount": "1",
            "category": "Category.other"
          },
        ],
        'recentlyUsedItems': [
          {
            'deleted': false,
            'name': 'apfel',
            'iconName': 'apple',
            'amount': '',
            'category': 'Category.fruitsVegetables'
          },
          {
            'deleted': false,
            'name': 'Item ',
            'iconName': 'default',
            'amount': '',
            'category': 'Category.other'
          }
        ]
      }
    ];
    await LocalStorageProvider(mockGetStorage)
        .migrateFromPreviousVersion(mockGetStorage);
    List<Map<String, dynamic>> actualShoppingListsInNewFormat =
        mockGetStorage.read("shoppingLists");

    // ignore id and modified since they change every time
    for (Map<String, dynamic> item in actualShoppingListsInNewFormat[0]
        ["recentlyUsedItems"]) {
      item.remove("id");
      item.remove("modified");
    }

    expect(mockGetStorage.read("shoppingLists"),
        equals(expectedShoppingListsInNewFormat));
  });

  test("Migrates settings from old data", () async {
    MockGetStorage mockGetStorage = MockGetStorage();
    await LocalStorageProvider(mockGetStorage)
        .migrateFromPreviousVersion(mockGetStorage);
    expect(
        mockGetStorage.read("settings"),
        equals({
          'selectedShoppingListId': '01f0a6c8-779e-40c7-9a49-f3c321f81aad',
          'shoppingListOrder': [
            "722de25f-5ce3-442f-9b94-9ebc1c0c63ed",
            "01f0a6c8-779e-40c7-9a49-f3c321f81aad"
          ],
          'language': 'de',
          'deviceId': 'a3111272-04c2-494d-ab52-125b85700f1b'
        }));
  });
}
