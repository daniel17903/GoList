import 'package:flutter/material.dart';

const double minSize = 90;
const double spacing = 6;

class SizedItemContainer extends StatelessWidget {
  final Function() onTapped;
  late final void Function() onTappedLong;
  final Widget Function(double size) childBuilder;
  final Color backgroundColor;
  final double scale;
  final bool scaleOuterContainer;
  late final double defaultSize;

  SizedItemContainer(
      {super.key,
      required this.onTapped,
      void Function()? onTappedLong,
      required this.childBuilder,
      required this.backgroundColor,
      this.scale = 1,
      this.scaleOuterContainer = true,
      double? defaultSize}) {
    this.onTappedLong = onTappedLong ?? () => {};
    this.defaultSize = defaultSize ?? 120;
  }

  /// Scale item size so that the available width is filled
  double _initialScaleFactor(double parentWidth) {
    double widthAndSpaceRequiredForItems(int itemCount, double itemSize) {
      const double additionalHorizontalPadding = 6;
      return itemCount * itemSize +
          (itemCount - 1) * spacing +
          2 * additionalHorizontalPadding;
    }

    // decrease size starting from defaultSize until at least 3 items fit in a row
    double size = defaultSize;
    int itemsPerRow = 3;
    while (widthAndSpaceRequiredForItems(itemsPerRow, size) > parentWidth &&
        size > minSize) {
      size--;
    }

    // add more items per row
    while (
        widthAndSpaceRequiredForItems(itemsPerRow + 1, size) <= parentWidth) {
      itemsPerRow++;
    }

    // increase size until minimum space is left
    while (parentWidth - widthAndSpaceRequiredForItems(itemsPerRow, size + 1) >=
        0) {
      size++;
    }

    return size / defaultSize;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var initialScaleFactor = 1; // _initialScaleFactor(constraints.maxWidth);
      double size = constraints.maxWidth;
      double scaledSize = size * scale;
      final MediaQueryData data = MediaQuery.of(context);
      return InkWell(
          onTap: onTapped,
          onLongPress: onTappedLong,
          splashFactory: NoSplash.splashFactory,
          child: Container(
            width: scaleOuterContainer ? scaledSize : size,
            height: scaleOuterContainer ? scaledSize : size,
            alignment: Alignment.center,
            child: Container(
              width: scaledSize,
              height: scaledSize,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: backgroundColor),
              child: MediaQuery(
                  data: data.copyWith(
                      textScaler:
                          TextScaler.linear(initialScaleFactor * scale)),
                  child: childBuilder(scaledSize)),
            ),
          ));
    });
  }
}
