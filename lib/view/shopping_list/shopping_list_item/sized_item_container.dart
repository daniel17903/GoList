import 'package:flutter/material.dart';

class SizedItemContainer extends StatelessWidget {
  final Function() onTapped;
  late final void Function() onTappedLong;
  final Widget Function(double size) childBuilder;
  final Color backgroundColor;
  final double scale;

  SizedItemContainer(
      {super.key,
      required this.onTapped,
      void Function()? onTappedLong,
      required this.childBuilder,
      required this.backgroundColor,
      this.scale = 1}) {
    this.onTappedLong = onTappedLong ?? () => {};
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double size = constraints.maxWidth;
      double scaledSize = size * scale;
      final MediaQueryData data = MediaQuery.of(context);
      return InkWell(
          onTap: onTapped,
          onLongPress: onTappedLong,
          splashFactory: NoSplash.splashFactory,
          child: Container(
            alignment: Alignment.center,
            child: Container(
              width: scaledSize,
              height: scaledSize,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: backgroundColor),
              child: MediaQuery(
                  data: data.copyWith(textScaler: TextScaler.linear(scale)),
                  child: childBuilder(scaledSize)),
            ),
          ));
    });
  }
}
