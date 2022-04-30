import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_list/view/botton_navigation_bar.dart';
import 'package:go_list/view/dialog/search_dialog.dart';
import 'package:go_list/view/shopping_list/shopping_list_widget.dart';
import 'package:go_list/view/shopping_list_drawer.dart';

import 'dialog/dialog_utils.dart';

class ShoppingListPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ShoppingListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double radiusUnit = min(screenSize.height, screenSize.width);
    return Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
          radius: screenSize.height / radiusUnit, // 2.0 = screen height
          center: Alignment.bottomCenter, // behind the fab
          colors: const <Color>[
            Color(0xffe4b2d2),
            Color(0xffbde5ee),
            Color(0xffd8e8af),
            Color(0xfff6f294),
            Color(0xff005382),
          ],
        )),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            key: _scaffoldKey,
            extendBody: true,
            resizeToAvoidBottomInset: false,
            // prevents resizing when opening keyboard
            bottomNavigationBar: GoListBottomNavigationBar(
                onMenuButtonTapped: () =>
                    _scaffoldKey.currentState?.openDrawer()),
            body: const SafeArea(child: ShoppingListWidget()),
            drawer: const ShoppingListDrawer(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
                tooltip: "Neuer Eintrag",
                onPressed: () => DialogUtils.showLargeAnimatedDialog(
                    context: context, child: const SearchDialog()),
                child: const Icon(Icons.add))));
  }
}
