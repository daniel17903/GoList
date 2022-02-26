import 'package:flutter/material.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/icon_finder.dart';
import 'package:go_list/service/local_database.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/dialog/edit_dialog.dart';
import 'package:go_list/view/dialog/search_dialog.dart';
import 'package:go_list/view/shopping_list.dart';
import 'package:get/get.dart';

import '../model/item.dart';
import 'dialog/dialog_utils.dart';

class _ShoppingListPageState extends State<ShoppingListPage> {
  final ShoppingList _shoppingList =
      Get.find<LocalDatabase>().loadShoppingList();

  void _handleItemTapped(Item tappedItem) {
    setState(() {
      _shoppingList.items.removeWhere((e) => e.id == tappedItem.id);
    });
    Get.find<LocalDatabase>().saveList(_shoppingList);
  }

  void _handleItemCreated(Item newItem) {
    setState(() {
      _shoppingList.items.add(newItem);
      _shoppingList.recentlyUsedItems.insert(0, newItem);
      while (_shoppingList.recentlyUsedItems.length > 20) {
        _shoppingList.recentlyUsedItems.removeLast();
      }
    });
    Get.find<LocalDatabase>().saveList(_shoppingList);
  }

  @override
  void initState() {
    // TODO: remove sample item creation
    if (_shoppingList.items.isEmpty) {
      _shoppingList.items.addAll(IconFinder.sampleNamesWithIcon()
          .entries
          .map((entry) => Item(name: entry.value, iconName: entry.key))
          .toList());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: GoListColors.turquoise,
          leading: const IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Menü',
            onPressed: null,
          ),
          title: Text(_shoppingList.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Bearbeiten',
              onPressed: () => DialogUtils.showSmallAlertDialog(
                  context: context,
                  content: EditDialog(
                    shoppingList: _shoppingList,
                    onShoppingListChanged: () {
                      setState(() {});
                      Get.find<LocalDatabase>().saveList(_shoppingList);
                    },
                  )),
            ),
          ],
        ),
        body: ShoppingListWidget(
          items: _shoppingList.items,
          onItemTapped: _handleItemTapped,
          backgroundColor: GoListColors.darkBlue,
        ),
        floatingActionButton: FloatingActionButton(
            tooltip: 'Add Item',
            backgroundColor: Colors.orange,
            onPressed: () => DialogUtils.showLargeAnimatedDialog(
                content: context,
                child: SearchDialog(
                  onItemTapped: (tappedItem) {
                    Navigator.pop(context);
                    _handleItemCreated(tappedItem.copy());
                  },
                  recentlyUsedItems: _shoppingList.recentlyUsedItems,
                )),
            child: const Icon(Icons.add)));
  }
}

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}
