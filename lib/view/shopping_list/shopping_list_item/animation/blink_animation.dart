import 'dart:async';

import 'package:flutter/animation.dart';

class BlinkAnimation {
  late Animation _animation;
  late AnimationController _controller;
  Timer? timer;

  final Function() onValueChanged;
  late Function() onCompleted;

  double value = 1.0;
  double animateFrom = 1.0;
  double animateTo = 0.93;
  bool isCompleted = false;

  final int durationOfOneBlinkMs = 250;

  BlinkAnimation(
      {Function()? onCompleted,
      required tickProvider,
      required this.onValueChanged}) {
    this.onCompleted = onCompleted ?? () {};
    _controller = AnimationController(
        vsync: tickProvider,
        duration: Duration(milliseconds: durationOfOneBlinkMs),
        reverseDuration: Duration(milliseconds: durationOfOneBlinkMs));

    _animation = Tween(begin: animateFrom, end: animateTo).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuad,
      ),
    )
      ..addListener(() {
        value = _animation.value;
        onValueChanged();
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
  }

  static BlinkAnimation run(
      {required int runForMs,
      Function()? onCompleted,
      required TickerProvider tickerProvider,
      required Function() onValueChanged}) {
    BlinkAnimation blinkAnimation = BlinkAnimation(
        onCompleted: onCompleted,
        tickProvider: tickerProvider,
        onValueChanged: onValueChanged);
    blinkAnimation.start(runForMs);
    return blinkAnimation;
  }

  void start(int runForMs) {
    _controller.forward();
    timer = Timer(Duration(milliseconds: runForMs), () {
      _controller.dispose();
      isCompleted = true;
      onCompleted();
    });
  }

  void dispose() {
    if (timer != null && timer!.isActive) {
      _controller.dispose();
    }
    isCompleted = true;
    timer?.cancel();
  }
}
