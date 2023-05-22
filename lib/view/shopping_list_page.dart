import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/botton_navigation_bar.dart';
import 'package:go_list/view/shopping_list/add_item_dialog/add_item_dialog.dart';
import 'package:go_list/view/drawer/shopping_list_drawer.dart';
import 'package:go_list/view/shopping_list/main_item_list_viewer.dart';
import 'package:provider/provider.dart';

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
          colors: GoListColors.backgroundGradientColors,
        )),
        child: Consumer<GlobalAppState>(
            builder: (context, appState, child) => Scaffold(
                backgroundColor: Colors.transparent,
                key: _scaffoldKey,
                extendBody: true,
                resizeToAvoidBottomInset: false,
                // prevents resizing when opening keyboard
                bottomNavigationBar: GoListBottomNavigationBar(
                    onMenuButtonTapped: () =>
                        _scaffoldKey.currentState?.openDrawer()),
                body: SafeArea(
                    child: MainItemListViewer(
                        parentWidth: MediaQuery.of(context).size.width)),
                drawer: const ShoppingListDrawer(),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: FloatingActionButton(
                    backgroundColor: GoListColors.appBarColor,
                    onPressed: () => DialogUtils.showLargeAnimatedDialog(
                        context: context, child: const AddItemDialog()),
                    child: const Icon(Icons.add)))));
  }
}
