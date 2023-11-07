import 'dart:async';
import 'dart:math';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/bottom_navigation_bar.dart';
import 'package:go_list/view/drawer/shopping_list_drawer.dart';
import 'package:go_list/view/shopping_list/add_item_dialog/add_item_dialog.dart';
import 'package:go_list/view/shopping_list/main_item_list_viewer.dart';
import 'package:provider/provider.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    // Check initial link if app was in cold state (terminated)
    _appLinks.getInitialAppLink().then(handleUri);
    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks.uriLinkStream.listen(handleUri);
  }

  Future<void> handleUri(Uri? uri) async {
    if (uri != null && uri.queryParameters.containsKey("token")) {
      var joinedShoppingList =
          await GoListClient().joinListWithToken(uri.queryParameters["token"]!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // this will add the shopping list to the state and make it the selected list
        Provider.of<GlobalAppState>(context, listen: false)
            .upsertShoppingList(joinedShoppingList);
      });
    }
    // TODO catch and show error
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

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
