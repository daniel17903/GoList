import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_list/view/shopping_list_item/bounce_then_disappear_animation.dart';
import 'package:go_list/view/shopping_list_item/shopping_list_item.dart';

class AnimatedOnTapDelay extends StatefulWidget {
  const AnimatedOnTapDelay(
      {Key? key, required this.onTapped, required this.child})
      : super(key: key);

  final Function() onTapped;
  final Widget Function(double) child;

  @override
  State<AnimatedOnTapDelay> createState() => _AnimatedOnTapDelayState();
}

class _AnimatedOnTapDelayState extends State<AnimatedOnTapDelay>
    with TickerProviderStateMixin {
  bool hasBeenTapped = false;
  Timer? _removeTimer;
  late BounceThenDisappearAnimation _bounceThenDisappearAnimation;

  @override
  void initState() {
    _bounceThenDisappearAnimation = BounceThenDisappearAnimation(
        onValueChanged: () => setState(() {}), tickProvider: this);
    super.initState();
  }

  @override
  void dispose() {
    _bounceThenDisappearAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: _bounceThenDisappearAnimation.disappearValue,
        height: _bounceThenDisappearAnimation.disappearValue,
        alignment: Alignment.center,
        child: GestureDetector(
            onTap: () {
              if (hasBeenTapped) {
                _removeTimer?.cancel();
                _bounceThenDisappearAnimation.stop();
                setState(() {
                  hasBeenTapped = false;
                });
              } else {
                _bounceThenDisappearAnimation.start();
                setState(() {
                  hasBeenTapped = true;
                });
                _removeTimer =
                    Timer(const Duration(seconds: 3), widget.onTapped);
              }
            },
            child: Container(
              width: _bounceThenDisappearAnimation.bounceValue,
              height: _bounceThenDisappearAnimation.bounceValue,
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color:
                    hasBeenTapped ? Colors.grey : Theme.of(context).cardColor,
              ),
              child: widget.child(min(_bounceThenDisappearAnimation.bounceValue,
                      _bounceThenDisappearAnimation.disappearValue) /
                  itemBoxSize),
            )));
  }
}
