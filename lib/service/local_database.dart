import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:go_list/model/shopping_list.dart';

import '../model/item.dart';

class LocalDatabase extends GetxController {
  final box = GetStorage();

  Future<void> initStorage() async {
    await GetStorage.init();
  }

  void saveList(ShoppingList shoppingList) {
    removeList(shoppingList);
    List<ShoppingList> shoppingLists = loadShoppingLists();
    shoppingLists.add(shoppingList);
    box.write("shoppingLists",
        shoppingLists.map((shoppingList) => shoppingList.toJson()).toList());
  }

  void removeList(ShoppingList shoppingList) {
    box.write(
        "shoppingLists",
        loadShoppingLists()
            .where((sl) => sl.id != shoppingList.id)
            .map((shoppingList) => shoppingList.toJson())
            .toList());
  }

  List<ShoppingList> loadShoppingLists() {
    if (box.hasData("shoppingLists")) {
      return box
          .read("shoppingLists")
          .map<ShoppingList>((element) => ShoppingList.fromJson(element))
          .toList();
    }
    return [];
  }
}
