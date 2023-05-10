import 'package:flutter/cupertino.dart';
import 'package:go_list/model/golist_collection.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/local_settings_storage.dart';
import 'package:go_list/service/storage/shopping_list_storage.dart';

class GlobalAppState extends ChangeNotifier {
  late GoListCollection<ShoppingList> shoppingLists;
  late String selectedShoppingListId;
  late List<String> shoppingListOrder;

  GlobalAppState() {
    shoppingListOrder = LocalSettingsStorage().loadShoppingListOrder();
    setShoppingLists(ShoppingListStorage().loadShoppingListsFromLocalStorage());
    if (shoppingLists.length() == 0) {
      upsertShoppingList(ShoppingList(name: "Einkaufsliste"));
    }
    selectedShoppingListId =
        LocalSettingsStorage().loadSelectedShoppingListId() ??
            shoppingLists.first()!.id;
  }

  GlobalAppState loadListsFromStorage() {
    ShoppingListStorage().loadShoppingLists().listen(setShoppingLists);
    return this;
  }

  setShoppingLists(GoListCollection<ShoppingList> shoppingLists) {
    this.shoppingLists = shoppingLists.sortByIds(shoppingListOrder);
    notifyListeners();
  }

  setShoppingListOrder(List<String> shoppingListOrder) {
    shoppingLists.sortByIds(shoppingListOrder);
    LocalSettingsStorage().saveShoppingListOrder(shoppingListOrder);
    notifyListeners();
  }

  getShoppingLists() {
    return ShoppingListStorage().loadShoppingLists();
  }

  getSelectedShoppingList() {
    return shoppingLists.entryWithId(selectedShoppingListId);
  }

  void setSelectedShoppingListId(String selectedShoppingListId) {
    this.selectedShoppingListId = selectedShoppingListId;
    notifyListeners();
  }

  void deleteShoppingList(ShoppingList shoppingList) {
    shoppingList.deleted = true;
    upsertShoppingList(shoppingList);
  }

  void upsertShoppingList(ShoppingList shoppingList) {
    shoppingLists.upsert(shoppingList);
    ShoppingListStorage().upsertShoppingList(shoppingList);
    notifyListeners();
  }

  void updateListOrder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      // removing the item at oldIndex will shorten the list by 1.
      newIndex -= 1;
    }
    ShoppingList fromOldIndex = shoppingLists.removeAt(oldIndex);
    shoppingLists.upsert(fromOldIndex, newIndex);
    List<String> order = shoppingLists.entries().map((e) => e.id).toList();
    shoppingLists.setOrder(order);
    LocalSettingsStorage().saveShoppingListOrder(order);
    notifyListeners();
  }
}
