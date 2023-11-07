import 'package:get_storage/get_storage.dart';
import 'package:go_list/model/settings.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/model/collections/shopping_list_collection.dart';
import 'package:go_list/service/storage/provider/storage_provider.dart';

class LocalStorageProvider implements StorageProvider {
  final GetStorage getStorage;

  LocalStorageProvider([GetStorage? getStorage])
      : getStorage = getStorage ?? GetStorage();

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
