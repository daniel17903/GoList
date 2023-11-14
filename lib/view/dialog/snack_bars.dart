import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SnackBars {
  static void showConnectionFailedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context).connection_failed,
          style: const TextStyle(fontSize: 16),
        ),
        const Icon(
          Icons.mood_bad,
          color: Colors.white,
          size: 30,
        ),
      ],
    )));
  }
}
