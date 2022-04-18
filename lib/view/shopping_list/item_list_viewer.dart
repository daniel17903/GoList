import 'package:flutter/material.dart';
import 'package:go_list/view/shopping_list/refreshable_scroll_view.dart';
import 'package:go_list/view/shopping_list_item/shopping_list_item.dart';

import '../../model/item.dart';

class ItemListViewer extends StatelessWidget {
  const ItemListViewer(
      {Key? key,
      required this.items,
      required this.onItemTapped,
      this.delayItemTap = false,
      this.onItemTappedLong,
      this.header,
      this.onPullForRefresh,
      this.footer})
      : super(key: key);

  final List<Item> items;
  final void Function(Item) onItemTapped;
  final void Function(Item)? onItemTappedLong;
  final Future<void> Function()? onPullForRefresh;
  final bool delayItemTap;
  final Widget? header;
  final Widget? footer;

  final double horizontalPadding = 6;
  final double spacing = 6;

  double _calcPerfectWidth(BuildContext context) {
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
        color: Theme.of(context).backgroundColor,
        constraints: const BoxConstraints.expand(),
        child: RefreshableScrollView(
            onRefresh: onPullForRefresh,
            child: Container(
                width: _calcPerfectWidth(context),
                padding: EdgeInsets.only(
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
                        // gap between adjacent chips
                        runSpacing: spacing,
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: items.map((Item item) {
                          return ShoppingListItem(
                            key: UniqueKey(),
                            item: item,
                            onItemTapped: onItemTapped,
                            onItemTappedLong: onItemTappedLong ?? (_) {},
                            delayItemTap: delayItemTap,
                          );
                        }).toList()),
                    if (footer != null) footer!
                  ],
                ))));
  }
}
