import 'package:flutter/material.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/animation/blink_animation.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/animation/disappear_animation.dart';

class BlinkDisappearItemContainer extends StatefulWidget {
  final Widget Function(double scaleFactor) childBuilder;
  final int disappearAfterMs;
  final bool runAnimation;
  final double initialSize;
  final Color backgroundColor;

  const BlinkDisappearItemContainer(
      {super.key,
      required this.childBuilder,
      required this.disappearAfterMs,
      required this.runAnimation,
      required this.initialSize,
      required this.backgroundColor});

  @override
  State<BlinkDisappearItemContainer> createState() =>
      _BlinkDisappearItemContainerState();
}

class _BlinkDisappearItemContainerState
    extends State<BlinkDisappearItemContainer> with TickerProviderStateMixin {
  DisappearAnimation? disappearAnimation;
  BlinkAnimation? blinkAnimation;
  bool isRunning = false;

  void startStopAnimation() {
    if (!isRunning && widget.runAnimation) {
      isRunning = true;
      int disappearAnimationDurationMs = 250;
      disappearAnimation = DisappearAnimation(
          durationMs: disappearAnimationDurationMs,
          onValueChanged: () => setState(() {}),
          tickProvider: this);
      blinkAnimation = BlinkAnimation.run(
          onCompleted: () => disappearAnimation?.start(),
          tickerProvider: this,
          onValueChanged: () => setState(() {}),
          runForMs: widget.disappearAfterMs - disappearAnimationDurationMs);
    } else if (!widget.runAnimation) {
      disappearAnimation?.dispose();
      blinkAnimation?.dispose();
      isRunning = false;
    }
  }

  @override
  void initState() {
    super.initState();
    startStopAnimation();
  }

  @override
  void didChangeDependencies() {
    startStopAnimation();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant BlinkDisappearItemContainer oldWidget) {
    startStopAnimation();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    disappearAnimation?.dispose();
    blinkAnimation?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1;
    if (isRunning) {
      scale = blinkAnimation!.isCompleted
          ? disappearAnimation!.value
          : blinkAnimation!.value;
    }
    return Container(
        alignment: Alignment.center,
        child: Container(
            width: widget.initialSize * scale,
            height: widget.initialSize * scale,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: widget.backgroundColor),
            child: widget.childBuilder(scale)));
  }
}
