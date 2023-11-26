import 'package:flutter/animation.dart';

class DisappearAnimation {
  late Animation _disappearAnimation;
  late AnimationController _disappearAnimationController;

  final Function() onValueChanged;
  late Function() onCompleted;

  double value = 1.0;

  final int durationMs;

  DisappearAnimation(
      {Function()? onCompleted,
      required tickProvider,
      required this.onValueChanged,
      required this.durationMs}) {
    this.onCompleted = onCompleted ?? () {};
    _disappearAnimationController = AnimationController(
        vsync: tickProvider, duration: Duration(milliseconds: durationMs));

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
          this.onCompleted();
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
