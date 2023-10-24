import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class LocalSettingsStorage{
  static final LocalSettingsStorage _singleton = LocalSettingsStorage._internal();

  final getStorage = GetStorage();

  LocalSettingsStorage._internal();

  factory LocalSettingsStorage() {
    return _singleton;
  }

  void saveSelectedListIndex(int index) {
    getStorage.write("selectedList", index);
  }

  String? loadSelectedShoppingListId() {
    if (getStorage.hasData("selectedShoppingListId")) {
      return getStorage.read("selectedShoppingListId");
    }
    return null;
  }

  void saveSelectedLanguage(String language) {
    getStorage.write("language", language);
  }

  String? loadSelectedLanguage() {
    if (getStorage.hasData("language")) {
      return getStorage.read("language");
    }
    return null;
  }

  void saveShoppingListOrder(List<String> shoppingListOrder) {
    getStorage.write("shoppingListOrder", jsonEncode(shoppingListOrder));
  }

  List<String>? loadShoppingListOrder() {
    if (getStorage.hasData("shoppingListOrder")) {
      return List<String>.from(jsonDecode(getStorage.read("shoppingListOrder")));
    }
    return null;
  }

}