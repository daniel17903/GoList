import 'package:flutter/material.dart';

import 'dialog/dialog_utils.dart';
import 'dialog/edit_list_dialog.dart';

class GoListBottomNavigationBar extends StatelessWidget {
  const GoListBottomNavigationBar({Key? key, required this.onMenuButtonTapped})
      : super(key: key);

  final void Function() onMenuButtonTapped;

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
        IconButton(
          color: Colors.white,
          icon: const Icon(Icons.edit),
          tooltip: 'Bearbeiten',
          onPressed: () => DialogUtils.showSmallAlertDialog(
              context: context, content: const EditListDialog()),
        ),
      ]),
    );
  }
}
