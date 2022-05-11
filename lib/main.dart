import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:go_list/service/storage/sync/websocket_sync.dart';
import 'package:go_list/style/themed_app.dart';
import 'package:go_list/view/shopping_list_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulHookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  StreamSubscription? _uriLinkStreamSubscription;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    getInitialUri().then(_joinListWithTokenFromLink);
  }

  @override
  void dispose() {
    _uriLinkStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _joinListWithTokenFromLink(Uri? uri) async {
    if (uri != null && uri.queryParameters.containsKey("token")) {
      try {
        GoListClient goListClient = GoListClient();

        // if app was opened with link lists have not been loaded yet
        await ref
            .read(AppStateNotifier.appStateProvider.notifier)
            .loadAllFromStorage();

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

        if (indexOfNewList == -1) {
          throw Exception("Liste konnte nicht geladen werden");
        }

        ref
            .read(AppStateNotifier.appStateProvider.notifier)
            .selectList(indexOfNewList);
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Öffnen der Liste fehlgeschlagen :( $e")));
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
    return ThemedApp(child: WebsocketSync(child: ShoppingListPage()));
  }
}
