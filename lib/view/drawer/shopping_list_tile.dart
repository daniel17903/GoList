import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/model/list_of.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShoppingListTile extends HookConsumerWidget {
  final int index;

  const ShoppingListTile(this.index, {Key? key}) : super(key: key);

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
  Widget build(BuildContext context, WidgetRef ref) {
    ListOf<ShoppingList> shoppingLists =
        ref.read(AppStateNotifier.notDeletedShoppingListsProvider);
    return ListTile(
      leading: const Icon(Icons.list),
      title: Text(shoppingLists[index].name),
      onTap: () {
        Navigator.pop(context);
        ref.read(AppStateNotifier.appStateProvider.notifier).selectList(index);
      },
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _showAlertDialog(
            onConfirmed: () {
              ref
                  .read(AppStateNotifier.appStateProvider.notifier)
                  .deleteShoppingList(shoppingLists[index].id, context);
            },
            context: context),
      ),
    );
  }
}
