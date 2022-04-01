import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/model/app_state.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/storage/storage.dart';
import 'package:go_list/view/platform_widgets/golist_platform_text_form_field.dart';
import 'package:provider/provider.dart';

class EditListDialog extends StatefulWidget {
  const EditListDialog({Key? key}) : super(key: key);

  @override
  State<EditListDialog> createState() => _EditListDialogState();
}

class _EditListDialogState extends State<EditListDialog> {
  late final TextEditingController nameTextInputController;

  @override
  void initState() {
    super.initState();
    nameTextInputController = TextEditingController();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      nameTextInputController.text =
          context.read<AppState>().currentShoppingList!.name;
    });
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
    AppState appState = context.watch<AppState>();
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
                appState.currentShoppingList!.deleted = true;
                appState.currentShoppingList!.modified =
                    DateTime.now().millisecondsSinceEpoch;
                Storage().saveList(appState.currentShoppingList!);
                print("removing ${appState.currentShoppingList!.id}");
                appState.removeCurrentList();
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
              ShoppingList shoppingList = appState.currentShoppingList!;
              shoppingList.name = nameTextInputController.text;
              shoppingList.modified = DateTime.now().millisecondsSinceEpoch;
              Storage().saveList(shoppingList);
              Navigator.pop(context);
            })
      ],
    );
  }
}
