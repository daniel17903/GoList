import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_list/model/app_state.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/service/storage/provider/remote_storage_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'dialog/dialog_utils.dart';
import 'dialog/edit_list_dialog.dart';

class GoListBottomNavigationBar extends StatelessWidget {
  const GoListBottomNavigationBar({Key? key, required this.onMenuButtonTapped})
      : super(key: key);

  final void Function() onMenuButtonTapped;

  void handleClick(BuildContext context, String value) {
    switch (value) {
      case 'Bearbeiten':
        DialogUtils.showSmallAlertDialog(
            context: context, content: EditListDialog());
        break;
      case 'Teilen':
        String currentShoppingListId =
            context.read<AppState>().currentShoppingList!.id;
        GoListClient()
            .sendRequest(
                endpoint: "/api/shoppinglist/$currentShoppingListId/token",
                httpMethod: HttpMethod.post)
            .then((response) => jsonDecode(utf8.decode(response.bodyBytes)))
            .then((responseJson) => responseJson["token"])
            .then((token) => Share.share(
                "${const String.fromEnvironment('BACKEND_URL')}?token=$token"))
            .catchError((_) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Teilen fehlgeschlagen :("))));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(children: <Widget>[
        IconButton(
            color: Colors.white,
            tooltip: 'Open navigation menu',
            icon: const Icon(Icons.menu),
            onPressed: onMenuButtonTapped),
        const Spacer(),
        PopupMenuButton<String>(
          onSelected: (value) => handleClick(context, value),
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
