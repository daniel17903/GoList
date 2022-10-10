import 'package:flutter/material.dart';
import 'package:go_list/style/golist_icons.dart';
import 'package:go_list/view/shopping_list_item/animated_item_container.dart';
import 'package:go_list/view/shopping_list_item/item_animation_controller.dart';
import 'package:go_list/view/shopping_list_item/item_layout_delegate.dart';
import 'package:go_list/view/shopping_list_item/tap_detector.dart';

import '../../model/item.dart';

const double defaultSize = 120;

class ShoppingListItem extends StatefulWidget {
  const ShoppingListItem(
      {Key? key,
      required this.item,
      required this.onItemTapped,
      required this.delayItemTap,
      required this.onItemTappedLong,
      required this.color,
      required this.initialScaleFactor})
      : super(key: key);

  final Item item;
  final Function(Item) onItemTapped;
  final void Function(Item) onItemTappedLong;
  final bool delayItemTap;
  final Color color;
  final double initialScaleFactor;

  @override
  State<ShoppingListItem> createState() => _ShoppingListItemState();
}

class _ShoppingListItemState extends State<ShoppingListItem> {
  late final ItemAnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = ItemAnimationController();
  }

  @override
  Widget build(BuildContext context) {
    return TapDetector(
      onTap: () {
        if (widget.delayItemTap) {
          animationController.startAnimation!();
          animationController.onAnimationCompleted =
              () => widget.onItemTapped(widget.item);
        } else {
          widget.onItemTapped(widget.item);
        }
      },
      onLongTap: () => widget.onItemTappedLong(widget.item),
      child: AnimatedItemContainer(
        initialSize: defaultSize * widget.initialScaleFactor,
        color: widget.color,
        animationController: animationController,
        child: CustomMultiChildLayout(
            delegate: ItemLayoutDelegate(
                containerSize: defaultSize * widget.initialScaleFactor),
            children: [
              LayoutId(
                id: ItemLayoutChild.icon,
                child: GoListIcons().getIconImageWidget(widget.item.iconName),
              ),
              LayoutId(
                id: ItemLayoutChild.name,
                child: Text(widget.item.name,
                    maxLines: 2,
                    textScaleFactor: widget.initialScaleFactor,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
              ),
              if (widget.item.amount != null && widget.item.amount!.isNotEmpty)
                LayoutId(
                  id: ItemLayoutChild.amount,
                  child: Text(widget.item.amount!,
                      maxLines: 1,
                      textScaleFactor: widget.initialScaleFactor,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                ),
            ]),
      ),
    );
  }
}
