import 'package:flutter/material.dart';
import 'package:go_list/style/golist_icons.dart';
import 'package:go_list/view/shopping_list_item/animated_on_tap_delay.dart';

import '../../model/item.dart';

const int itemBoxSize = 110;

class ShoppingListItem extends StatelessWidget {
  const ShoppingListItem(
      {Key? key, required this.item, required this.onItemTapped})
      : super(key: key);

  final Item item;
  final Function(Item) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return AnimatedOnTapDelay(
      onTapped: () => onItemTapped(item),
      child: (scaleFactor) => Column(children: [
        Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GoListIcons.icon(item.iconName),
            )),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            item.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16 * scaleFactor,
            ),
          ),
        ))
      ]),
    );
  }
}
