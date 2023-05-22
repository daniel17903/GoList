import 'package:flutter/material.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/recently_used_item_collection.dart';
import 'package:go_list/model/selected_shopping_list_state.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/shopping_list/item_list_viewer.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/shopping_list_item.dart';
import 'package:provider/provider.dart';

class AddItemListViewer extends StatelessWidget {
  final double parentWidth;
  final RecentlyUsedItemCollection recentlyUsedItemsSorted;
  final void Function(Item) onItemTapped;

  const AddItemListViewer(
      {Key? key,
      required this.parentWidth,
      required this.recentlyUsedItemsSorted,
      required this.onItemTapped})
      : super(key: key);

  ShoppingListItem _widgetForItem(Item item, BuildContext context) =>
      ShoppingListItem(
        parentWidth: parentWidth,
        backgroundColor: GoListColors.addItemDialogItemBackground,
        key: UniqueKey(),
        item: item,
        onItemTapped: onItemTapped,
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedShoppingListState>(
        builder: (context, selectedShoppingListState, child) {
      return ItemListViewer(
        darkBackground: true,
        parentWidth: MediaQuery.of(context).size.width - 80.0,
        body: Wrap(
            spacing: 6,
            runSpacing: 6,
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: recentlyUsedItemsSorted.entries
                .map((item) => _widgetForItem(item, context))
                .toList()),
      );
    });
  }
}
