import 'package:flutter/material.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/view/botton_navigation_bar.dart';
import 'package:go_list/view/dialog/search_dialog.dart';
import 'package:go_list/view/shopping_list/shopping_list_widget.dart';
import 'package:go_list/view/shopping_list_drawer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'dialog/dialog_utils.dart';

class ShoppingListPage extends HookConsumerWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ShoppingListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(AppStateNotifier.appStateProvider);
    if (appState.shoppingLists.isEmpty) {
      print("new appstate without list");
    } else {
      print(
          "ShoppingListPage: ${appState.shoppingLists.length} lists with list id ${appState.currentShoppingList!.id} and ${ref.read(AppStateNotifier.appStateProvider).currentShoppingList!.items.length} items");
    }
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          extendBody: true,
          bottomNavigationBar: GoListBottomNavigationBar(
              onMenuButtonTapped: () =>
                  _scaffoldKey.currentState?.openDrawer()),
          body: const ShoppingListWidget(),
          drawer: const ShoppingListDrawer(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
              tooltip: "Neuer Eintrag",
              onPressed: () => DialogUtils.showLargeAnimatedDialog(
                  context: context, child: SearchDialog()),
              child: const Icon(Icons.add))),
    );
  }
}
