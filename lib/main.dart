import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/service/golist_languages.dart';
import 'package:go_list/service/items/input_to_item_parser.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:go_list/service/storage/storage.dart';
import 'package:go_list/service/storage/sync/websocket_sync.dart';
import 'package:go_list/style/themed_app.dart';
import 'package:go_list/view/shopping_list_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(const ProviderScope(child: GoListApp()));
}

class GoListApp extends StatefulHookConsumerWidget {
  const GoListApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.changeLanguage(newLocale);
  }

  @override
  ConsumerState<GoListApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<GoListApp> {
  StreamSubscription? _uriLinkStreamSubscription;
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    getInitialUri().then(_joinListWithTokenFromLink);
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
    Storage().saveSelectedLanguage(locale.languageCode);
    InputToItemParser().init();
  }

  Future<void> _joinListWithTokenFromLink(Uri? uri) async {
    if (uri != null && uri.queryParameters.containsKey("token")) {
      try {
        GoListClient goListClient = GoListClient();

        // if app was opened with link lists have not been loaded yet
        await ref
            .read(AppStateNotifier.appStateProvider.notifier)
            .loadAllFromStorage(context);

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
            .loadAllFromStorage(context);

        int indexOfNewList = ref
            .read(AppStateNotifier.notDeletedShoppingListsProvider)
            .indexWhere(
                (shoppingList) => !listIdsBeforeJoin.contains(shoppingList.id));

        if (indexOfNewList == -1) {
          throw Exception(AppLocalizations.of(context)!.failed_to_load_list);
        }

        ref
            .read(AppStateNotifier.appStateProvider.notifier)
            .selectList(indexOfNewList);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "${AppLocalizations.of(context)!.failed_to_open_list}: $e")));
      }
    }
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _uriLinkStreamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        _joinListWithTokenFromLink(uri);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemedApp(
      child: WebsocketSync(child: ShoppingListPage()),
      locale: _locale,
    );
  }
}
