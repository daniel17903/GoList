import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/model/app_state.dart';
import 'package:go_list/service/input_to_item_parser.dart';
import 'package:go_list/service/storage/storage.dart';
import 'package:go_list/view/platform_widgets/golist_platform_text_form_field.dart';
import 'package:provider/provider.dart';

import '../../model/item.dart';

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
      title: const Text('Eintrag bearbeiten'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GoListPlatformTextFormField(
              controller: nameTextInputController, labelText: "Name"),
          GoListPlatformTextFormField(
              controller: amountInputController, labelText: "Menge")
        ],
      ),
      actions: <Widget>[
        PlatformDialogAction(
          child: const Text('Abbrechen'),
          onPressed: () => Navigator.pop(context),
        ),
        PlatformDialogAction(
            child: const Text('Speichern'),
            onPressed: () {
              widget.item.name = nameTextInputController.text;
              widget.item.amount = amountInputController.text;
              widget.item.iconName = InputToItemParser.findMatchingIconForName(
                  nameTextInputController.text);
              widget.item.modified = DateTime.now().millisecondsSinceEpoch;
              Storage().saveItems(
                  context.read<AppState>().currentShoppingList!, [widget.item]);
              Navigator.pop(context);
            })
      ],
    );
  }
}
