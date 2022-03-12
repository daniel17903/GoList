import 'package:flutter/cupertino.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/input_to_item_parser.dart';

class AppState extends ChangeNotifier {
  List<ShoppingList> shoppingLists;
  late int _selectedList;

  AppState({required this.shoppingLists, int selectedList = 0}) {
    _selectedList = selectedList;
    _initializeWithEmptyList();
  }

  void _initializeWithEmptyList() {
    if (shoppingLists.isEmpty) {
      shoppingLists.add(ShoppingList(
          name: "Einkaufsliste", items: [], recentlyUsedItems: []));
      shoppingLists[0].items.addAll(InputToItemParser.sampleNamesWithIcon()
          .entries
          .map((entry) => Item(name: entry.value, iconName: entry.key))
          .toList());
      for (ShoppingList shoppingList in shoppingLists) {
        shoppingList.addListener(notifyListeners);
      }
      notifyListeners();
      // TODO sort
      // TODO save
    }
  }

  void removeCurrentList() {
    int indexToRemove =
        shoppingLists.indexWhere((sl) => sl.id == currentShoppingList.id);
    shoppingLists[indexToRemove].removeListener(notifyListeners);
    shoppingLists.removeAt(indexToRemove);
    _initializeWithEmptyList();
    notifyListeners();
    // TODO save
  }

  void createList(String name) {
    ShoppingList newShoppingList = ShoppingList(name: name);
    newShoppingList.addListener(notifyListeners);
    shoppingLists.add(newShoppingList);
    _selectedList = shoppingLists.length - 1;
    notifyListeners();
  }

  set selectedList(int selectedList){
    _selectedList = selectedList;
    notifyListeners();
  }

  ShoppingList get currentShoppingList => shoppingLists[_selectedList];
}
