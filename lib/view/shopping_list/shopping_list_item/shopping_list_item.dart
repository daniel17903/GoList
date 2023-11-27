import 'package:flutter/material.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/style/golist_icons.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/animation/item_animation_controller.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/item_layout_delegate.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/sized_item_container.dart';

import 'animation/blink_disappear_item_container.dart';

class ShoppingListItem extends StatelessWidget {
  static const int allowUndoForMs = 4000;
  final itemAnimationController = ItemAnimationController();
  final Item item;
  final Color backgroundColor;
  final double defaultSize;
  final Function() onItemTapped;
  final Function()? onItemTappedLong;

  ShoppingListItem(
      {required this.item,
      required this.backgroundColor,
      required this.onItemTapped,
      this.onItemTappedLong,
      this.defaultSize = 120})
      : super(key: Key(item.id));

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double scaleRelativeToParentWidth = constraints.maxWidth / defaultSize;
        return BlinkDisappearItemContainer(
            disappearAfterMs: ShoppingListItem.allowUndoForMs,
            runAnimation: item.deleted,
            childBuilder: (scale) => SizedItemContainer(
                onTapped: onItemTapped,
                onTappedLong: onItemTappedLong ?? () => {},
                backgroundColor: backgroundColor,
                scale: scale,
                childBuilder: (size) => CustomMultiChildLayout(
                        delegate: ItemLayoutDelegate(containerSize: size),
                        children: [
                          LayoutId(
                            id: ItemLayoutChild.icon,
                            child:
                                GoListIcons().getIconImageWidget(item.iconName),
                          ),
                          LayoutId(
                            id: ItemLayoutChild.name,
                            child: Text(item.name,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14 * scaleRelativeToParentWidth,
                                    height: 1.15 * scaleRelativeToParentWidth,
                                    letterSpacing: 0)),
                          ),
                          if (item.amount != null && item.amount!.isNotEmpty)
                            LayoutId(
                              id: ItemLayoutChild.amount,
                              child: Text(item.amount!,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12 * scaleRelativeToParentWidth,
                                      height: 1.15 * scaleRelativeToParentWidth,
                                      letterSpacing: 0)),
                            ),
                        ])));
      },
    );
  }
}
