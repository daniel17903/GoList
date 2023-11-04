import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/bottom_navigation_bar.dart';
import 'package:go_list/view/drawer/shopping_list_drawer.dart';
import 'package:go_list/view/shopping_list/add_item_dialog/add_item_dialog.dart';
import 'package:go_list/view/shopping_list/main_item_list_viewer.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double radiusUnit = min(screenSize.height, screenSize.width);
    return Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
          radius: screenSize.height / radiusUnit, // 2.0 = screen height
          center: Alignment.bottomCenter, // behind the fab
          colors: GoListColors.backgroundGradientColors,
        )),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBody: true,
            resizeToAvoidBottomInset: false,
            // prevents resizing when opening keyboard
            bottomNavigationBar: const GoListBottomNavigationBar(),
            body: const MainItemListViewer(),
            drawer: const ShoppingListDrawer(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
                backgroundColor: GoListColors.appBarColor,
                onPressed: () => AddItemDialog.show(context: context),
                child: const Icon(Icons.add))));
  }
}
