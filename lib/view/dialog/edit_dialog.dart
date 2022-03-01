import 'package:flutter/material.dart';
import 'package:go_list/model/shopping_list.dart';

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
  late final nameTextInputController;

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
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Soll diese Liste wirklich gelöscht werden?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Abbrechen'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirmed();
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Liste bearbeiten'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
              controller: nameTextInputController,
              decoration: const InputDecoration(
                labelText: "Name",
              )),
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 0),
            child: TextButton(
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
        TextButton(
          child: const Text("Abbrechen"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("Speichern"),
          onPressed: () {
            widget.shoppingList.name = nameTextInputController.text;
            widget.onShoppingListChanged();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
