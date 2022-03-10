import 'package:flutter/material.dart';

class TapDetector extends StatefulWidget {
  const TapDetector(
      {Key? key, required this.child, required this.onTap, this.onReTap, required this.onLongTap})
      : super(key: key);

  final Widget child;
  final Function() onTap;
  final Function()? onReTap;
  final Function() onLongTap;

  @override
  State<StatefulWidget> createState() => _TapDetectorState();
}

class _TapDetectorState extends State<TapDetector> {
  bool hasBeenTapped = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (hasBeenTapped) {
            if (widget.onReTap != null) {
              widget.onReTap!();
            }
          } else {
            widget.onTap();
          }
          setState(() {
            hasBeenTapped = !hasBeenTapped;
          });
        },
        onLongPress: widget.onLongTap,
        child: widget.child);
  }
}
