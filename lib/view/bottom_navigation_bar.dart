import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/style/colors.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class GoListBottomNavigationBar extends StatelessWidget {
  const GoListBottomNavigationBar({super.key});

  void onShareList(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    String selectedShoppingListId =
        Provider.of<GlobalAppState>(context, listen: false)
            .selectedShoppingList
            .id;
    Provider.of<GlobalAppState>(context, listen: false)
        .goListClient
        .createTokenToShareList(selectedShoppingListId)
        .then(
      (tokenUrl) {
        Share.share(tokenUrl,
            sharePositionOrigin:
                Rect.fromLTWH(0, 0, size.width, size.height / 2));
      },
    ).catchError((e) {
      if (kDebugMode) {
        print("Failed to share list: $e");
      }
      Provider.of<GlobalAppState>(context, listen: false)
          .showConnectionFailure();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: GoListColors.appBarColor,
        shape: const CircularNotchedRectangle(),
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          IconButton(
              color: Colors.white,
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer()),
          const Spacer(),
          Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            textStyle: const TextStyle(fontSize: 16, color: Colors.white),
            message: "${AppLocalizations.of(context).connection_failed} ☹️",
            child: Consumer<GlobalAppState>(
              builder: (context, globalAppState, child) => Visibility(
                visible: globalAppState.shouldShowConnectionFailure,
                child: const Icon(
                  Icons.cloud_off,
                  color: GoListColors.yellow,
                  size: 30,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () => onShareList(context),
              icon: const Icon(Icons.share),
              color: Colors.white)
        ]));
  }
}
