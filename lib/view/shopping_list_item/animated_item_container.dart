import 'package:flutter/material.dart';
import 'package:go_list/view/shopping_list_item/bounce_then_disappear_animation.dart';
import 'package:go_list/view/shopping_list_item/item_animation_controller.dart';

class AnimatedItemContainer extends StatefulWidget {
  const AnimatedItemContainer(
      {Key? key,
      required this.child,
      required this.animationController,
      required this.color,
      required this.initialSize})
      : super(key: key);

  final Widget Function(double) child;
  final ItemAnimationController animationController;
  final Color color;
  final double initialSize;

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
    return SizedBox(
      width: (disappearing ? _bounceThenDisappearAnimation.value : 1) *
          widget.initialSize.toDouble(),
      height: widget.initialSize.toDouble(),
      child: Center(
        child: Container(
          width: widget.initialSize * _bounceThenDisappearAnimation.value,
          height: widget.initialSize * _bounceThenDisappearAnimation.value,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: widget.color),
          child: disappearing
              ? null // prevent overflow error
              : widget.child(_bounceThenDisappearAnimation.value),
        ),
      ),
    );
  }
}
