import 'package:flutter/material.dart';

class DialogUtils {

  static void showSmallAlertDialog(
      {required BuildContext context,
      required Widget Function(BuildContext) contentBuilder}) {
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: contentBuilder);
  }
}
