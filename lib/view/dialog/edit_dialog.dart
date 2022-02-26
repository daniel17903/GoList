import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/icon_finder.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/shopping_list.dart';

import '../../model/item.dart';
import 'dialog_utils.dart';

class EditDialog extends StatefulWidget {
  const EditDialog(
      {Key? key,
      required this.shoppingList,
      required this.onShoppingListChanged})
      : super(key: key);

  final ShoppingList shoppingList;
  final Function onShoppingListChanged;

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Liste bearbeiten'),
      content: SingleChildScrollView(
        child: TextFormField(
          controller: nameTextInputController,
          decoration: const InputDecoration(
            labelText: "Name",
          ),
          onSaved: (String? value) {},
          validator: (String? value) {
            return (value == null || value.isEmpty)
                ? 'Name darf nicht leer sein'
                : null;
          },
        ),
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
