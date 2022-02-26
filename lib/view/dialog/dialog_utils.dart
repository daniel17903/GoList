import 'package:flutter/material.dart';

class DialogUtils {
  static void showLargeAnimatedDialog(
      {required BuildContext content, required Widget child}) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: widget,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: content,
        pageBuilder: (context, animation1, animation2) {
          return SafeArea(
            child: Dialog(child: child),
          );
        });
  }

  static void showSmallAlertDialog(
      {required BuildContext context, required Widget content}) {
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) => content);
  }
}
