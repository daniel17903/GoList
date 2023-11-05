import 'package:flutter/cupertino.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/model/collections/shopping_list_collection.dart';
import 'package:go_list/service/storage/local_settings_storage.dart';
import 'package:go_list/service/storage/shopping_list_storage.dart';

class GlobalAppState extends ChangeNotifier {
  late ShoppingListCollection shoppingLists;
  late String selectedShoppingListId;
  late List<String> shoppingListOrder;
  Function? connectionFailureCallback;

  GlobalAppState(Future<String> defaultName) {
    shoppingListOrder = LocalSettingsStorage().loadShoppingListOrder() ?? [];
    shoppingLists = ShoppingListStorage().loadShoppingListsFromLocalStorage();
    shoppingLists.setOrder(shoppingListOrder);
    if (shoppingLists.length == 0) {
      var defaultList = ShoppingList(name: "");
      upsertShoppingList(defaultList);
      defaultName.then((String value) {
        defaultList.name = value;
        upsertShoppingList(defaultList);
      });
    }
    selectedShoppingListId =
        LocalSettingsStorage().loadSelectedShoppingListId() ??
            shoppingLists.first()!.id;
  }

  Future<void> loadListsFromStorage() async {
    await ShoppingListStorage()
        .loadShoppingLists()
        .listen(setShoppingLists)
        .asFuture()
        .onError((e, s) => connectionFailureCallback!());
  }

  registerConnectionFailureCallback(Function connectionFailureCallback) {
    this.connectionFailureCallback = connectionFailureCallback;
  }

  setShoppingLists(ShoppingListCollection shoppingLists) {
    if (shoppingListOrder.length < shoppingLists.length) {}
    if (!this.shoppingLists.equals(shoppingLists)) {
      this.shoppingLists = shoppingLists;
      this.shoppingLists.setOrder(shoppingListOrder);
      notifyListeners();
    }
  }

  setShoppingListOrder(List<String> shoppingListOrder) {
    shoppingLists.setOrder(shoppingListOrder);
    LocalSettingsStorage().saveShoppingListOrder(shoppingListOrder);
    notifyListeners();
  }

  getSelectedShoppingList() {
    return shoppingLists.entryWithId(selectedShoppingListId);
  }

  void setSelectedShoppingListId(String selectedShoppingListId) {
    this.selectedShoppingListId = selectedShoppingListId;
    LocalSettingsStorage().saveSelectedShoppingListId(selectedShoppingListId);
    notifyListeners();
  }

  void deleteShoppingList(ShoppingList shoppingList) {
    shoppingList.deleted = true;
    upsertShoppingList(shoppingList);
  }

  void upsertShoppingList(ShoppingList shoppingList) {
    shoppingLists.upsert(shoppingList);
    ShoppingListStorage().upsertShoppingList(shoppingList);
    setSelectedShoppingListId(shoppingList.id);
    notifyListeners();
  }

  void updateListOrder(int oldIndex, int newIndex) {
    shoppingLists.moveEntryInOrder(oldIndex, newIndex);
    LocalSettingsStorage().saveShoppingListOrder(shoppingLists.order);
    notifyListeners();
  }
}
