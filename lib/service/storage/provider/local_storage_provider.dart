import 'package:get_storage/get_storage.dart';
import 'package:go_list/model/golist_collection.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/provider/storage_provider.dart';

class LocalStorageProvider implements StorageProvider {
  final getStorage = GetStorage();

  @override
  GoListCollection<ShoppingList> loadShoppingLists() {
    if (getStorage.hasData("shoppingLists")) {
      GoListCollection<ShoppingList> shoppingLists = GoListCollection(getStorage
          .read("shoppingLists")
          .map<ShoppingList>(ShoppingList.fromJson)
          .toList());
      return shoppingLists;
    }
    return GoListCollection([]);
  }

  @override
  void upsertShoppingList(ShoppingList shoppingList) {
    GoListCollection shoppingLists = loadShoppingLists();
    shoppingLists.upsert(shoppingList);

    getStorage.write("shoppingLists", shoppingLists.toJson());
  }

  @override
  ShoppingList loadShoppingList(String shoppingListId) {
    // TODO: implement loadShoppingList
    throw UnimplementedError();
  }

  @override
  void upsertItem(String shoppingListId, Item item) {
    // TODO: implement upsertItem
    throw UnimplementedError();
  }

}
