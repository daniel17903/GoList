import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_list/view/drawer/create_new_list_dialog.dart';

class CreateNewListTile extends StatelessWidget {
  const CreateNewListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(Icons.add),
        title: Text(
          AppLocalizations.of(context).create_new_list,
          style: const TextStyle(letterSpacing: 0),
        ),
        onTap: () => CreateNewListDialog.show(context));
  }
}
