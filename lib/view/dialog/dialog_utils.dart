import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/app_state.dart';

class DialogUtils {
  static void showLargeAnimatedDialog(
      {required BuildContext context, required Widget child}) {
    AppState appState = Provider.of<AppState>(context, listen: false);
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
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return SafeArea(
              child: ChangeNotifierProvider<AppState>.value(
            value: appState,
            child: Dialog(child: child),
          ));
        });
  }

  static void showSmallAlertDialog(
      {required BuildContext context, required Widget content}) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) =>
            ChangeNotifierProvider<AppState>.value(
              value: appState,
              child: content,
            ));
  }
}
