import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_list/view/drawer/create_new_list_dialog.dart';

class CreateNewListTile extends StatelessWidget {
  const CreateNewListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(Icons.add),
        title: Text(AppLocalizations.of(context).create_new_list),
        onTap: () => CreateNewListDialog.show(context));
  }
}
