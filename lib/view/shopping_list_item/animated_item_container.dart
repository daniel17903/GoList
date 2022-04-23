import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_list/view/shopping_list_item/bounce_then_disappear_animation.dart';
import 'package:go_list/view/shopping_list_item/item_animation_controller.dart';
import 'package:go_list/view/shopping_list_item/shopping_list_item.dart';

class AnimatedItemContainer extends StatefulWidget {
  const AnimatedItemContainer(
      {Key? key, required this.child, required this.animationController})
      : super(key: key);

  final Widget Function(double) child;
  final ItemAnimationController animationController;

  @override
  State<AnimatedItemContainer> createState() => _AnimatedItemContainerState();
}

class _AnimatedItemContainerState extends State<AnimatedItemContainer>
    with TickerProviderStateMixin {
  late BounceThenDisappearAnimation _bounceThenDisappearAnimation;
  bool animationIsRunning = false;
  bool disappearing = false;

  @override
  void initState() {
    super.initState();
    _bounceThenDisappearAnimation = BounceThenDisappearAnimation(
        onCompleted: () => widget.animationController.onAnimationCompleted!(),
        onDisappearAnimationStart: () {
          setState(() {
            disappearing = true;
          });
        },
        onValueChanged: () => setState(() {}),
        tickProvider: this);

    widget.animationController.startAnimation = () {
      setState(() {
        animationIsRunning = true;
      });
      _bounceThenDisappearAnimation.start();
    };
    widget.animationController.cancelAnimation = () {
      _bounceThenDisappearAnimation.stop();
      setState(() {
        animationIsRunning = false;
        disappearing = false;
      });
    };
  }

  @override
  void dispose() {
    widget.animationController.cancelAnimation = () {};
    _bounceThenDisappearAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: _bounceThenDisappearAnimation.disappearValue,
        height: _bounceThenDisappearAnimation.disappearValue,
        alignment: Alignment.center,
        child: Container(
          width: _bounceThenDisappearAnimation.bounceValue,
          height: _bounceThenDisappearAnimation.bounceValue,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: animationIsRunning
                  ? Colors.grey
                  : Theme.of(context).cardColor),
          child: disappearing
              ? null  // prevent overflow error
              : widget.child(min(_bounceThenDisappearAnimation.bounceValue,
                      _bounceThenDisappearAnimation.disappearValue) /
                  itemBoxSize),
        ));
  }
}
