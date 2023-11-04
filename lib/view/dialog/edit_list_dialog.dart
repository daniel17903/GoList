import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/model/state/global_app_state.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/view/platform_widgets/golist_platform_text_form_field.dart';
import 'package:provider/provider.dart';

class EditListDialog extends StatefulWidget {
  final ShoppingList shoppingList;

  const EditListDialog({Key? key, required this.shoppingList})
      : super(key: key);

  @override
  State<EditListDialog> createState() => _EditListDialogState();
}

class _EditListDialogState extends State<EditListDialog> {
  late final TextEditingController _nameTextInputController;

  @override
  void initState() {
    super.initState();
    _nameTextInputController = TextEditingController();
    _nameTextInputController.text = widget.shoppingList.name;
  }

  @override
  void dispose() {
    _nameTextInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAlertDialog(
      title: Text(AppLocalizations.of(context)!.edit_list),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GoListPlatformTextFormField(
              controller: _nameTextInputController,
              labelText: AppLocalizations.of(context)!.name)
        ],
      ),
      actions: <Widget>[
        PlatformDialogAction(
          child: Text(AppLocalizations.of(context)!.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        PlatformDialogAction(
            child: Text(AppLocalizations.of(context)!.save),
            onPressed: () {
              widget.shoppingList.name = _nameTextInputController.text;
              Provider.of<GlobalAppState>(context, listen: false)
                  .upsertShoppingList(widget.shoppingList);
              Navigator.pop(context);
            })
      ],
    );
  }
}
