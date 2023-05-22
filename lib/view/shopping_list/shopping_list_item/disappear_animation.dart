import 'package:flutter/animation.dart';

class DisappearAnimation {
  late Animation _disappearAnimation;
  late AnimationController _disappearAnimationController;

  final Function() onValueChanged;
  final Function() onCompleted;

  double value = 1.0;

  static const int disappearDurationMs = 200;

  DisappearAnimation(
      {required this.onCompleted,
      required tickProvider,
      required this.onValueChanged}) {
    _disappearAnimationController = AnimationController(
        vsync: tickProvider,
        duration: const Duration(milliseconds: disappearDurationMs));

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

  void start() {
    _disappearAnimationController.forward();
  }

  void dispose() {
    _disappearAnimationController.dispose();
  }
}
