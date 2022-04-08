import 'package:get_storage/get_storage.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/provider/storage_provider.dart';
import 'package:collection/collection.dart';

class LocalStorageProvider implements StorageProvider {
  final getStorage = GetStorage();

  @override
  List<ShoppingList> loadShoppingLists() {
    if (getStorage.hasData("shoppingLists")) {
      return getStorage.read("shoppingLists").map<ShoppingList>((element) {
        if (element is ShoppingList) {
          return element;
        }
        return ShoppingList.fromJson(element);
      }).toList();
    }
    return [];
  }

  ShoppingList? _shoppingListById(List<ShoppingList> shoppingLists, String id) {
    return shoppingLists.firstWhereOrNull((sl) => sl.id == id);
  }

  @override
  void saveItems(ShoppingList shoppingList, List<Item> items) {
    List<ShoppingList> shoppingLists = loadShoppingLists();
    ShoppingList shoppingListToUpdate =
        _shoppingListById(shoppingLists, shoppingList.id)!;

    // update all items that already existed
    for (int i = 0; i < shoppingListToUpdate.items.length; i++) {
      for (int x = 0; x < items.length; x++) {
        if (shoppingListToUpdate.items[i].id == items[x].id) {
          shoppingListToUpdate.items[i] = items[x];
          items.removeAt(x);
          x--;
        }
      }
    }

    // insert all items that did not exist yet
    shoppingListToUpdate.items.addAll(items);

    getStorage.write(
        "shoppingLists", shoppingLists.map((sl) => sl.toJson()).toList());
  }

  @override
  void saveList(ShoppingList updatedShoppingList) {
    List<ShoppingList> shoppingLists = loadShoppingLists();
    ShoppingList? shoppingListToUpdate =
        _shoppingListById(shoppingLists, updatedShoppingList.id);
    if (shoppingListToUpdate == null) {
      shoppingLists.add(updatedShoppingList);
    } else {
      shoppingLists = [
        for (ShoppingList shoppingList in shoppingLists)
          if (updatedShoppingList.id == shoppingList.id)
            updatedShoppingList
          else
            shoppingList
      ];
    }
    getStorage.write("shoppingLists",
        shoppingLists.map((shoppingList) => shoppingList.toJson()).toList());
  }
}
