import 'package:flutter/material.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/disappear_animation.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/item_animation_controller.dart';

class AnimatedItemContainer extends StatefulWidget {
  const AnimatedItemContainer(
      {Key? key,
      required this.child,
      required this.animationController,
      required this.color,
      required this.initialSize})
      : super(key: key);

  final Widget child;
  final ItemAnimationController animationController;
  final Color color;
  final double initialSize;

  @override
  State<AnimatedItemContainer> createState() => _AnimatedItemContainerState();
}

class _AnimatedItemContainerState extends State<AnimatedItemContainer>
    with TickerProviderStateMixin {
  late DisappearAnimation disappearAnimation;
  bool disappearing = false;

  @override
  void initState() {
    super.initState();
    disappearAnimation = DisappearAnimation(
        onCompleted: () => widget.animationController.onAnimationCompleted!(),
        onValueChanged: () => setState(() {}),
        tickProvider: this);

    widget.animationController.startAnimation = () {
      setState(() {
        disappearing = true;
      });
      disappearAnimation.start();
    };
  }

  @override
  void dispose() {
    disappearAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: disappearAnimation.value * widget.initialSize.toDouble(),
      height: disappearAnimation.value * widget.initialSize.toDouble(),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: widget.color),
          child: disappearing
              ? null // prevent overflow error
              : widget.child,
        ),
      ),
    );
  }
}
