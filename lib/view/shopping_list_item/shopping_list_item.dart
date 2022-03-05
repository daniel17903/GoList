import 'package:flutter/material.dart';
import 'package:go_list/style/golist_icons.dart';
import 'package:go_list/view/shopping_list_item/animated_on_tap_delay.dart';

import '../../model/item.dart';

class ShoppingListItem extends StatelessWidget {
  const ShoppingListItem(
      {Key? key, required this.item, required this.onItemTapped})
      : super(key: key);

  final Item item;
  final Function(Item) onItemTapped;

  static const int boxSize = 110;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: boxSize.toDouble(),
        height: boxSize.toDouble(),
        alignment: Alignment.center,
        child: AnimatedOnTapDelay(
          onTapped: () => onItemTapped(item),
          child: Column(children: [
            Expanded(
              flex: 3,
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GoListIcons.icon(item.iconName),
            )),
            Expanded(
              flex: 1,
              child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )),
            )
          ]),
        ));
  }
}
