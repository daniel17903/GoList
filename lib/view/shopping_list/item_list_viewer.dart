import 'package:flutter/material.dart';
import 'package:go_list/view/shopping_list/refreshable_scroll_view.dart';
import 'package:go_list/view/shopping_list_item/shopping_list_item.dart';

import '../../model/item.dart';

const double horizontalPadding = 6;
const double spacing = 6;

class ItemListViewer extends StatelessWidget {
  const ItemListViewer(
      {Key? key,
      required this.items,
      required this.onItemTapped,
      this.delayItemTap = false,
      this.onItemTappedLong,
      this.header,
      this.onPullForRefresh,
      this.footer,
      required this.darkBackground,
      this.onItemAnimationEnd,
      required this.itemColor,
      required this.parentWidth})
      : super(key: key);

  final List<Item> items;
  final void Function(Item) onItemTapped;
  final void Function(Item)? onItemTappedLong;
  final void Function(Item)? onItemAnimationEnd;
  final Future<void> Function()? onPullForRefresh;
  final bool delayItemTap;
  final Widget? header;
  final Widget? footer;
  final bool darkBackground;
  final Color itemColor;
  final double parentWidth;

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
        color: darkBackground ? Theme.of(context).backgroundColor : null,
        decoration: darkBackground
            ? null
            : const BoxDecoration(
                gradient: RadialGradient(
                radius: 2.0,  // 2.0 = screen height
                center: Alignment.bottomCenter, // behind the fab
                colors: <Color>[
                  Color(0xffe4b2d2),
                  Color(0xffbde5ee),
                  Color(0xffd8e8af),
                  Color(0xfff6f294),
                  Color(0xff005382),
                ],
              )),
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
                    Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: items.map((Item item) {
                          return ShoppingListItem(
                            initialScaleFactor:
                                _calcItemBoxScaleFactor(parentWidth),
                            color: itemColor,
                            key: UniqueKey(),
                            item: item,
                            onItemTapped: onItemTapped,
                            onItemTappedLong: onItemTappedLong ?? (_) {},
                            delayItemTap: delayItemTap,
                            onItemAnimationEnd: onItemAnimationEnd,
                          );
                        }).toList()),
                    if (footer != null) footer!
                  ],
                ))));
  }
}
