import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/view/platform_widgets/golist_platform_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dialog_utils.dart';

class EditItemDialog extends StatefulWidget {
  const EditItemDialog({super.key, required this.item});

  final Item item;

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();

  static show(BuildContext context, Item item) {
    DialogUtils.showSmallAlertDialog(
        context: context, contentBuilder: (_) => EditItemDialog(item: item));
  }
}

class _EditItemDialogState extends State<EditItemDialog> {
  late final TextEditingController nameTextInputController;
  late final TextEditingController amountInputController;

  @override
  void initState() {
    super.initState();
    nameTextInputController = TextEditingController(text: widget.item.name);
    amountInputController = TextEditingController(text: widget.item.amount);
  }

  @override
  void dispose() {
    nameTextInputController.dispose();
    amountInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAlertDialog(
      title: Text(AppLocalizations.of(context).edit_item),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GoListPlatformTextFormField(
              controller: nameTextInputController,
              labelText:  AppLocalizations.of(context).name),
          GoListPlatformTextFormField(
              controller: amountInputController,
              labelText: AppLocalizations.of(context).amount)
        ],
      ),
      actions: <Widget>[
        PlatformDialogAction(
          child: Text(AppLocalizations.of(context).cancel),
          onPressed: () => Navigator.pop(context),
        ),
        PlatformDialogAction(
            child: Text(AppLocalizations.of(context).save),
            onPressed: () {
              Navigator.pop(context);
              widget.item.setName(nameTextInputController.text);
              widget.item.amount = amountInputController.text;
              Provider.of<GlobalAppState>(context, listen: false)
                  .upsertItem(widget.item);
            })
      ],
    );
  }
}
