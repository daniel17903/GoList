import 'dart:async';
import 'dart:math';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/bottom_navigation_bar.dart';
import 'package:go_list/view/drawer/shopping_list_drawer.dart';
import 'package:go_list/view/shopping_list/add_item_dialog.dart';
import 'package:go_list/view/shopping_list/main_item_list_viewer.dart';
import 'package:provider/provider.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage>
    with WidgetsBindingObserver {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _appLinks = AppLinks();
    // Check initial link if app was in cold state (terminated)
    _appLinks.getInitialLink().then(handleUri);
    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks.uriLinkStream.listen(handleUri);
  }

  Future<void> handleUri(Uri? uri) async {
    if (uri != null && uri.queryParameters.containsKey("token")) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        GlobalAppState globalAppState =
            Provider.of<GlobalAppState>(context, listen: false);
        try {
          var joinedShoppingList = await globalAppState.goListClient
              .joinListWithToken(uri.queryParameters["token"]!);
          globalAppState.upsertAndSelectShoppingList(joinedShoppingList);
        } catch (e) {
          if(kDebugMode){
            print("failed to join list: $e");
          }
          globalAppState.showConnectionFailure();
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // auto refresh when app is resumed
    if (state == AppLifecycleState.resumed) {
      if (kDebugMode) {
        print("App is resumed, auto refreshing...");
      }
      Provider.of<GlobalAppState>(context, listen: false)
          .loadListsFromStorage();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
          radius: screenSize.height / radiusUnit,
          center: Alignment.bottomCenter,
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
                shape: const CircleBorder(),
                onPressed: () => AddItemDialog.show(context: context),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ))));
  }
}
