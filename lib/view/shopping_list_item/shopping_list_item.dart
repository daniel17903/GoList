import 'package:flutter/material.dart';
import 'package:go_list/style/golist_icons.dart';
import 'package:go_list/view/shopping_list_item/animated_item_container.dart';
import 'package:go_list/view/shopping_list_item/item_animation_controller.dart';
import 'package:go_list/view/shopping_list_item/tap_detector.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../model/item.dart';

const int itemBoxSize = 110;

class ShoppingListItem extends StatefulWidget {
  const ShoppingListItem(
      {Key? key,
      required this.item,
      required this.onItemTapped,
      required this.delayItemTap,
      required this.onItemTappedLong})
      : super(key: key);

  final Item item;
  final Function(Item) onItemTapped;
  final void Function(Item) onItemTappedLong;
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
              () => widget.onItemTapped(widget.item);
        } else {
          widget.onItemTapped(widget.item);
        }
      },
      onReTap: () => animationController.cancelAnimation!(),
      onLongTap: () => widget.onItemTappedLong(widget.item),
      child: AnimatedItemContainer(
        animationController: animationController,
        child: Column(children: [
          Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0, top: 2.0, right: 2.0, bottom: 6.0),
                child: GoListIcons.icon(widget.item.iconName),
              )),
          AutoSizeText(widget.item.name,
              maxLines: 2,
              maxFontSize: 16,
              minFontSize: 13,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white)),
          if (widget.item.amount != null && widget.item.amount!.isNotEmpty)
            Text(widget.item.amount!,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                )),
        ]),
      ),
    );
  }
}
