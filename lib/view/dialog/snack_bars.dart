import 'package:flutter/material.dart';

class SnackBars {
   static void showConnectionFailedSnackBar(BuildContext context) {
     // TODO add text
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Icon(
      Icons.cloud_off,
      color: Colors.white,
    )));
  }
}
