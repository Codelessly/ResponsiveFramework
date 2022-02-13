import 'package:flutter/widgets.dart';

class BouncingScrollBehavior extends ScrollBehavior {
  // Disable overscroll glow.
  @override
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

  const BouncingScrollWrapper({Key? key, required this.child})
      : super(key: key);

  static Widget builder(BuildContext context, Widget child) {
    return BouncingScrollWrapper(child: child);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: BouncingScrollBehavior(),
      child: child,
    );
  }
}

class ClampingScrollBehavior extends ScrollBehavior {
  // Disable overscroll glow.
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
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

  const ClampingScrollWrapper({Key? key, required this.child})
      : super(key: key);

  static Widget builder(BuildContext context, Widget child) {
    return ClampingScrollWrapper(child: child);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ClampingScrollBehavior(),
      child: child,
    );
  }
}
