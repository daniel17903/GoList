import 'package:get_storage/get_storage.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/storage_provider.dart';
import 'package:collection/collection.dart';

class LocalStorageProvider implements StorageProvider {
  final box = GetStorage();

  @override
  Future<void> init() async {
    await GetStorage.init();
  }

  @override
  List<ShoppingList> loadShoppingLists() {
    if (box.hasData("shoppingLists")) {
      List<ShoppingList> shoppingLists =
          box.read("shoppingLists").map<ShoppingList>((element) {
        if (element is ShoppingList) {
          return element;
        }
        return ShoppingList.fromJson(element);
      }).toList();
      shoppingLists.retainWhere((sl) => sl.deleted == false);
      return shoppingLists;
    }
    return [];
  }

  ShoppingList? _shoppingListById(List<ShoppingList> shoppingLists, String id) {
    return loadShoppingLists().firstWhereOrNull((sl) => sl.id == id);
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

    box.write("shoppingLists", shoppingLists.map((sl) => sl.toJson()).toList());
  }

  @override
  void saveList(ShoppingList shoppingList) {
    List<ShoppingList> shoppingLists = loadShoppingLists();
    ShoppingList? shoppingListToUpdate =
        _shoppingListById(shoppingLists, shoppingList.id);
    if (shoppingListToUpdate == null) {
      shoppingLists.add(ShoppingList(
          name: shoppingList.name,
          deleted: shoppingList.deleted,
          modified: shoppingList.modified));
    } else {
      shoppingListToUpdate.name = shoppingList.name;
      shoppingListToUpdate.deleted = shoppingList.deleted;
      shoppingListToUpdate.modified = shoppingList.modified;
    }
    box.write("shoppingLists",
        shoppingLists.map((shoppingList) => shoppingList.toJson()).toList());
  }
}
