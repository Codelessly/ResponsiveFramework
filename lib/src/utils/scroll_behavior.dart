import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class BouncingScrollBehavior extends ScrollBehavior {
  const BouncingScrollBehavior();

  // Disable overscroll glow.
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  // Set physics to bouncing.
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class BouncingScrollWrapper extends StatelessWidget {
  final Widget child;
  final bool dragWithMouse;

  const BouncingScrollWrapper(
      {super.key, required this.child, this.dragWithMouse = false});

  static Widget builder(BuildContext context, Widget child,
      {bool dragWithMouse = false}) {
    return BouncingScrollWrapper(dragWithMouse: dragWithMouse, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: dragWithMouse
          ? const BouncingScrollBehavior()
              .copyWith(dragDevices: {PointerDeviceKind.mouse})
          : const BouncingScrollBehavior(),
      child: child,
    );
  }
}

class ClampingScrollBehavior extends ScrollBehavior {
  const ClampingScrollBehavior();

  // Disable overscroll glow.
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  // Set physics to clamping.
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}

class ClampingScrollWrapper extends StatelessWidget {
  final Widget child;
  final bool dragWithMouse;

  const ClampingScrollWrapper(
      {super.key, required this.child, this.dragWithMouse = false});

  static Widget builder(BuildContext context, Widget child,
      {bool dragWithMouse = false}) {
    return ClampingScrollWrapper(dragWithMouse: dragWithMouse, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: dragWithMouse
          ? const ClampingScrollBehavior()
              .copyWith(dragDevices: {PointerDeviceKind.mouse})
          : const ClampingScrollBehavior(),
      child: child,
    );
  }
}

class NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class NoScrollbarWrapper extends StatelessWidget {
  final Widget child;

  const NoScrollbarWrapper({super.key, required this.child});

  static Widget builder(BuildContext context, Widget child) {
    return NoScrollbarWrapper(child: child);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoScrollbarBehavior(),
      child: child,
    );
  }
}
