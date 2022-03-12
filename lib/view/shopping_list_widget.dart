import 'package:flutter/material.dart';
import 'package:go_list/view/item_list_viewer.dart';
import 'package:provider/provider.dart';

import '../model/app_state.dart';

class ShoppingListWidget extends StatelessWidget {
  const ShoppingListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (BuildContext context, AppState appState, Widget? child) =>
          ItemListViewer(
        items: appState.currentShoppingList.items,
        onItemTapped: (tappedItem) =>
            appState.currentShoppingList.removeItem(tappedItem),
        delayItemTap: true,
      ),
    );
  }
}
