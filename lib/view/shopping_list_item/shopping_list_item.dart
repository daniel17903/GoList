import 'package:flutter/material.dart';
import 'package:go_list/style/golist_icons.dart';
import 'package:go_list/view/shopping_list_item/animated_item_container.dart';
import 'package:go_list/view/shopping_list_item/item_animation_controller.dart';
import 'package:go_list/view/shopping_list_item/item_layout_delegate.dart';
import 'package:go_list/view/shopping_list_item/tap_detector.dart';

import '../../model/item.dart';

const int itemBoxSize = 120;

class ShoppingListItem extends StatefulWidget {
  const ShoppingListItem(
      {Key? key,
      required this.item,
      required this.onItemTapped,
      required this.delayItemTap,
      required this.onItemTappedLong,
      this.onItemAnimationEnd})
      : super(key: key);

  final Item item;
  final Function(Item) onItemTapped;
  final void Function(Item) onItemTappedLong;
  final void Function(Item)? onItemAnimationEnd;
  final bool delayItemTap;

  @override
  State<ShoppingListItem> createState() => _ShoppingListItemState();
}

class _ShoppingListItemState extends State<ShoppingListItem> {
  late final ItemAnimationController animationController;

  @override
  void initState() {
    animationController = ItemAnimationController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TapDetector(
      onTap: () {
        if (widget.delayItemTap) {
          animationController.startAnimation!();
          animationController.onAnimationCompleted =
              () => widget.onItemAnimationEnd!(widget.item);
        }
        widget.onItemTapped(widget.item);
      },
      onReTap: () => animationController.cancelAnimation!(),
      onLongTap: () => widget.onItemTappedLong(widget.item),
      child: AnimatedItemContainer(
        animationController: animationController,
        child: (scaleFactor) => CustomMultiChildLayout(
            delegate:
                ItemLayoutDelegate(containerSize: itemBoxSize * scaleFactor),
            children: [
              LayoutId(
                id: ItemLayoutChild.icon,
                child: GoListIcons.icon(widget.item.iconName),
              ),
              LayoutId(
                id: ItemLayoutChild.name,
                child: Text(widget.item.name,
                    maxLines: 2,
                    textScaleFactor: scaleFactor,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
              ),
              if (widget.item.amount != null && widget.item.amount!.isNotEmpty)
                LayoutId(
                  id: ItemLayoutChild.amount,
                  child: Text(widget.item.amount!,
                      maxLines: 1,
                      textScaleFactor: scaleFactor,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                ),
            ]),
      ),
    );
  }
}
