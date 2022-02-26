import 'package:flutter/material.dart';
import 'package:go_list/style/golist_icons.dart';

import '../model/item.dart';

class ShoppingListItem extends StatelessWidget {
  const ShoppingListItem(
      {Key? key,
      required this.item,
      required this.onItemTapped,
      required this.backgroundColor})
      : super(key: key);

  final Item item;
  final Function(Item) onItemTapped;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onItemTapped(item),
        child: Container(
            width: 120,
            height: 120,
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GoListIcons.icon(item.iconName),
              )),
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ))
            ])));
  }
}
