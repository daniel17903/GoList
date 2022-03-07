import 'package:flutter/material.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/input_to_item_parser.dart';
import 'package:go_list/service/local_database.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/dialog/edit_dialog.dart';
import 'package:go_list/view/dialog/search_dialog.dart';
import 'package:go_list/view/shopping_list_drawer.dart';
import 'package:go_list/view/shopping_list.dart';
import 'package:get/get.dart';

import '../model/item.dart';
import 'dialog/dialog_utils.dart';

class _ShoppingListPageState extends State<ShoppingListPage> {
  final List<ShoppingList> _shoppingLists =
      Get.find<LocalDatabase>().loadShoppingLists();
  late ShoppingList _shoppingListOfCurrentPage;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _handleItemTapped(Item tappedItem) {
    setState(() {
      _shoppingListOfCurrentPage.items
          .removeWhere((e) => e.id == tappedItem.id);
    });
    Get.find<LocalDatabase>().saveLists(_shoppingLists);
  }

  void _handleItemCreated(Item newItem) {
    setState(() {
      _shoppingListOfCurrentPage.items.add(newItem);
      _shoppingListOfCurrentPage.recentlyUsedItems.insert(0, newItem);
      while (_shoppingListOfCurrentPage.recentlyUsedItems.length > 20) {
        _shoppingListOfCurrentPage.recentlyUsedItems.removeLast();
      }
    });
    Get.find<LocalDatabase>().saveLists(_shoppingLists);
  }

  void initializeWithEmptyList() {
    _shoppingLists.add(
        ShoppingList(name: "Einkaufsliste", items: [], recentlyUsedItems: []));
    _shoppingLists[0].items.addAll(InputToItemParser.sampleNamesWithIcon()
        .entries
        .map((entry) => Item(name: entry.value, iconName: entry.key))
        .toList());
    _shoppingListOfCurrentPage = _shoppingLists.first;
    Get.find<LocalDatabase>().saveLists(_shoppingLists);
  }

  @override
  void initState() {
    if (_shoppingLists.isEmpty) {
      initializeWithEmptyList();
    }
    _shoppingListOfCurrentPage = _shoppingLists[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          extendBody: true,
          bottomNavigationBar: BottomAppBar(
            child: Row(children: <Widget>[
              IconButton(
                color: Colors.white,
                tooltip: 'Open navigation menu',
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer()
              ),
              const Spacer(),
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.edit),
                tooltip: 'Bearbeiten',
                onPressed: () => DialogUtils.showSmallAlertDialog(
                    context: context,
                    content: EditDialog(
                      shoppingList: _shoppingListOfCurrentPage,
                      onShoppingListChanged: () {
                        setState(() {});
                        Get.find<LocalDatabase>().saveLists(_shoppingLists);
                      },
                      onShoppingListDeleted: () {
                        _shoppingLists.removeWhere(
                            (e) => e.id == _shoppingListOfCurrentPage.id);
                        Get.find<LocalDatabase>().saveLists(_shoppingLists);
                        setState(() {
                          if (_shoppingLists.isEmpty) {
                            initializeWithEmptyList();
                          }
                          _shoppingListOfCurrentPage = _shoppingLists.last;
                        });
                      },
                    )),
              ),
            ]),
          ),
          body: ShoppingListWidget(
            items: _shoppingListOfCurrentPage.items,
            onItemTapped: _handleItemTapped
          ),
          drawer: ShoppingListDrawer(
            shoppingLists: _shoppingLists,
            onListClicked: (clickedShoppingList) =>
                setState(() => _shoppingListOfCurrentPage = clickedShoppingList),
            onListCreated: (listName) {
              setState(() {
                _shoppingLists.add(ShoppingList(
                    name: listName, items: [], recentlyUsedItems: []));
                _shoppingListOfCurrentPage = _shoppingLists.last;
              });
              Get.find<LocalDatabase>().saveLists(_shoppingLists);
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
              tooltip: "Neuer Eintrag",
              onPressed: () => DialogUtils.showLargeAnimatedDialog(
                  content: context,
                  child: SearchDialog(
                    onItemTapped: (tappedItem) {
                      Navigator.pop(context);
                      _handleItemCreated(tappedItem.copy());
                    },
                    recentlyUsedItems:
                        _shoppingListOfCurrentPage.recentlyUsedItems,
                  )),
              child: const Icon(Icons.add))),
    );
  }
}

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}
