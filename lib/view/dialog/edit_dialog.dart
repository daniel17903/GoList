import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/view/platform_widgets/golist_platform_text_form_field.dart';

class EditDialog extends StatefulWidget {
  const EditDialog(
      {Key? key,
      required this.shoppingList,
      required this.onShoppingListChanged,
      required this.onShoppingListDeleted})
      : super(key: key);

  final ShoppingList shoppingList;
  final Function onShoppingListChanged;
  final Function onShoppingListDeleted;

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late final TextEditingController nameTextInputController;

  @override
  void initState() {
    super.initState();
    nameTextInputController =
        TextEditingController(text: widget.shoppingList.name);
  }

  @override
  void dispose() {
    nameTextInputController.dispose();
    super.dispose();
  }

  void _showAlertDialog({required Function onConfirmed}) {
    showPlatformDialog(
        context: context,
        builder: (BuildContext context) => PlatformAlertDialog(
              title: const Text('Soll diese Liste wirklich gelöscht werden?'),
              actions: <Widget>[
                PlatformDialogAction(
                  child: const Text('Abbrechen'),
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
    return PlatformAlertDialog(
      title: const Text('Liste bearbeiten'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GoListPlatformTextFormField(
              controller: nameTextInputController, labelText: "Name"),
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 0),
            child: PlatformTextButton(
              onPressed: () => _showAlertDialog(onConfirmed: () {
                Navigator.pop(context);
                widget.onShoppingListDeleted();
              }),
              child: const Text("Liste löschen",
                  style: TextStyle(color: Colors.red)),
            ),
          )
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
              widget.shoppingList.name = nameTextInputController.text;
              widget.onShoppingListChanged();
              Navigator.pop(context);
            })
      ],
    );
  }
}
