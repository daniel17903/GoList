import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:go_list/view/shopping_list_item/shopping_list_item.dart';

class BounceThenDisappearAnimation {
  late Animation _bounceAnimation;
  late Animation _disappearAnimation;
  late AnimationController _disappearAnimationController;
  late AnimationController _bounceAnimationController;

  final Function() onValueChanged;
  final Function() onCompleted;
  final Function() onDisappearAnimationStart;

  Timer? bounceAnimationFinishedTimer;
  double value = 1.0;

  static const int bounceDurationMs = 2700;
  static const int disappearDurationMs = 300;

  BounceThenDisappearAnimation(
      {required this.onCompleted,
      required tickProvider,
      required this.onValueChanged,
      required this.onDisappearAnimationStart}) {
    _bounceAnimationController = AnimationController(
        vsync: tickProvider, duration: const Duration(milliseconds: 300));
    _disappearAnimationController = AnimationController(
        vsync: tickProvider,
        duration: const Duration(milliseconds: disappearDurationMs));

    _bounceAnimation = Tween(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _bounceAnimationController,
      curve: Curves.easeInOutSine,
    ))
      ..addListener(() {
        value = _bounceAnimation.value;
        onValueChanged();
      });

    _disappearAnimation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _disappearAnimationController,
      curve: Curves.easeOut,
    ))
      ..addListener(() {
        value = _disappearAnimation.value;
        onValueChanged();
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          onCompleted();
        }
      });
  }

  void _stopBounceAnimationAndStartDisappearAnimation() {
    _bounceAnimationController.reset();
    _disappearAnimationController.forward();
    onDisappearAnimationStart();
  }

  void start() {
    _bounceAnimationController.repeat(reverse: true);
    bounceAnimationFinishedTimer = Timer(
        const Duration(milliseconds: bounceDurationMs),
        _stopBounceAnimationAndStartDisappearAnimation);
  }

  void stop() {
    bounceAnimationFinishedTimer?.cancel();
    _bounceAnimationController.stop();
    _disappearAnimationController.stop();
    _bounceAnimationController.reset();
    _disappearAnimationController.reset();
  }

  void dispose() {
    bounceAnimationFinishedTimer?.cancel();
    _bounceAnimationController.dispose();
    _disappearAnimationController.dispose();
  }
}
