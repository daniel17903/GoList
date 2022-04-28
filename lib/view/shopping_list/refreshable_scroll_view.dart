import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshableScrollView extends StatefulWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;

  const RefreshableScrollView({Key? key, required this.child, this.onRefresh})
      : super(key: key);

  @override
  State<RefreshableScrollView> createState() => _RefreshableScrollViewState();
}

class _RefreshableScrollViewState extends State<RefreshableScrollView> {
  late final RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: true);
    super.initState();
  }

  void _onRefresh() async {
    try {
      await widget.onRefresh!();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget scrollViewContainingChild = SingleChildScrollView(
        scrollDirection: Axis.vertical, child: Center(child: widget.child));
    if (widget.onRefresh == null) {
      return scrollViewContainingChild;
    }
    return SmartRefresher(
        controller: _refreshController,
        header: const MaterialClassicHeader(),
        onRefresh: _onRefresh,
        child: scrollViewContainingChild);
  }
}
