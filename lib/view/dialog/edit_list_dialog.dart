import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/model/app_state.dart';
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
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      nameTextInputController = TextEditingController(
          text: Provider.of<AppState>(context, listen: false)
              .currentShoppingList
              .name);
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
                Provider.of<AppState>(context, listen: false)
                    .removeCurrentList();
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
              Provider.of<AppState>(context, listen: false)
                  .currentShoppingList
                  .name = nameTextInputController.text;
              Navigator.pop(context);
            })
      ],
    );
  }
}
