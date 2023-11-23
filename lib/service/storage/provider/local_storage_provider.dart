import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:go_list/model/collections/shopping_list_collection.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/settings.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/golist_languages.dart';
import 'package:go_list/service/storage/provider/storage_provider.dart';
import 'package:uuid/uuid.dart';

class LocalStorageProvider implements StorageProvider {
  final GetStorage getStorage;
  static const String _containerName = "v1";

  LocalStorageProvider([GetStorage? getStorage])
      : getStorage = getStorage ?? GetStorage(_containerName);

  static Future<void> init() {
    return GetStorage.init(_containerName);
  }

  Future<ShoppingListCollection?> migrateFromPreviousVersion(
      [GetStorage? customGetStorage]) async {
    await GetStorage.init();
    GetStorage oldGetStorage = customGetStorage ?? GetStorage();
    if (oldGetStorage.hasData("shoppingLists") &&
        !oldGetStorage.hasData("migrated")) {
      List<dynamic> shoppingListsInOldFormat =
          oldGetStorage.read("shoppingLists");
      for (var shoppingListInOldFormat in shoppingListsInOldFormat) {
        shoppingListInOldFormat["modified"] =
            DateTime.fromMillisecondsSinceEpoch(
                    shoppingListInOldFormat["modified"])
                .toIso8601String();
        shoppingListInOldFormat.remove("device_count");
        var recentlyUsedItems = [];
        Set<String> uniqueNames = {};
        for (var item in shoppingListInOldFormat["items"]) {
          item["modified"] =
              DateTime.fromMillisecondsSinceEpoch(item["modified"])
                  .toIso8601String();
          if (uniqueNames.add(item["name"])) {
            recentlyUsedItems
                .add(Item.fromJson(item).copyForRecentlyUsed().toJson());
          }
          shoppingListInOldFormat["recentlyUsedItems"] = recentlyUsedItems;
        }
      }

      ShoppingListCollection shoppingListCollection =
          ShoppingListCollection.fromJson(shoppingListsInOldFormat);
      getStorage.write("shoppingLists", shoppingListCollection.toJson());

      // migrate settings
      String selectedShoppingListId = shoppingListCollection
          .entries[oldGetStorage.read("selectedList") ?? 0].id;
      String? shoppingListOrderJsonString =
          oldGetStorage.read("shoppingListOrder");
      List<String> shoppingListOrder = shoppingListOrderJsonString != null
          ? (jsonDecode(shoppingListOrderJsonString) as List<dynamic>)
              .map((e) => e.toString())
              .toList()
          : shoppingListCollection.order;
      String deviceId = oldGetStorage.read("deviceId") ?? const Uuid().v4();
      String? language = oldGetStorage.read("language") ??
          GoListLanguages.platformLanguageOrDefault();
      Settings settings = Settings(
          selectedShoppingListId: selectedShoppingListId,
          shoppingListOrder: shoppingListOrder,
          deviceId: deviceId,
          language: language);
      saveSettings(settings);

      oldGetStorage.write("migrated", true);
      return shoppingListCollection;
    }
    return null;
  }

  @override
  ShoppingListCollection loadShoppingLists() {
    if (getStorage.hasData("shoppingLists")) {
      return ShoppingListCollection.fromJson(getStorage.read("shoppingLists"));
    }
    return ShoppingListCollection([]);
  }

  @override
  void upsertShoppingList(ShoppingList shoppingList) {
    ShoppingListCollection shoppingLists = loadShoppingLists();
    shoppingLists.upsert(shoppingList);
    getStorage.write("shoppingLists", shoppingLists.toJson());
  }

  @override
  void deleteShoppingList(String shoppingListId) {
    ShoppingListCollection shoppingLists = loadShoppingLists();
    shoppingLists.removeEntryWithId(shoppingListId);
    getStorage.write("shoppingLists", shoppingLists.toJson());
  }

  @override
  ShoppingList loadShoppingList(String shoppingListId) {
    ShoppingListCollection shoppingLists = loadShoppingLists();
    ShoppingList? shoppingList = shoppingLists.entryWithId(shoppingListId);
    if (shoppingList == null) {
      throw Exception(
          "Shopping list with id $shoppingListId does not exist in local storage.");
    }
    return shoppingList;
  }

  void saveSettings(Settings settings) {
    getStorage.write("settings", settings.toJson());
  }

  Settings? loadSettings() {
    if (!getStorage.hasData("settings")) {
      return null;
    }
    return Settings.fromJson(getStorage.read("settings"));
  }
}
