import 'package:flutter/material.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/sized_item_container.dart';

class UndeleteShoppingListItem extends StatelessWidget {
  final Function() onPressed;

  const UndeleteShoppingListItem(this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedItemContainer(
        onTapped: onPressed,
        backgroundColor: GoListColors.itemBackground,
        childBuilder: (size) => IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.undo,
              color: Colors.white,
              size: size * 0.5,
            )));
  }
}
