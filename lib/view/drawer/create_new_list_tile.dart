import 'package:flutter/material.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/view/dialog/dialog_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CreateNewListTile extends StatefulWidget {
  const CreateNewListTile({Key? key}) : super(key: key);

  @override
  State<CreateNewListTile> createState() => _CreateNewListTileState();
}

class _CreateNewListTileState extends State<CreateNewListTile> {
  final TextEditingController _newListNameInputController =
      TextEditingController();

  @override
  void dispose() {
    _newListNameInputController.dispose();
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
                      controller: _newListNameInputController,
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
                        Provider.of<GlobalAppState>(context, listen: false)
                            .upsertShoppingList(ShoppingList(
                                name: _newListNameInputController.text));
                      },
                      child: Text(AppLocalizations.of(context)!.save),
                    ),
                  ],
                ));
      },
    );
  }
}
