import 'package:flutter/material.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/shopping_list_item.dart';

import '../model/item.dart';

class GoListWidget extends StatelessWidget {
  const GoListWidget(
      {Key? key,
      required this.items,
      required this.onItemTapped,
      required this.backgroundColor})
      : super(key: key);

  final List<Item> items;
  final Function(Item) onItemTapped;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      constraints: const BoxConstraints.expand(),
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 6.0),
                  child: Wrap(
                      spacing: 4.0, // gap between adjacent chips
                      runSpacing: 4.0,
                      direction: Axis.horizontal,
                      children: items.map((Item item) {
                        return ShoppingListItem(
                          key: ValueKey(item.id),
                          item: item,
                          onItemTapped: onItemTapped,
                          backgroundColor: backgroundColor,
                        );
                      }).toList())))),
    );
  }
}
