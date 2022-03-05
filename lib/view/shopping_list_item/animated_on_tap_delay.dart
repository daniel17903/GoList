import 'dart:async';

import 'package:flutter/material.dart';

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
  late Animation _animation;
  late AnimationController _animationController;
  Timer? _removeTimer;
  static const int boxSize = 110;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween(
      begin: boxSize.toDouble(),
      end: 105.0,
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutSine))
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (hasBeenTapped) {
            _removeTimer?.cancel();
            _animationController.reset();
            setState(() {
              hasBeenTapped = false;
            });
          } else {
            _animationController.repeat(reverse: true);
            setState(() {
              hasBeenTapped = true;
            });
            _removeTimer = Timer(const Duration(seconds: 3), widget.onTapped);
          }
        },
        child: Container(
            width: boxSize.toDouble(),
            height: boxSize.toDouble(),
            alignment: Alignment.center,
            child: Container(
              width: _animation.value,
              height: _animation.value,
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color:
                    hasBeenTapped ? Colors.grey : Theme.of(context).cardColor,
              ),
              child: widget.child,
            )));
  }
}
