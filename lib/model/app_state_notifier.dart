import 'dart:async';
import 'dart:math';

import 'package:get_storage/get_storage.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_state.dart';

class AppStateNotifier extends StateNotifier<AppState> {
  Future<void>? loadingFuture;

  static final appStateProvider =
      StateNotifierProvider<AppStateNotifier, AppState>(
          (_) => AppStateNotifier(AppState()));

  static final currentShoppingListNameProvider = Provider<String>((ref) {
    return ref.watch(appStateProvider
        .select((appState) => appState.currentShoppingList?.name ?? ""));
  });

  static final currentItemsProvider = Provider<List<Item>>((ref) {
    return ref.watch(appStateProvider.select((appState) =>
        appState.currentShoppingList?.items.where((i) => !i.deleted).toList() ??
        []));
  });

  static final notDeletedShoppingListsProvider =
      Provider<List<ShoppingList>>((ref) {
    return ref.watch(appStateProvider
        .select((appState) => appState.notDeletedShoppingLists));
  });

  AppStateNotifier(AppState appState) : super(appState);

  void updateItems(List<Item> updatedItems, {bool updateRemoteStorage = true}) {
    ShoppingList shoppingListWithUpdatedItem =
        currentShoppingList!.withItems(updatedItems);

    state = state.withShoppingList(
        updatedShoppingList: shoppingListWithUpdatedItem);

    // only store last 20 deleted items
    List<Item> itemsToDelete =
        shoppingListWithUpdatedItem.items.where((e) => e.deleted).toList()
          ..sort((item1, item2) => item2.modified.compareTo(item1.modified))
          ..skip(20);

    bool shouldBeRetained(Item item) {
      for (Item itemToDelete in itemsToDelete) {
        if (itemToDelete.id == item.id) return false;
      }
      return true;
    }

    Storage().saveItems(shoppingListWithUpdatedItem,
        shoppingListWithUpdatedItem.items.where(shouldBeRetained).toList(),
        updateRemoteStorage: updateRemoteStorage);
  }

  void updateShoppingList(ShoppingList updatedShoppingList,
      {bool updateRemoteStorage = true, bool updateStorage = true}) {
    state = state.withShoppingList(updatedShoppingList: updatedShoppingList);
    if (updateStorage) {
      Storage().saveList(updatedShoppingList,
          updateRemoteStorage: updateRemoteStorage);
    }
  }

  void deleteItems(List<Item> itemsToDelete) {
    itemsToDelete =
        itemsToDelete.map((e) => e.copyWith(deleted: true)).toList();
    ShoppingList updatedShoppingList =
        currentShoppingList!.withItems(itemsToDelete);
    state = state.withShoppingList(updatedShoppingList: updatedShoppingList);
    Storage().saveItems(updatedShoppingList, updatedShoppingList.items,
        updateRemoteStorage: true);
  }

  void deleteShoppingList(String id) {
    ShoppingList shoppingListToRemove =
        shoppingLists.where((sl) => sl.id == id).first.copyWith(deleted: true);
    state = state.withShoppingList(
        updatedShoppingList: shoppingListToRemove,
        updatedSelectedList: min(state.selectedList,
            max(state.notDeletedShoppingLists.length - 2, 0)));
    Storage().saveList(shoppingListToRemove, updateRemoteStorage: true);
    initializeWithEmptyList();
  }

  void addItem(Item item) {
    addItems([item]);
  }

  void selectList(int index) {
    state = state.copyWith(selectedList: index);
    Storage().saveSelectedListIndex(index);
  }

  void addItems(List<Item> items) {
    ShoppingList shoppingListContainingItem = currentShoppingList!;
    ShoppingList updatedShoppingList = shoppingListContainingItem
        .copyWith(items: [...shoppingListContainingItem.items, ...items]);
    state = state.withShoppingList(updatedShoppingList: updatedShoppingList);
    Storage().saveItems(updatedShoppingList, updatedShoppingList.items,
        updateRemoteStorage: true);
  }

  void addShoppingList(ShoppingList shoppingList) {
    int newSelectedList = state.notDeletedShoppingLists.isEmpty
        ? 0
        : state.notDeletedShoppingLists.length;

    state = AppState(
        shoppingLists: [...state.shoppingLists, shoppingList],
        selectedList: newSelectedList);
    Storage().saveList(shoppingList);
    Storage().saveSelectedListIndex(newSelectedList);
  }

  void setShoppingLists(List<ShoppingList> shoppingLists,
      {bool updateRemoteStorage = false, int? selectedListIndex}) async {
    int notDeletedListsCount = shoppingLists.where((sl) => !sl.deleted).length;
    int newSelectedList = min(selectedListIndex ?? state.selectedList,
        max(0, notDeletedListsCount - 1));
    state =
        AppState(shoppingLists: shoppingLists, selectedList: newSelectedList);
    Storage().saveSelectedListIndex(newSelectedList);
    for (ShoppingList shoppingList in shoppingLists) {
      await Storage()
          .saveList(shoppingList, updateRemoteStorage: updateRemoteStorage)
          .then((_) => Storage().saveItems(shoppingList, shoppingList.items,
              updateRemoteStorage: updateRemoteStorage));
    }
  }

  void initializeWithEmptyList() {
    if (state.shoppingLists.where((sl) => !sl.deleted).isEmpty) {
      ShoppingList newList = ShoppingList(
        name: "Einkaufsliste",
      );
      setShoppingLists([...state.shoppingLists, newList],
          updateRemoteStorage: true);
    }
  }

  Future<void> loadAllFromStorage() {
    if (loadingFuture == null) {
      Completer completer = Completer();
      loadingFuture = completer.future;
      GetStorage.init().then((_) =>
          Storage().loadShoppingLists().listen((shoppingListsFromStorage) {
            setShoppingLists(shoppingListsFromStorage,
                selectedListIndex: Storage().loadSelectedListIndex());
          }, onDone: () {
            completer.complete();
            initializeWithEmptyList();
            loadingFuture = null;
          }));
    }
    return loadingFuture!;
  }

  ShoppingList? get currentShoppingList => state.currentShoppingList;

  List<ShoppingList> get shoppingLists => state.shoppingLists;
}
