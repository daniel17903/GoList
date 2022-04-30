import 'package:flutter/material.dart';

class TapDetector extends StatefulWidget {
  const TapDetector(
      {Key? key,
      required this.child,
      required this.onTap,
      required this.onLongTap})
      : super(key: key);

  final Widget child;
  final Function() onTap;
  final Function() onLongTap;

  @override
  State<StatefulWidget> createState() => _TapDetectorState();
}

class _TapDetectorState extends State<TapDetector> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onTap,
        onLongPress: widget.onLongTap,
        child: widget.child);
  }
}
