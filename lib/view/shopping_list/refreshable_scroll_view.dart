import 'package:flutter/material.dart';

class RefreshableScrollView extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;

  const RefreshableScrollView({Key? key, required this.child, this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget scrollViewContainingChild = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
          // necessary for RefreshIndicator to show
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Container(
              child: child,
              alignment: Alignment.topCenter,
            ),
          ));
    });
    if (onRefresh == null) {
      return scrollViewContainingChild;
    }

    return RefreshIndicator(
        onRefresh: onRefresh ?? () => Future.value(),
        child: scrollViewContainingChild);
  }
}
