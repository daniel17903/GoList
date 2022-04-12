import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_list/model/app_state.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:go_list/service/storage/sync/websocket_sync.dart';
import 'package:go_list/style/themed_app.dart';
import 'package:go_list/view/shopping_list_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;

void main() {
  runApp(const MyApp());
}

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (newValue != null && newValue is AppState) {
      print(
          "Logger: ${newValue.shoppingLists.length} ${newValue.currentShoppingList?.items.length}");
    } else {
      print(newValue);
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _uriLinkStreamSubscription;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    _handleInitialUri();
  }

  @override
  void dispose() {
    _uriLinkStreamSubscription?.cancel();
    super.dispose();
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _uriLinkStreamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        print('got uri: ${uri!.queryParameters}');
      });
    }
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri != null && uri.queryParameters.containsKey("token")) {
          print('got initial uri: $uri');
          print('got uri params: ${uri.queryParameters}');
          GoListClient goListClient = GoListClient();
          await goListClient.sendRequest(
              endpoint: "/api/joinwithtoken/${uri.queryParameters["token"]}",
              httpMethod: HttpMethod.post);
        }
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        observers: [Logger()],
        child: ThemedApp(child: WebsocketSync(child: ShoppingListPage())));
  }
}
