import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_list/model/state/global_app_state.dart';
import 'package:go_list/model/state/selected_shopping_list_state.dart';
import 'package:go_list/service/items/input_to_item_parser.dart';
import 'package:go_list/view/app/themed_app.dart';
import 'package:go_list/view/shopping_list_page.dart';
import 'package:provider/provider.dart';

import 'model/state/locale_state.dart';

void main() async {
  await Future.wait([GetStorage.init(), InputToItemParser().init()]);

  runApp(ChangeNotifierProvider<LocaleState>(
    create: (context) => LocaleState(),
    child: MultiProvider(providers: [
      // provides the GlobalAppState
      ChangeNotifierProvider<GlobalAppState>(create: (context) {
        // AppLocalizations.of(context) does not work here
        var globalAppState = GlobalAppState(AppLocalizations.delegate
            .load(Provider.of<LocaleState>(context, listen: false).locale)
            .then((value) => value.default_name));
        globalAppState.loadListsFromStorage();
        return globalAppState;
      }),
      // provides the SelectedShoppingListState based on the GlobalAppState
      ChangeNotifierProxyProvider<GlobalAppState, SelectedShoppingListState>(
          create: (BuildContext context) => SelectedShoppingListState(
              Provider.of<GlobalAppState>(context, listen: false)
                  .getSelectedShoppingList()),
          update: (BuildContext context, GlobalAppState globalAppsSate,
                  SelectedShoppingListState? selectedShoppingListState) =>
              SelectedShoppingListState(
                  globalAppsSate.getSelectedShoppingList()))
    ], builder: (context, child) => const ThemedApp(child: ShoppingListPage())),
  ));
}
