import 'package:flutter/material.dart';
import 'package:go_list/style/golist_icons.dart';

import '../model/item.dart';

class ShoppingListItem extends StatelessWidget {
  const ShoppingListItem(
      {Key? key, required this.item, required this.onItemTapped})
      : super(key: key);

  final Item item;
  final Function(Item) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onItemTapped(item),
        child: Container(
            width: 110,
            height: 110,
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Theme.of(context).cardColor,
            ),
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
