import 'package:flutter/cupertino.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/input_to_item_parser.dart';
import 'package:go_list/service/storage/storage.dart';

class AppState extends ChangeNotifier {
  late List<ShoppingList> _shoppingLists;
  late int _selectedList;

  AppState({List<ShoppingList>? shoppingLists, int selectedList = 0}) {
    _shoppingLists = shoppingLists ?? [];
    _selectedList = selectedList;
    _subscribeToLists();
  }

  List<ShoppingList> get shoppingLists => _shoppingLists;

  void _subscribeToLists() {
    for (ShoppingList shoppingList in _shoppingLists) {
      shoppingList.addListener(notifyListeners);
    }
  }

  void _unsubscribeFromLists() {
    for (ShoppingList shoppingList in _shoppingLists) {
      shoppingList.removeListener(notifyListeners);
    }
  }

  void initializeWithEmptyList() async {
    if (_shoppingLists.isEmpty) {
      _shoppingLists.add(ShoppingList(
          name: "Einkaufsliste", items: [], recentlyUsedItems: []));
      await Storage().saveList(_shoppingLists[0]);
      _shoppingLists[0].items.addAll(InputToItemParser.sampleNamesWithIcon()
          .entries
          .map((entry) => Item(name: entry.value, iconName: entry.key))
          .toList());
      await Storage().saveItems(_shoppingLists[0], _shoppingLists[0].items);
      notifyListeners();
      // TODO sort
    }
  }

  void removeCurrentList() {
    int indexToRemove =
        _shoppingLists.indexWhere((sl) => sl.id == currentShoppingList.id);
    _selectedList = 0;
    _shoppingLists[indexToRemove].removeListener(notifyListeners);
    _shoppingLists.removeAt(indexToRemove);
    initializeWithEmptyList();
    notifyListeners();
  }

  void createList(ShoppingList shoppingList) {
    shoppingList.addListener(notifyListeners);
    _shoppingLists.add(shoppingList);
    _selectedList = _shoppingLists.length - 1;
    shoppingList.addListener(notifyListeners);
    notifyListeners();
  }

  set selectedList(int selectedList) {
    _selectedList = selectedList;
    notifyListeners();
  }

  ShoppingList get currentShoppingList => _shoppingLists[_selectedList];

  set shoppingLists(List<ShoppingList> shoppingLists) {
    _unsubscribeFromLists();
    _shoppingLists.clear();
    _shoppingLists.addAll(shoppingLists);
    if (_shoppingLists.isNotEmpty) {
      _selectedList = 0;
    } else {
      _selectedList = -1;
    }
    _subscribeToLists();
    notifyListeners();
  }
}
