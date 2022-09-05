import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyListsHeaderTile extends StatelessWidget {
  const MyListsHeaderTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.my_lists,
        style: TextStyle(color: Colors.primaries.first, fontSize: 16),
      ),
    );
  }
}
