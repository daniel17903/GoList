import 'package:flutter/material.dart';

class DialogUtils {
  static void showLargeAnimatedDialog(
      {required BuildContext context, required Widget child}) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
                .animate(a1),
            child: widget,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) => SafeArea(
              child: Dialog(child: child),
            ));
  }

  static void showSmallAlertDialog(
      {required BuildContext context,
      required Widget Function(BuildContext) contentBuilder}) {
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: contentBuilder);
  }
}
