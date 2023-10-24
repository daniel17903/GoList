import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/dialog/dialog_utils.dart';
import 'package:go_list/view/dialog/settings_dialog.dart';
import 'package:go_list/view/drawer/create_new_list_tile.dart';
import 'package:go_list/view/drawer/my_lists_header_tile.dart';
import 'package:go_list/view/drawer/shopping_list_tile.dart';
import 'package:provider/provider.dart';

class ShoppingListDrawer extends StatelessWidget {
  const ShoppingListDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
              color: GoListColors.appBarColor,
              image: DecorationImage(
                  image: AssetImage("assets/icons/icon_foreground.png"),
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight)),
          child: Text(
            'GoList',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        const MyListsHeaderTile(),
        Expanded(
          child: Consumer<GlobalAppState>(
              builder: (context, globalAppState, _) =>
                  ReorderableListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: globalAppState.shoppingLists.length(),
                      prototypeItem: const MyListsHeaderTile(),
                      footer: const CreateNewListTile(),
                      itemBuilder: (BuildContext context, int index) {
                        ShoppingList shoppingList =
                            globalAppState.shoppingLists.get(index);
                        return ShoppingListTile(
                          shoppingListName: shoppingList.name,
                          key: Key(shoppingList.id),
                          onTap: () {
                            globalAppState
                                .setSelectedShoppingListId(shoppingList.id);
                            Navigator.pop(context);
                          },
                          onDelete: () =>
                              globalAppState.deleteShoppingList(shoppingList),
                        );
                      },
                      onReorder: (int oldIndex, int newIndex) =>
                          globalAppState.updateListOrder(oldIndex, newIndex))),
        ),
        SafeArea(
          top: false,
          child: InkWell(
            onTap: () => DialogUtils.showSmallAlertDialog(
                context: context,
                contentBuilder: (_) => const SettingsDialog()),
            child: Container(
              color: GoListColors.settingsButtonBackground,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 28),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.settings,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      const Icon(Icons.settings, color: Colors.white),
                    ]),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
