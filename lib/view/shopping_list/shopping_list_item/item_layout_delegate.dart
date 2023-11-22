import 'package:flutter/material.dart';

enum ItemLayoutChild { icon, name, amount }

const paddingTop = 0.05;
const paddingBelowIcon = 0.08;
const paddingBelowName = 0.01;
const paddingBelowAmount = 0.02;
const paddingSide = 0.05;

const iconHeight = 0.45;
const nameHeight = 0.3;
const amountHeight = 0.15;

class ItemLayoutDelegate extends MultiChildLayoutDelegate {
  final double containerSize;

  ItemLayoutDelegate({required this.containerSize});

  @override
  void performLayout(Size size) {
    Offset center = Offset(containerSize / 2, containerSize / 2);
    double maxContentWidth = containerSize - 2 * paddingSide * containerSize;

    final Size iconSize = layoutChild(ItemLayoutChild.icon,
        BoxConstraints(maxHeight: containerSize * iconHeight));

    final Size nameTextSize = layoutChild(
        ItemLayoutChild.name,
        BoxConstraints(
            maxHeight: containerSize * nameHeight,
            maxWidth: maxContentWidth,
            minWidth: maxContentWidth));

    double yBelowIcon = paddingTop * containerSize +
        iconSize.height +
        paddingBelowIcon * containerSize;

    // vertical center between lower icon border and container bottom
    double yCenterOfNameAndAmount = yBelowIcon +
        (containerSize - yBelowIcon) / 2 -
        paddingBelowAmount * containerSize;

    double yOfNameAndAmount =
        yCenterOfNameAndAmount - nameTextSize.height / 2;

    if (hasChild(ItemLayoutChild.amount)) {
      final Size amountTextSize = layoutChild(
          ItemLayoutChild.amount,
          BoxConstraints(
              maxHeight: containerSize * amountHeight,
              maxWidth: maxContentWidth,
              minWidth: maxContentWidth));

      yOfNameAndAmount = yCenterOfNameAndAmount -
          (nameTextSize.height +
                  amountTextSize.height +
                  paddingBelowName * containerSize) /
              2;

      positionChild(ItemLayoutChild.name,
          Offset(paddingSide * containerSize, yOfNameAndAmount));
      positionChild(
          ItemLayoutChild.amount,
          Offset(
              paddingSide * containerSize,
              yOfNameAndAmount +
                  nameTextSize.height +
                  paddingBelowName * containerSize));
    } else {
      positionChild(ItemLayoutChild.name,
          Offset(paddingSide * containerSize, yOfNameAndAmount));
    }

    // vertically center icon in available space above text
    double dyIcon = paddingTop * containerSize;
    double availableExtraSpace = yOfNameAndAmount - dyIcon - iconSize.height;
    dyIcon += availableExtraSpace / 2;

    positionChild(ItemLayoutChild.icon,
        Offset(center.dx - iconSize.width / 2, dyIcon));
  }

  @override
  bool shouldRelayout(covariant ItemLayoutDelegate oldDelegate) {
    return false;
  }
}
