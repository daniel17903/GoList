import 'package:flutter/material.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/style/colors.dart';
import 'package:provider/provider.dart';

class UndoButton extends StatefulWidget {
  const UndoButton({super.key});

  @override
  State<UndoButton> createState() => _UndoButtonState();
}

class _UndoButtonState extends State<UndoButton> {
  OverlayEntry? overlayEntry;
  double bottom = 0;
  double right = 0;

  OverlayEntry buildOverlay() {
    return OverlayEntry(builder: (BuildContext context) {
      return Positioned(
          bottom: 85.0,
          right: 40.0,
          child: ClipOval(
            child: Material(
              color: GoListColors.itemBackground,
              child: InkWell(
                onTap: () {
                  Provider.of<GlobalAppState>(context, listen: false)
                      .unDeleteItem();
                },
                child: const SizedBox(
                    width: 65,
                    height: 65,
                    child: Icon(
                      Icons.undo,
                      size: 40,
                      color: Colors.white,
                    )),
              ),
            ),
          ));
    });
  }

  @override
  void didChangeDependencies() {
    Provider.of<GlobalAppState>(context, listen: false)
        .addListener(onGlobalStateChanged);
    super.didChangeDependencies();
  }

  void onGlobalStateChanged() {
    if (Provider.of<GlobalAppState>(context, listen: false)
            .recentlyDeletedItems
            .isNotEmpty &&
        overlayEntry == null) {
      overlayEntry = buildOverlay();
      Overlay.of(context, debugRequiredFor: widget).insert(overlayEntry!);
    }
    if (Provider.of<GlobalAppState>(context, listen: false)
            .recentlyDeletedItems
            .isEmpty &&
        overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry!.dispose();
      overlayEntry = null;
    }
  }

  @override
  void dispose() {
    overlayEntry?.remove();
    overlayEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
