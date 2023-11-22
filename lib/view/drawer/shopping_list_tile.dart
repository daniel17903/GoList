import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/style/colors.dart';
import 'package:provider/provider.dart';

class ShoppingListTile extends StatelessWidget {
  final ShoppingList shoppingList;

  ShoppingListTile(this.shoppingList) : super(key: Key(shoppingList.id));

  void _showAlertDialog(BuildContext context) {
    showPlatformDialog(
        context: context,
        builder: (BuildContext context) => PlatformAlertDialog(
              title: Text(AppLocalizations.of(context).confirm_delete_list),
              actions: <Widget>[
                PlatformDialogAction(
                  child: Text(AppLocalizations.of(context).cancel),
                  onPressed: () => Navigator.pop(context),
                ),
                PlatformDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    Provider.of<GlobalAppState>(context, listen: false)
                        .deleteShoppingList(shoppingList.id);
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.list,
        color: GoListColors.grey,
      ),
      title: Text(
        shoppingList.name,
        style: const TextStyle(letterSpacing: 0),
      ),
      onTap: () {
        Provider.of<GlobalAppState>(context, listen: false)
            .setSelectedShoppingListId(shoppingList.id);
        Navigator.pop(context);
      },
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: GoListColors.grey),
        onPressed: () => _showAlertDialog(context),
      ),
    );
  }
}
