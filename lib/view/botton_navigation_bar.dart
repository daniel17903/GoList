import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_list/model/app_state.dart';
import 'package:go_list/model/app_state_notifier.dart';
import 'package:go_list/service/backend_url.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'dialog/dialog_utils.dart';
import 'dialog/edit_list_dialog.dart';

class GoListBottomNavigationBar extends HookConsumerWidget {
  const GoListBottomNavigationBar({Key? key, required this.onMenuButtonTapped})
      : super(key: key);

  final void Function() onMenuButtonTapped;

  void handleClick(BuildContext context, String value, AppState appState) {
    switch (value) {
      case 'Bearbeiten':
        DialogUtils.showSmallAlertDialog(
            context: context, content: EditListDialog());
        break;
      case 'Teilen':
        String currentShoppingListId = appState.currentShoppingList!.id;
        GoListClient()
            .sendRequest(
                endpoint: "/api/shoppinglist/$currentShoppingListId/token",
                httpMethod: HttpMethod.post)
            .then((response) => jsonDecode(utf8.decode(response.bodyBytes)))
            .then((responseJson) => responseJson["token"])
            .then(
                (token) => Share.share("${BackendUrl.httpUrl()}?token=$token"))
            .catchError((_) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Teilen fehlgeschlagen :("))));
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppState appState =
        ref.watch(AppStateNotifier.appStateProvider);
    return BottomAppBar(
      child: Row(children: <Widget>[
        IconButton(
            color: Colors.white,
            tooltip: 'Open navigation menu',
            icon: const Icon(Icons.menu),
            onPressed: onMenuButtonTapped),
        const Spacer(),
        PopupMenuButton<String>(
          onSelected: (value) => handleClick(context, value, appState),
          color: Colors.white,
          icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
          itemBuilder: (BuildContext context) {
            return {'Bearbeiten', 'Teilen'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ]),
    );
  }
}
