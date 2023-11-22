import 'package:flutter/material.dart';

import 'shopping_list_item.dart';

class ShoppingListItemWrap extends StatelessWidget {
  final List<ShoppingListItem> children;

  const ShoppingListItemWrap({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}
