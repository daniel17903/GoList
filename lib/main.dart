import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_list/model/app_state.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/service/storage/provider/local_storage_provider.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:go_list/service/storage/storage.dart';
import 'package:go_list/style/themed_app.dart';
import 'package:go_list/view/shopping_list_page.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;

void main() async {
  await GetStorage.init();
  await Storage().init([LocalStorageProvider(), RemoteStorageProvider()]);
  AppState appState = AppState();
  Storage().loadShoppingLists().listen((shoppingListsFromStorage) {
    appState.shoppingLists = shoppingListsFromStorage;
  }, onDone: () {
    appState.initializeWithEmptyList();
  });
  runApp(MyApp(appState: appState));
}

class MyApp extends StatefulWidget {
  final AppState appState;

  const MyApp({Key? key, required this.appState}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _handleInitialUri();
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri != null && uri.queryParameters.containsKey("token")) {
          print('got initial uri: $uri');
          print('got uri params: ${uri.queryParameters}');
          GoListClient()
            ..init()
            ..sendRequest(
                endpoint: "/api/joinwithtoken/${uri.queryParameters["token"]}",
                httpMethod: HttpMethod.post);
        }
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemedApp(
        child: ChangeNotifierProvider<AppState>(
            create: (context) => widget.appState,
            child: const ShoppingListPage()));
  }
}
