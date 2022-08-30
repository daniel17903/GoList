import 'package:flutter/material.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/model/list_of.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/view/drawer/create_new_list_tile.dart';
import 'package:go_list/view/drawer/my_lists_header_tile.dart';
import 'package:go_list/view/drawer/shopping_list_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShoppingListDrawer extends HookConsumerWidget {
  const ShoppingListDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ListOf<ShoppingList> shoppingLists =
        ref.watch(AppStateNotifier.notDeletedShoppingListsProvider);
    return Drawer(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
        const MyListsHeaderTile(),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: shoppingLists.length + 1,
              prototypeItem: const MyListsHeaderTile(),
              itemBuilder: (BuildContext context, int index) =>
                  index == shoppingLists.length
                      ? const CreateNewListTile()
                      : ShoppingListTile(index)),
        )
      ],
    ));
  }
}
