import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/shopping_list_item.dart';

const double spacing = 6;
const animationDuration = Duration(milliseconds: 500);

class ItemGridView extends StatefulWidget {
  final Function(Item) onItemTapped;
  final Function(Item)? onItemTappedLong;
  final Color itemBackgroundColor;
  final List<Item> items;
  final double maxItemSize;
  final bool animate;

  const ItemGridView(
      {super.key,
      required this.items,
      required this.onItemTapped,
      this.onItemTappedLong,
      required this.itemBackgroundColor,
      required this.maxItemSize,
      required this.animate});

  @override
  State<ItemGridView> createState() => _ItemGridViewState();
}

class _ItemGridViewState extends State<ItemGridView> {
  final GlobalKey<AnimatedGridState> _gridKey = GlobalKey<AnimatedGridState>();
  late List<Item> items;

  @override
  void initState() {
    items = widget.items;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ItemGridView oldWidget) {
    if(widget.animate){
      _animateItemUpdate();
    }
    // even if animate = true this is necessary to ensure correct order
    items = widget.items;
    super.didUpdateWidget(oldWidget);
  }

  bool Function(Item) _equalsNoneById(List<Item> itemsToCompare) {
    return (Item item) => !itemsToCompare.any(item.equalsById);
  }

  /// This is required to call insertItem and removeItem on the AnimatedGrid's
  /// state, see https://api.flutter.dev/flutter/widgets/AnimatedGrid-class.html
  void _animateItemUpdate() {
    List<Item> itemsFromWidget = widget.items;
    List<Item> itemsToRemove = items
        .where((item) =>
            // items that don't exist anymore, e.g. because list changed
            !itemsFromWidget.any(item.equalsById) ||
            // items that have been deleted
            (itemsFromWidget.firstWhere(item.equalsById).deleted == true &&
                item.deleted == false))
        .toList();
    // sort from highest to lowest index
    itemsToRemove.sort((a, b) =>
        items.indexWhere(b.equalsById) - items.indexWhere(a.equalsById));
    List<Item> itemsToAdd =
        itemsFromWidget.where(_equalsNoneById(items)).toList();
    // sort from lowest to highest index
    itemsToAdd.sort((a, b) =>
        itemsFromWidget.indexWhere(a.equalsById) -
        itemsFromWidget.indexWhere(b.equalsById));

    for (var itemToRemove in itemsToRemove) {
      int index = items.indexWhere(itemToRemove.equalsById);
      setState(() {
        items.removeWhere(itemToRemove.equalsById);
        _gridKey.currentState!.removeItem(index,
            (BuildContext context, Animation<double> animation) {
          return removedItemBuilder(context, itemToRemove, animation);
        }, duration: animationDuration);
      });
    }

    for (var itemToAdd in itemsToAdd) {
      int index =
          min(itemsFromWidget.indexWhere(itemToAdd.equalsById), items.length);
      setState(() {
        items.insert(index, itemToAdd);
        _gridKey.currentState!
            .insertItem(index, duration: animationDuration);
      });
    }
  }

  Widget itemBuilder(Item item) {
    return ShoppingListItem(
      item: item,
      backgroundColor: widget.itemBackgroundColor,
      onItemTapped: () {
        widget.onItemTapped(item);
      },
      onItemTappedLong: () {
        if (widget.onItemTappedLong != null) {
          widget.onItemTappedLong!(item);
        }
      },
    );
  }

  Widget animatedItemBuilder(
      BuildContext context, int index, Animation<double> animation) {
    return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.easeOutQuad),
        child: itemBuilder(items.elementAt(index)));
  }

  Widget removedItemBuilder(
      BuildContext context, Item item, Animation<double> animation) {
    return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.easeOutQuad),
        child: ShoppingListItem(
          item: item,
          backgroundColor: widget.itemBackgroundColor,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int itemsPerRow = 1;
        double itemSize;
        while ((itemSize =
                (constraints.maxWidth - ((itemsPerRow - 1) * spacing)) /
                    itemsPerRow) >
            widget.maxItemSize) {
          itemsPerRow++;
        }
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaler: TextScaler.linear(itemSize / 120)),
          child: widget.animate
              ? AnimatedGrid(
                  key: _gridKey,
                  padding: const EdgeInsets.only(bottom: 10),
                  initialItemCount: items.length,
                  itemBuilder: animatedItemBuilder,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: itemsPerRow,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                  ),
                )
              : GridView.count(
                  crossAxisCount: itemsPerRow,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  padding: const EdgeInsets.only(bottom: 10),
                  children: items.map(itemBuilder).toList(),
                ),
        );
      },
    );
  }
}
