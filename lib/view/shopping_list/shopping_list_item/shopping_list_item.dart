import 'package:flutter/material.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/selected_shopping_list_state.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/style/golist_icons.dart';
import 'package:go_list/view/dialog/edit_item_dialog.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/animated_item_container.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/item_animation_controller.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/item_layout_delegate.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/tap_detector.dart';
import 'package:provider/provider.dart';

const double defaultSize = 120;
const double additionalHorizontalPadding = 6;
const double spacing = 6;

class ShoppingListItem extends StatefulWidget {
  final Item item;
  final Function(Item) onItemTapped;
  late final void Function(Item) onItemTappedLong;
  late final bool delayItemTap;
  late final double horizontalPadding;
  final Color backgroundColor;

  ShoppingListItem(
      {required this.item,
      required this.onItemTapped,
      bool? delayItemTap,
      void Function(Item)? onItemTappedLong,
      required this.backgroundColor,
      this.horizontalPadding = 0})
      : super(key: Key(item.id)) {
    this.onItemTappedLong = onItemTappedLong ?? (_) => {};
    this.delayItemTap = delayItemTap ?? false;
  }

  @override
  State<ShoppingListItem> createState() => _ShoppingListItemState();

  static ShoppingListItem forItem(Item item, BuildContext context) =>
      ShoppingListItem(
        backgroundColor: GoListColors.itemBackground,
        item: item,
        onItemTapped: (tappedItem) =>
            Provider.of<SelectedShoppingListState>(context, listen: false)
                .deleteItem(tappedItem),
        onItemTappedLong: (item) => EditItemDialog.show(context, item),
        delayItemTap: true,
      );
}

class _ShoppingListItemState extends State<ShoppingListItem> {
  late final ItemAnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = ItemAnimationController();
  }

  @override
  void didChangeDependencies() {
    GoListIcons().precacheIconImage(widget.item.iconName, context);
    super.didChangeDependencies();
  }

  double _initialScaleFactor(BuildContext context) {
    double minSize = 90;

    double widthAndSpaceRequiredForItems(int itemCount, double itemSize) {
      return itemCount * itemSize +
          (itemCount - 1) * spacing +
          2 * additionalHorizontalPadding;
    }

    double size = defaultSize;
    while (widthAndSpaceRequiredForItems(3, size) >
            MediaQuery.of(context).size.width - widget.horizontalPadding * 2 &&
        size > minSize) {
      size--;
    }

    return size / defaultSize;
  }

  @override
  Widget build(BuildContext context) {
    var initialScaleFactor = _initialScaleFactor(context);
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
        initialSize: defaultSize * initialScaleFactor,
        color: widget.backgroundColor,
        animationController: animationController,
        child: CustomMultiChildLayout(
            delegate: ItemLayoutDelegate(
                containerSize: defaultSize * initialScaleFactor),
            children: [
              LayoutId(
                id: ItemLayoutChild.icon,
                child: GoListIcons().getIconImageWidget(widget.item.iconName),
              ),
              LayoutId(
                id: ItemLayoutChild.name,
                child: Text(widget.item.name,
                    maxLines: 2,
                    textScaleFactor: initialScaleFactor,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
              ),
              if (widget.item.amount != null && widget.item.amount!.isNotEmpty)
                LayoutId(
                  id: ItemLayoutChild.amount,
                  child: Text(widget.item.amount!,
                      maxLines: 1,
                      textScaleFactor: initialScaleFactor,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                ),
            ]),
      ),
    );
  }
}
