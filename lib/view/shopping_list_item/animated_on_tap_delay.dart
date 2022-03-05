import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_list/view/shopping_list_item/bounce_then_disappear_animation.dart';

class AnimatedOnTapDelay extends StatefulWidget {
  const AnimatedOnTapDelay(
      {Key? key, required this.onTapped, required this.child})
      : super(key: key);

  final Function() onTapped;
  final Widget child;

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
    return GestureDetector(
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
            _removeTimer = Timer(const Duration(seconds: 3), widget.onTapped);
          }
        },
        child: Container(
          width: _bounceThenDisappearAnimation.value,
          height: _bounceThenDisappearAnimation.value,
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: hasBeenTapped ? Colors.grey : Theme.of(context).cardColor,
          ),
          child: widget.child,
        ));
  }
}
