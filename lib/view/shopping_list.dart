import 'package:flutter/material.dart';
import 'package:go_list/view/shopping_list_item/shopping_list_item.dart';

import '../model/item.dart';

class ShoppingListWidget extends StatelessWidget {
  const ShoppingListWidget(
      {Key? key, required this.items, required this.onItemTapped})
      : super(key: key);

  final List<Item> items;
  final Function(Item) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      constraints: const BoxConstraints.expand(),
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
              child: Container(
                  padding:
                      const EdgeInsets.only(left: 6, right: 6.0, top: 6, bottom: 70),
                  child: Wrap(
                      spacing: 6.0, // gap between adjacent chips
                      runSpacing: 6.0,
                      direction: Axis.horizontal,
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
