import 'package:flutter/material.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/shopping_list/refreshable_scroll_view.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/shopping_list_item.dart';

const double horizontalPadding = 6;
const double spacing = 6;

class ItemListViewer extends StatelessWidget {
  final Future<void> Function()? onPullForRefresh;
  final Widget? header;
  final Widget? footer;
  final bool darkBackground;
  final double parentWidth;
  final Widget body;

  const ItemListViewer(
      {Key? key,
      required this.body,
      this.header,
      this.onPullForRefresh,
      this.footer,
      required this.darkBackground,
      required this.parentWidth})
      : super(key: key);

  double _calcItemBoxScaleFactor(double parentWidth) {
    double minSize = 90;

    double widthForItems(int itemCount, double itemSize) {
      return itemCount * itemSize +
          (itemCount - 1) * spacing +
          2 * horizontalPadding;
    }

    double size = defaultSize;
    while (widthForItems(3, size) > parentWidth && size > minSize) {
      size--;
    }

    return size / defaultSize;
  }

  double _calcPerfectWidth(BuildContext context) {
    double itemBoxSize = _calcItemBoxScaleFactor(parentWidth) * defaultSize;
    double listWidth =
        MediaQuery.of(context).size.width - 2 * horizontalPadding;
    int itemsPerRow = listWidth ~/ itemBoxSize;
    if (itemsPerRow * itemBoxSize + (itemsPerRow - 1) * spacing > listWidth) {
      itemsPerRow -= 1;
    }
    return itemsPerRow * itemBoxSize +
        (itemsPerRow - 1) * spacing +
        2 * horizontalPadding;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: darkBackground ? GoListColors.addItemDialogBackground : null,
        constraints: const BoxConstraints.expand(),
        child: RefreshableScrollView(
            onRefresh: onPullForRefresh,
            child: Container(
                width: _calcPerfectWidth(context),
                padding: const EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: 6,
                    bottom: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (header != null) header!,
                    body,
                    if (footer != null) footer!
                  ],
                ))));
  }
}
