import 'package:flutter/material.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/shopping_list_item.dart';

const double spacing = 6;

class ItemListViewer extends StatelessWidget {
  final Future<void> Function()? onPullForRefresh;
  final Function(Item) onItemTapped;
  final Function(Item)? onItemTappedLong;
  final Color itemBackgroundColor;
  final Widget? header;
  final List<Item> items;
  final bool darkBackground;
  final double maxItemSize;

  const ItemListViewer(
      {super.key,
      required this.items,
      this.header,
      this.onPullForRefresh,
      required this.darkBackground,
      required this.onItemTapped,
      this.onItemTappedLong,
      required this.itemBackgroundColor,
      required this.maxItemSize});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: darkBackground ? GoListColors.addItemDialogBackground : null,
        constraints: const BoxConstraints.expand(),
        child: RefreshIndicator(
            onRefresh: onPullForRefresh ?? () => Future.value(),
            child: Container(
                padding: const EdgeInsets.only(
                    left: spacing, right: spacing, top: 6),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (header != null) header!,
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          int itemsPerRow = 1;
                          double itemSize;
                          while ((itemSize = (constraints.maxWidth -
                                      ((itemsPerRow - 1) * spacing)) /
                                  itemsPerRow) >
                              maxItemSize) {
                            itemsPerRow++;
                          }
                          final MediaQueryData data = MediaQuery.of(context);
                          return MediaQuery(
                            data: data.copyWith(
                                textScaler: TextScaler.linear(itemSize / 120)),
                            child: GridView.count(
                              crossAxisCount: itemsPerRow,
                              mainAxisSpacing: spacing,
                              crossAxisSpacing: spacing,
                              padding: const EdgeInsets.only(bottom: 10),
                              children: items
                                  .map((item) => ShoppingListItem(
                                        item: item,
                                        size: itemSize,
                                        backgroundColor: itemBackgroundColor,
                                        onItemTapped: () => onItemTapped(item),
                                        onItemTappedLong: () {
                                          if (onItemTappedLong != null) {
                                            onItemTappedLong!(item);
                                          }
                                        },
                                      ))
                                  .toList(),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ))));
  }
}
