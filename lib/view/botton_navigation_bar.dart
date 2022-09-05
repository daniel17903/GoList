import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_list/model/app_state.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/service/backend_url.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class GoListBottomNavigationBar extends HookConsumerWidget {
  const GoListBottomNavigationBar({Key? key, required this.onMenuButtonTapped})
      : super(key: key);

  final void Function() onMenuButtonTapped;

  void onShareList(BuildContext context, AppState appState) {
    final Size size = MediaQuery.of(context).size;
    String currentShoppingListId = appState.currentShoppingList!.id;
    GoListClient()
        .sendRequest(
            endpoint: "/api/shoppinglist/$currentShoppingListId/token",
            httpMethod: HttpMethod.post)
        .then((response) => jsonDecode(utf8.decode(response.bodyBytes)))
        .then((responseJson) => responseJson["token"])
        .then(
      (token) {
        Share.share("${BackendUrl.httpUrl()}/join?token=$token",
            sharePositionOrigin:
                Rect.fromLTWH(0, 0, size.width, size.height / 2));
        print("${BackendUrl.httpUrl()}/join?token=$token");
      },
    ).catchError((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.failed_to_share_list)));
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomAppBar(
        child: Row(children: <Widget>[
      IconButton(
          color: Colors.white,
          icon: const Icon(Icons.menu),
          onPressed: onMenuButtonTapped),
      const Spacer(),
      IconButton(
          onPressed: () =>
              onShareList(context, ref.read(AppStateNotifier.appStateProvider)),
          icon: const Icon(Icons.share),
          color: Colors.white)
    ]));
  }
}
