import 'package:flutter/material.dart';
import 'package:go_list/style/golist_icons.dart';
import 'package:go_list/view/shopping_list_item/animated_item_container.dart';
import 'package:go_list/view/shopping_list_item/item_animation_controller.dart';
import 'package:go_list/view/shopping_list_item/tap_detector.dart';

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
  bool hasBeenTapped = false;

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
      onReTap: animationController.cancelAnimation,
      onLongTap: () => widget.onItemTappedLong(widget.item),
      child: AnimatedItemContainer(
        animationController: animationController,
        child: (scaleFactor) => Column(children: [
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: GoListIcons.icon(widget.item.iconName),
              )),
          Expanded(
              flex: 2,
              child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: widget.item.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16 * scaleFactor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: widget.item.amount != null &&
                                      widget.item.amount!.isNotEmpty
                                  ? "\n" + widget.item.amount!
                                  : "",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13 * scaleFactor,
                              )),
                        ],
                      ),
                    ),
                  )))
        ]),
      ),
    );
  }
}
