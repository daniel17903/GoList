import 'package:flutter/material.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/style/golist_icons.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/animated_item_container.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/item_animation_controller.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/item_layout_delegate.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/tap_detector.dart';

const double defaultSize = 120;
const double horizontalPadding = 6;
const double spacing = 6;

class ShoppingListItem extends StatefulWidget {
  final Item item;
  final Function(Item) onItemTapped;
  late final void Function(Item) onItemTappedLong;
  late final bool delayItemTap;
  final Color backgroundColor;
  late final double initialScaleFactor;

  ShoppingListItem(
      {Key? key,
      required this.item,
      required this.onItemTapped,
      bool? delayItemTap,
      void Function(Item)? onItemTappedLong,
      required this.backgroundColor,
      required double parentWidth})
      : super(key: key) {
    this.onItemTappedLong = onItemTappedLong ?? (_) => {};
    this.delayItemTap = delayItemTap ?? false;
    initialScaleFactor = _initialScaleFactor(parentWidth);
  }

  @override
  State<ShoppingListItem> createState() => _ShoppingListItemState();

  double _initialScaleFactor(double parentWidth) {
    double minSize = 90;

    double widthForItems(int itemCount, double itemSize) {
      return itemCount * itemSize +
          (itemCount - 1) * spacing +
          2 * horizontalPadding;
    }

    double size = defaultSize;
    while (widthForItems(3, size) > parentWidth && size > minSize) {
      size--;
    }

    return size / defaultSize;
  }
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
        color: widget.backgroundColor,
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
