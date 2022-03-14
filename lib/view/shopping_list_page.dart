import 'package:flutter/material.dart';
import 'package:go_list/view/botton_navigation_bar.dart';
import 'package:go_list/view/dialog/search_dialog.dart';
import 'package:go_list/view/shopping_list_drawer.dart';
import 'package:go_list/view/shopping_list/shopping_list_widget.dart';

import 'dialog/dialog_utils.dart';

class _ShoppingListPageState extends State<ShoppingListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
                  context: context, child: const SearchDialog()),
              child: const Icon(Icons.add))),
    );
  }
}

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}
