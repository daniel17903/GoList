import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:go_list/view/shopping_list_item/shopping_list_item.dart';

class BounceThenDisappearAnimation {
  late Animation _bounceAnimation;
  late Animation _disappearAnimation;
  late AnimationController _disappearAnimationController;
  late AnimationController _bounceAnimationController;

  final Function() onValueChanged;
  Function()? onCompleted;

  Timer? _bounceAnimationFinishedTimer;
  double bounceValue = itemBoxSize.toDouble();
  double disappearValue = itemBoxSize.toDouble();

  static const int bounceDurationMs = 2700;
  static const int disappearDurationMs = 300;

  BounceThenDisappearAnimation(
      {required tickProvider, required this.onValueChanged}) {
    _bounceAnimationController = AnimationController(
        vsync: tickProvider, duration: const Duration(milliseconds: 300));
    _disappearAnimationController = AnimationController(
        vsync: tickProvider,
        duration: const Duration(milliseconds: disappearDurationMs));

    _bounceAnimation = Tween(
      begin: itemBoxSize.toDouble(),
      end: 105.0,
    ).animate(CurvedAnimation(
      parent: _bounceAnimationController,
      curve: Curves.easeInOutSine,
    ))
      ..addListener(() {
        bounceValue = _bounceAnimation.value;
        onValueChanged();
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _disappearAnimationController.forward();
        }
      });

    _disappearAnimation = Tween(
      begin: itemBoxSize.toDouble(),
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _disappearAnimationController,
      curve: Curves.easeOut,
    ))
      ..addListener(() {
        disappearValue = _disappearAnimation.value;
        onValueChanged();
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && onCompleted != null) {
          onCompleted!();
        }
      });
  }

  void start() {
    _bounceAnimationController.repeat(reverse: true);
    _bounceAnimationFinishedTimer =
        Timer(const Duration(milliseconds: bounceDurationMs), () {
      bounceValue = itemBoxSize.toDouble();
      _bounceAnimationController.reset();
      _disappearAnimationController.forward();
    });
  }

  void stop() {
    _bounceAnimationFinishedTimer?.cancel();
    _bounceAnimationController.reset();
    _disappearAnimationController.reset();
  }

  void dispose() {
    _bounceAnimationController.dispose();
    _disappearAnimationController.dispose();
  }
}
