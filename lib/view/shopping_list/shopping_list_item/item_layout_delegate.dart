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

  @override
  void performLayout(Size size) {
    Offset center = Offset(size.width / 2, size.width / 2);
    double maxContentWidth = size.width - 2 * paddingSide * size.width;

    final Size iconSize = layoutChild(ItemLayoutChild.icon,
        BoxConstraints(maxHeight: size.width * iconHeight));

    final Size nameTextSize = layoutChild(
        ItemLayoutChild.name,
        BoxConstraints(
            maxHeight: size.width * nameHeight,
            maxWidth: maxContentWidth,
            minWidth: maxContentWidth));

    double yBelowIcon = paddingTop * size.width +
        iconSize.height +
        paddingBelowIcon * size.width;

    // vertical center between lower icon border and container bottom
    double yCenterOfNameAndAmount = yBelowIcon +
        (size.width - yBelowIcon) / 2 -
        paddingBelowAmount * size.width;

    double yOfNameAndAmount =
        yCenterOfNameAndAmount - nameTextSize.height / 2;

    if (hasChild(ItemLayoutChild.amount)) {
      final Size amountTextSize = layoutChild(
          ItemLayoutChild.amount,
          BoxConstraints(
              maxHeight: size.width * amountHeight,
              maxWidth: maxContentWidth,
              minWidth: maxContentWidth));

      yOfNameAndAmount = yCenterOfNameAndAmount -
          (nameTextSize.height +
                  amountTextSize.height +
                  paddingBelowName * size.width) /
              2;

      positionChild(ItemLayoutChild.name,
          Offset(paddingSide * size.width, yOfNameAndAmount));
      positionChild(
          ItemLayoutChild.amount,
          Offset(
              paddingSide * size.width,
              yOfNameAndAmount +
                  nameTextSize.height +
                  paddingBelowName * size.width));
    } else {
      positionChild(ItemLayoutChild.name,
          Offset(paddingSide * size.width, yOfNameAndAmount));
    }

    // vertically center icon in available space above text
    double dyIcon = paddingTop * size.width;
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
