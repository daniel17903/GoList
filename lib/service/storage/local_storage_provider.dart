import 'package:get_storage/get_storage.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/storage_provider.dart';

class LocalStorageProvider implements StorageProvider {
  final box = GetStorage();

  @override
  Future<void> init() async {
    await GetStorage.init();
  }

  @override
  List<ShoppingList> loadShoppingLists() {
    if (box.hasData("shoppingLists")) {
      return box.read("shoppingLists").map<ShoppingList>((element) {
        if (element is ShoppingList) {
          return element;
        }
        return ShoppingList.fromJson(element);
      }).toList();
    }
    return [];
  }

  @override
  void removeItem(ShoppingList shoppingList, Item item) {
    box.write(
        "shoppingLists",
        loadShoppingLists().map((sl) {
          if (sl.id == shoppingList.id) {
            sl.items.removeWhere((i) => i.id == item.id);
          }
          return sl;
        }).toList());
  }

  @override
  void removeList(ShoppingList shoppingList) {
    box.write(
        "shoppingLists",
        loadShoppingLists()
            .where((sl) => sl.id != shoppingList.id)
            .map((shoppingList) => shoppingList.toJson())
            .toList());
  }

  @override
  void saveItem(ShoppingList shoppingList, Item item) {
    box.write(
        "shoppingLists",
        loadShoppingLists().map((sl) {
          if (sl.id == shoppingList.id) {
            sl.items.removeWhere((i) => i.id == item.id);
            sl.items.add(item);
          }
          return sl;
        }).toList());
  }

  @override
  void saveList(ShoppingList shoppingList) {
    removeList(shoppingList);
    List<ShoppingList> shoppingLists = loadShoppingLists();
    shoppingLists.add(shoppingList);
    box.write("shoppingLists",
        shoppingLists.map((shoppingList) => shoppingList.toJson()).toList());
  }

  @override
  void saveRecentlyUsedItem(ShoppingList shoppingList, Item recentlyUsedItem) {
    box.write(
        "shoppingLists",
        loadShoppingLists().map((sl) {
          if (sl.id == shoppingList.id) {
            sl.recentlyUsedItems
                .removeWhere((i) => i.id == recentlyUsedItem.id);
            sl.recentlyUsedItems.add(recentlyUsedItem);
          }
          return sl;
        }).toList());
  }

  @override
  void removeRecentlyUsedItem(
      ShoppingList shoppingList, Item recentlyUsedItem) {
    box.write(
        "shoppingLists",
        loadShoppingLists().map((sl) {
          if (sl.id == shoppingList.id) {
            sl.recentlyUsedItems
                .removeWhere((i) => i.id == recentlyUsedItem.id);
          }
          return sl;
        }).toList());
  }
}
