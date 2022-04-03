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
  int get selectedList => _selectedList;

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

  Future<void> initializeWithEmptyList() async {
    if (_shoppingLists.isEmpty) {
      createList(ShoppingList(name: "Einkaufsliste"));
      currentShoppingList!.addItems(InputToItemParser.sampleNamesWithIcon()
          .entries
          .map((entry) => Item(name: entry.value, iconName: entry.key))
          .toList());
      notifyListeners();
      print("added ${currentShoppingList?.items.length} items to list ${currentShoppingList?.id}");
      await Storage().saveList(_shoppingLists[0]);
      await Storage().saveItems(_shoppingLists[0], _shoppingLists[0].items);
      // TODO sort
    }
  }

  void removeCurrentList() {
    int indexToRemove = _selectedList;
    _selectedList = 0;
    _shoppingLists[indexToRemove].removeListener(notifyListeners);
    _shoppingLists.removeAt(indexToRemove);
    notifyListeners();
    initializeWithEmptyList();
  }

  void createList(ShoppingList shoppingList) {
    _shoppingLists.add(shoppingList);
    shoppingList.addListener(notifyListeners);
    selectedList = _shoppingLists.length - 1;
  }

  set selectedList(int selectedList) {
    _selectedList = selectedList;
    notifyListeners();
  }

  ShoppingList? get currentShoppingList => _selectedList < _shoppingLists.length
      ? _shoppingLists[_selectedList]
      : null;

  set currentShoppingList(ShoppingList? newCurrentShoppingList){
    if(newCurrentShoppingList == null) return;
    if(currentShoppingList == null){
      createList(newCurrentShoppingList);
    }else{
      currentShoppingList!.removeListener(notifyListeners);
      _shoppingLists[_selectedList] = newCurrentShoppingList;
      _shoppingLists[_selectedList].addListener(notifyListeners);
    }
    notifyListeners();
  }

  set shoppingLists(List<ShoppingList> shoppingLists) {
    _unsubscribeFromLists();
    _shoppingLists = shoppingLists;
    if (_selectedList >= _shoppingLists.length) {
      _selectedList = 0;
    }
    _subscribeToLists();
    notifyListeners();
  }
}
