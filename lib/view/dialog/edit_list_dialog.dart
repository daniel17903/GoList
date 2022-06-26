import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/model/app_state.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/view/platform_widgets/golist_platform_text_form_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditListDialog extends StatefulHookConsumerWidget {
  const EditListDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<EditListDialog> createState() => _EditListDialogState();
}

class _EditListDialogState extends ConsumerState<EditListDialog> {
  late final TextEditingController nameTextInputController;

  @override
  void initState() {
    super.initState();
    nameTextInputController = TextEditingController();
    nameTextInputController.text = ref
        .read<AppState>(AppStateNotifier.appStateProvider)
        .currentShoppingList!
        .name;
  }

  @override
  void dispose() {
    nameTextInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStateNotifier appStateNotifier =
        ref.watch<AppStateNotifier>(AppStateNotifier.appStateProvider.notifier);
    return PlatformAlertDialog(
      title: Text(AppLocalizations.of(context)!.edit_list),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GoListPlatformTextFormField(
              controller: nameTextInputController,
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
              ShoppingList shoppingList = appStateNotifier.currentShoppingList!;
              appStateNotifier.updateShoppingList(
                  shoppingList.copyWith(name: nameTextInputController.text));
              Navigator.pop(context);
            })
      ],
    );
  }
}
