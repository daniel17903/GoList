import 'package:flutter/material.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_list/view/dialog/dialog_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateNewListTile extends StatefulHookConsumerWidget {

  const CreateNewListTile({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateNewListTile> createState() => _CreateNewListTileState();
}

class _CreateNewListTileState extends ConsumerState<CreateNewListTile> {
  final TextEditingController newListNameInputController = TextEditingController();

  @override
  void dispose() {
    newListNameInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add),
      title: Text(AppLocalizations.of(context)!.create_new_list),
      onTap: () {
        DialogUtils.showSmallAlertDialog(
            context: context,
            contentBuilder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.create_new_list),
              content: TextFormField(
                  controller: newListNameInputController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.name,
                  )),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ShoppingList newShoppingList =
                        ShoppingList(name: newListNameInputController.text);
                    ref
                        .read(AppStateNotifier.appStateProvider.notifier)
                        .addShoppingList(newShoppingList);
                  },
                  child: Text(AppLocalizations.of(context)!.save),
                ),
              ],
            ));
      },
    );
  }
}
