import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/selected_shopping_list_state.dart';
import 'package:go_list/view/platform_widgets/golist_platform_text_form_field.dart';
import 'package:provider/provider.dart';

class EditItemDialog extends StatefulWidget {
  const EditItemDialog({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
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
      title: Text(AppLocalizations.of(context)!.edit_item),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GoListPlatformTextFormField(
              controller: nameTextInputController,
              labelText: AppLocalizations.of(context)!.name),
          GoListPlatformTextFormField(
              controller: amountInputController,
              labelText: AppLocalizations.of(context)!.amount)
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
              Navigator.pop(context);
              widget.item.name = nameTextInputController.text;
              widget.item.amount = amountInputController.text;
              widget.item.findMapping();
              Provider.of<SelectedShoppingListState>(context, listen: false)
                  .upsertItem(widget.item);
            })
      ],
    );
  }
}
