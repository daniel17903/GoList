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
    box.write("shoppingList", shoppingList.toJson());
  }

  List<String> _loadListOfStrings(String key) {
    if (box.hasData(key)) {
      return box.read(key) as List<String>;
    }
    return [];
  }

  ShoppingList loadShoppingList() {
    if (box.hasData("shoppingList")) {
      return ShoppingList.fromJson(box.read("shoppingList"));
    }
    return ShoppingList(name: 'Einkaufsliste', items: [], recentlyUsedItems: []);
  }
}
