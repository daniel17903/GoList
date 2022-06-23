import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/service/items/icon_mapping.dart';
import 'package:go_list/service/items/input_to_item_parser.dart';
import 'package:go_list/view/platform_widgets/golist_platform_text_form_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/item.dart';

class EditItemDialog extends StatefulHookConsumerWidget {
  const EditItemDialog({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  ConsumerState<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends ConsumerState<EditItemDialog> {
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
              Navigator.pop(context);
              IconMapping iconMapping = InputToItemParser.findMappingForName(
                  nameTextInputController.text);
              ref.read(AppStateNotifier.appStateProvider.notifier).updateItems([
                widget.item.copyWith(
                    name: nameTextInputController.text,
                    amount: amountInputController.text,
                    iconName: iconMapping.assetFileName,
                    category: iconMapping.category,
                    modified: DateTime.now().millisecondsSinceEpoch)
              ]);
            })
      ],
    );
  }
}
