import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ShoppingListTile extends StatelessWidget {
  final String shoppingListName;
  final Function onTap;
  final Function onDelete;

  const ShoppingListTile(
      {Key? key,
      required this.shoppingListName,
      required this.onTap,
      required this.onDelete})
      : super(key: key);

  void _showAlertDialog(
      {required Function onConfirmed, required BuildContext context}) {
    showPlatformDialog(
        context: context,
        builder: (BuildContext context) => PlatformAlertDialog(
              title: Text(AppLocalizations.of(context)!.confirm_delete_list),
              actions: <Widget>[
                PlatformDialogAction(
                  child: Text(AppLocalizations.of(context)!.cancel),
                  onPressed: () => Navigator.pop(context),
                ),
                PlatformDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirmed();
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.list),
      title: Text(shoppingListName),
      onTap: () => onTap(),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () =>
            _showAlertDialog(onConfirmed: onDelete, context: context),
      ),
    );
  }
}
