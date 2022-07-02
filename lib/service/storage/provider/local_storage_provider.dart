import 'package:get_storage/get_storage.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/list_of.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/provider/storage_provider.dart';

class LocalStorageProvider implements StorageProvider {
  final getStorage = GetStorage();

  @override
  ListOf<ShoppingList> loadShoppingLists() {
    if (getStorage.hasData("shoppingLists")) {
      ListOf<ShoppingList> shoppingLists =
          ListOf(getStorage.read("shoppingLists").map<ShoppingList>((element) {
        if (element is ShoppingList) {
          return element;
        }
        return ShoppingList.fromJson(element);
      }).toList());
      return shoppingLists;
    }
    return ListOf([]);
  }

  @override
  void saveItems(ShoppingList shoppingListToUpdate, ListOf<Item> items) {
    getStorage.write(
        "shoppingLists",
        loadShoppingLists()
            .updateEntry(shoppingListToUpdate,
                transform: (e) => e.withItems(items))
            .toJson());
  }

  @override
  void saveList(ShoppingList updatedShoppingList) {
    getStorage.write("shoppingLists",
        loadShoppingLists().updateEntry(updatedShoppingList).toJson());
  }

  void saveSelectedListIndex(int index) {
    getStorage.write("selectedList", index);
  }

  int loadSelectedListIndex() {
    if (getStorage.hasData("selectedList")) {
      return getStorage.read("selectedList");
    }
    return 0;
  }
}
