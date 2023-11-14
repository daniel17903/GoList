import 'package:flutter/material.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/dialog/snack_bars.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class GoListBottomNavigationBar extends StatelessWidget {
  const GoListBottomNavigationBar({Key? key}) : super(key: key);

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
      print("Failed to share list: $e");
      SnackBars.showConnectionFailedSnackBar(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: GoListColors.appBarColor,
        shape: const CircularNotchedRectangle(),
        child: Row(children: <Widget>[
          IconButton(
              color: Colors.white,
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer()),
          const Spacer(),
          IconButton(
              onPressed: () => onShareList(context),
              icon: const Icon(Icons.share),
              color: Colors.white)
        ]));
  }
}
