import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_list/view/shopping_list_item/shopping_list_item.dart';

import '../model/item.dart';

class ShoppingListWidget extends StatelessWidget {
  const ShoppingListWidget(
      {Key? key, required this.items, required this.onItemTapped})
      : super(key: key);

  final List<Item> items;
  final Function(Item) onItemTapped;
  
  final double horizontalPadding = 6;
  final double spacing = 6;
  
  double _calcPerfectWidth(BuildContext context){
    double listWidth = MediaQuery.of(context).size.width - 2 * horizontalPadding;
    int itemsPerRow = listWidth ~/ itemBoxSize;
    if(itemsPerRow * itemBoxSize + (itemsPerRow - 1) * spacing > listWidth ){
      itemsPerRow -= 1;
    }
    return itemsPerRow * itemBoxSize  + (itemsPerRow - 1) * spacing + 2 * horizontalPadding;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      constraints: const BoxConstraints.expand(),
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
              child: Container(
                width: _calcPerfectWidth(context),
                  padding:
                      EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: 6, bottom: 70),
                  child: Wrap(
                      spacing: spacing, // gap between adjacent chips
                      runSpacing: spacing,
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: items.map((Item item) {
                        return ShoppingListItem(
                          key: ValueKey(item.id),
                          item: item,
                          onItemTapped: onItemTapped,
                        );
                      }).toList())))),
    );
  }
}
