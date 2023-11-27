import 'package:flutter/material.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/shopping_list_item.dart';

const double additionalHorizontalPadding = 6;
const double spacing = 6;

class ItemListViewer extends StatelessWidget {
  final Future<void> Function()? onPullForRefresh;
  final Widget? header;
  final List<ShoppingListItem> shoppingListItems;
  final bool darkBackground;

  const ItemListViewer(
      {super.key,
      required this.shoppingListItems,
      this.header,
      this.onPullForRefresh,
      required this.darkBackground});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: darkBackground ? GoListColors.addItemDialogBackground : null,
        constraints: const BoxConstraints.expand(),
        child: RefreshIndicator(
            onRefresh: onPullForRefresh ?? () => Future.value(),
            child: Container(
                padding: const EdgeInsets.only(
                    left: additionalHorizontalPadding,
                    right: additionalHorizontalPadding,
                    top: 6),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (header != null) header!,
                    Expanded(
                      child: GridView.extent(
                        maxCrossAxisExtent: 125,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                        padding: const EdgeInsets.only(bottom: 10),
                        children: shoppingListItems,
                      ),
                    )
                  ],
                ))));
  }
}
