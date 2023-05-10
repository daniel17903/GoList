import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/model/selected_shopping_list_state.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/service/golist_languages.dart';
import 'package:go_list/service/items/input_to_item_parser.dart';
import 'package:go_list/service/storage/local_settings_storage.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:go_list/service/storage/shopping_list_storage.dart';
import 'package:go_list/style/themed_app.dart';
import 'package:go_list/view/shopping_list_page.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      // you must first provider the object that will be passed to the proxy
      ChangeNotifierProvider<GlobalAppState>(
          create: (_) => GlobalAppState().loadListsFromStorage()),
      // Because the ChangeNotifierProxyProvider is being used,
      // each class used must be of ChangeNotifier type
      ChangeNotifierProxyProvider<GlobalAppState, SelectedShoppingListState>(
          // first, create the _proxy_ object, the one that you'll use in your UI
          // at this point, you will have access to the previously provided objects
          create: (BuildContext context) => SelectedShoppingListState(
              Provider.of<GlobalAppState>(context, listen: false)
                  .getSelectedShoppingList()),
          // next, define a function to be called on `update`. It will return the same type
          // as the create method.
          update: (BuildContext context, GlobalAppState globalAppsSate,
                  SelectedShoppingListState? selectedShoppingListState) =>
              SelectedShoppingListState(
                  globalAppsSate.getSelectedShoppingList())),
    ],
    child: const GoListApp(),
  ));
}

class GoListApp extends StatefulWidget {
  const GoListApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.changeLanguage(newLocale);
  }

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<GoListApp> {
  StreamSubscription? _uriLinkStreamSubscription;
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    //getInitialUri().then(_joinListWithTokenFromLink);
    InputToItemParser().init();
    GetStorage.init().then((_) {
      changeLanguage(Locale(GoListLanguages.getLanguageCode()));
    });
  }

  @override
  void dispose() {
    _uriLinkStreamSubscription?.cancel();
    super.dispose();
  }

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
    LocalSettingsStorage().saveSelectedLanguage(locale.languageCode);
    InputToItemParser().init();
  }

  /**
  Future<void> _joinListWithTokenFromLink(Uri? uri) async {
    if (uri != null && uri.queryParameters.containsKey("token")) {
      try {
        GoListClient goListClient = GoListClient();

        // if app was opened with link lists have not been loaded yet
        await ref
            .read(AppStateNotifier.appStateProvider.notifier)
            .loadAllFromStorage();

        // use build context synchronously
        if (!mounted) return;

        ref
            .read(AppStateNotifier.appStateProvider.notifier)
            .initializeWithEmptyList(context);

        List<String> listIdsBeforeJoin = ref
            .read(AppStateNotifier.notDeletedShoppingListsProvider)
            .map((e) => e.id)
            .toList();

        // join the list
        await goListClient.sendRequest(
            endpoint: "/api/joinwithtoken/${uri.queryParameters["token"]}",
            httpMethod: HttpMethod.post);

        // load the new list and sync with local storage
        await ref
            .read(AppStateNotifier.appStateProvider.notifier)
            .loadAllFromStorage();

        int indexOfNewList = ref
            .read(AppStateNotifier.notDeletedShoppingListsProvider)
            .indexWhere(
                (shoppingList) => !listIdsBeforeJoin.contains(shoppingList.id));

        // use build context synchronously
        if (!mounted) return;

        if (indexOfNewList == -1) {
          throw Exception(AppLocalizations.of(context)!.failed_to_load_list);
        }

        ref
            .read(AppStateNotifier.appStateProvider.notifier)
            .selectList(indexOfNewList);
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "${AppLocalizations.of(context)!.failed_to_open_list}: $e")));
      }
    }
  }*/

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _uriLinkStreamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        //_joinListWithTokenFromLink(uri);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemedApp(
      locale: _locale,
      child: ShoppingListPage(),
    );
  }
}
