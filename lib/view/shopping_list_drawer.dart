import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/model/list_of.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/view/dialog/dialog_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShoppingListDrawer extends StatefulHookConsumerWidget {
  const ShoppingListDrawer({Key? key}) : super(key: key);

  @override
  ConsumerState<ShoppingListDrawer> createState() => _ShoppingListDrawerState();
}

class _ShoppingListDrawerState extends ConsumerState<ShoppingListDrawer> {
  late final TextEditingController newListNameInputController;

  @override
  void initState() {
    super.initState();
    newListNameInputController = TextEditingController();
  }

  @override
  void dispose() {
    newListNameInputController.dispose();
    super.dispose();
  }

  void _showAlertDialog({required Function onConfirmed}) {
    showPlatformDialog(
        context: context,
        builder: (BuildContext context) => PlatformAlertDialog(
              title: Text(AppLocalizations.of(context)!.confirm_delete_list),
              actions: <Widget>[
                PlatformDialogAction(
                  child: Text(AppLocalizations.of(context)!.cancel),
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
    ListOf<ShoppingList> shoppingLists =
        ref.watch(AppStateNotifier.notDeletedShoppingListsProvider);
    return Drawer(
        //backgroundColor: Theme.of(context).backgroundColor,
        child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
              color: Theme.of(context).bottomAppBarTheme.color,
              image: const DecorationImage(
                  image: AssetImage("assets/icon_foreground.png"),
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight)),
          child: const Text(
            'GoList',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
                title: Text(AppLocalizations.of(context)!.my_lists),
                initiallyExpanded: true,
                maintainState: true,
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: shoppingLists.length,
                      itemBuilder: (BuildContext context, int index) =>
                          ListTile(
                            leading: const Icon(Icons.list),
                            title: Text(shoppingLists[index].name),
                            onTap: () {
                              Navigator.pop(context);
                              ref
                                  .read(AppStateNotifier
                                      .appStateProvider.notifier)
                                  .selectList(index);
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _showAlertDialog(onConfirmed: () {
                                ref
                                    .read(AppStateNotifier
                                        .appStateProvider.notifier)
                                    .deleteShoppingList(
                                        shoppingLists[index].id, context);
                              }),
                            ),
                          )),
                ])),
        ListTile(
          leading: const Icon(Icons.add),
          title: Text(AppLocalizations.of(context)!.create_new_list),
          onTap: () {
            DialogUtils.showSmallAlertDialog(
                context: context,
                content: AlertDialog(
                  title: Text(AppLocalizations.of(context)!.create_new_list),
                  content: TextFormField(
                      controller: newListNameInputController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.name,
                      )),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ShoppingList newShoppingList =
                            ShoppingList(name: newListNameInputController.text);
                        ref
                            .read(AppStateNotifier.appStateProvider.notifier)
                            .addShoppingList(newShoppingList);
                      },
                      child: Text(AppLocalizations.of(context)!.save),
                    ),
                  ],
                ));
          },
        )
      ],
    ));
  }
}
