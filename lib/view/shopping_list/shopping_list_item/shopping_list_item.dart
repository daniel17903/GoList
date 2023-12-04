import 'package:flutter/material.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/style/golist_icons.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/animation/item_animation_controller.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/item_layout_delegate.dart';

class ShoppingListItem extends StatelessWidget {
  static const int allowUndoForMs = 4000;
  final itemAnimationController = ItemAnimationController();
  final Item item;
  final Color backgroundColor;
  final Function()? onItemTapped;
  final Function()? onItemTappedLong;

  ShoppingListItem(
      {required this.item,
      required this.backgroundColor,
      this.onItemTapped,
      this.onItemTappedLong})
      : super(key: Key(item.id));

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: backgroundColor),
        child: InkWell(
            onTap: onItemTapped ?? () => {},
            onLongPress: onItemTappedLong ?? () => {},
            splashFactory: NoSplash.splashFactory,
            child: CustomMultiChildLayout(
                delegate: ItemLayoutDelegate(),
                children: [
                  LayoutId(
                    id: ItemLayoutChild.icon,
                    child: GoListIcons().getIconImageWidget(item.iconName),
                  ),
                  LayoutId(
                    id: ItemLayoutChild.name,
                    child: Text(item.name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.15,
                            letterSpacing: 0)),
                  ),
                  if (item.amount != null && item.amount!.isNotEmpty)
                    LayoutId(
                      id: ItemLayoutChild.amount,
                      child: Text(item.amount!,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              height: 1.15,
                              letterSpacing: 0)),
                    ),
                ])));
  }
}
