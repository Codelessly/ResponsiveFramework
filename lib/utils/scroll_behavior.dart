import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class BouncingScrollBehavior extends ScrollBehavior {
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
      {Key? key, required this.child, this.dragWithMouse = false})
      : super(key: key);

  static Widget builder(BuildContext context, Widget child,
      {bool dragWithMouse = false}) {
    return BouncingScrollWrapper(child: child, dragWithMouse: dragWithMouse);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: BouncingScrollBehavior().copyWith(
          dragDevices: dragWithMouse
              ? {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                }
              : null),
      child: child,
    );
  }
}

class ClampingScrollBehavior extends ScrollBehavior {
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
      {Key? key, required this.child, this.dragWithMouse = false})
      : super(key: key);

  static Widget builder(BuildContext context, Widget child,
      {bool dragWithMouse = false}) {
    return ClampingScrollWrapper(child: child, dragWithMouse: dragWithMouse);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ClampingScrollBehavior().copyWith(
          dragDevices: dragWithMouse
              ? {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                }
              : null),
      child: child,
    );
  }
}
