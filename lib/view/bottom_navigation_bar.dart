import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/style/colors.dart';
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
    ).catchError((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).failed_to_share_list)));
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
