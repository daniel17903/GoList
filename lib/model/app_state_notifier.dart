import 'dart:math';

import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/input_to_item_parser.dart';
import 'package:go_list/service/storage/storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_state.dart';

class AppStateNotifier extends StateNotifier<AppState> {
  static final appStateProvider =
      StateNotifierProvider<AppStateNotifier, AppState>(
          (_) => AppStateNotifier(AppState()));

  /**static final appStateUnDeletedShoppingListsProvider =
      StateNotifierProvider<AppStateNotifier, AppState>((ref) {
      final appState = ref.watch(appStateProvider);

      return AppStateNotifier(AppState(
      shoppingLists: appState.shoppingLists.where((e) => !e.deleted).toList(),
      selectedList: appState.selectedList));
      });*/

  AppStateNotifier(AppState appState) : super(appState);

  void updateItem(Item updatedItem) {
    ShoppingList shoppingListWithUpdatedItem =
        currentShoppingList!.copyWith(items: [
      for (final item in currentShoppingList!.items)
        if (item.id == updatedItem.id) updatedItem.copyWith() else item
    ]);

    state = state.copyWith(shoppingLists: [
      for (final shoppingList in state.shoppingLists)
        if (shoppingList.id == shoppingListWithUpdatedItem.id)
          shoppingListWithUpdatedItem
        else
          shoppingList
    ]);
    Storage().saveItems(
        shoppingListWithUpdatedItem, shoppingListWithUpdatedItem.items,
        updateRemoteStorage: true);
  }

  void updateShoppingList(ShoppingList updatedShoppingList,
      {bool updateRemoteStorage = true, bool updateStorage = true}) {
    ShoppingList updatedShoppingListCopy = updatedShoppingList.copyWith();
    state = state.copyWith(shoppingLists: [
      for (final shoppingList in state.shoppingLists)
        if (shoppingList.id == updatedShoppingList.id)
          // new Instance to update modified
          updatedShoppingListCopy
        else
          shoppingList
    ]);
    if (updateStorage) {
      Storage()
          .saveList(updatedShoppingListCopy,
              updateRemoteStorage: updateRemoteStorage)
          .then((_) => Storage().saveItems(
              updatedShoppingListCopy, updatedShoppingListCopy.items,
              updateRemoteStorage: updateRemoteStorage));
    }
  }

  void deleteItem(Item itemToRemove) {
    Item deletedItem = itemToRemove.copyWith(deleted: true);

    ShoppingList shoppingListContainingItem = currentShoppingList!;
    ShoppingList updatedShoppingList = shoppingListContainingItem.copyWith(
        items: shoppingListContainingItem.items
            .map((item) => item.id == itemToRemove.id ? deletedItem : item)
            .toList());
    updateShoppingList(updatedShoppingList, updateStorage: true);
  }

  void deleteCurrentShoppingList() {
    ShoppingList shoppingListToRemove = currentShoppingList!;
    state = AppState(
        shoppingLists: state.shoppingLists
            .where((e) => e.id != shoppingListToRemove.id)
            .toList(),
        selectedList:
            min(state.selectedList, max(state.shoppingLists.length - 2, 0)));
    initializeWithEmptyList();
  }

  void addItem(Item item) {
    addItems([item]);
  }

  void selectList(int index) {
    state = state.copyWith(selectedList: index);
  }

  void addItems(List<Item> items) {
    ShoppingList shoppingListContainingItem = currentShoppingList!;
    ShoppingList updatedShoppingList = shoppingListContainingItem
        .copyWith(items: [...shoppingListContainingItem.items, ...items]);
    updateShoppingList(updatedShoppingList, updateStorage: true);
  }

  void addShoppingList(ShoppingList shoppingList) {
    state = AppState(
        shoppingLists: [...state.shoppingLists, shoppingList],
        selectedList:
            state.shoppingLists.isEmpty ? 0 : state.shoppingLists.length - 1);
    Storage().saveList(shoppingList);
  }

  void setShoppingLists(List<ShoppingList> shoppingLists,
      {bool updateRemoteStorage = false}) {
    print("set ${shoppingLists.length} new shoppinglists");
    if (shoppingLists.isNotEmpty) {
      print("first new list has ${shoppingLists[0].items.length} items");
    }
    state = AppState(
        shoppingLists: shoppingLists,
        selectedList: min(state.selectedList,
            state.shoppingLists.isEmpty ? 0 : shoppingLists.length - 1));
    for (ShoppingList shoppingList in shoppingLists) {
      Storage()
          .saveList(shoppingList, updateRemoteStorage: updateRemoteStorage)
          .then((_) => Storage().saveItems(shoppingList, shoppingList.items,
              updateRemoteStorage: updateRemoteStorage));
    }
  }

  void initializeWithEmptyList() {
    if (state.shoppingLists.isEmpty) {
      setShoppingLists([
        ShoppingList(
            name: "Einkaufsliste",
            items: InputToItemParser.sampleNamesWithIcon()
                .entries
                .map((entry) => Item(name: entry.value, iconName: entry.key))
                .toList())
      ], updateRemoteStorage: true);
      print(
          "added ${currentShoppingList?.items.length} items to list ${currentShoppingList?.id}");
      // TODO sort
    }
  }

  ShoppingList? get currentShoppingList => state.currentShoppingList;

  List<ShoppingList> get shoppingLists => state.shoppingLists;
}
