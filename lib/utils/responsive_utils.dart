import '../responsive_wrapper.dart';

/// Util functions for the Responsive Framework.
class ResponsiveUtils {
  /// [ResponsiveBreakpointBehavior] order.
  ///
  /// For breakpoints with the same value, ordering
  /// controls proper breakpoint behavior resolution.
  /// For example, AutoScale overrides Resize.
  /// Tags are always ranked last because they are
  /// inert.
  static Map<ResponsiveBreakpointBehavior, int> breakpointCompartorList = {
    ResponsiveBreakpointBehavior.AUTOSCALEDOWN: 0,
    ResponsiveBreakpointBehavior.RESIZE: 1,
    ResponsiveBreakpointBehavior.AUTOSCALE: 2,
    ResponsiveBreakpointBehavior.TAG: 3
  };

  /// Comparator function to order [ResponsiveBreakpoint]s.
  ///
  /// Order breakpoints from smallest to largest based
  /// on breakpoint value.
  /// When breakpoint values are equal, map
  /// [ResponsiveBreakpointBehavior] to their
  /// ordering value in [breakpointCompartorList]
  /// and compare.
  static int breakpointComparator(
      ResponsiveBreakpoint a, ResponsiveBreakpoint b) {
    // If breakpoints are equal, return in the following order:
    // AutoScaleDown, Resize, AutoScale, Tag.
    if (a.breakpoint == b.breakpoint) {
      return breakpointCompartorList[a.behavior]
          .compareTo(breakpointCompartorList[b.behavior]);
    }

    // Breakpoints are not equal can be compared directly.
    return a.breakpoint.compareTo(b.breakpoint);
  }

  /// Print a visual view of [breakpointSegments]
  /// for debugging purposes.
  static String debugLogBreakpoints(
      List<ResponsiveBreakpointSegment> breakpointSegments) {
    breakpointSegments.forEach((element) {
      print(element);
    });
    return breakpointSegments.toString();
  }
}
