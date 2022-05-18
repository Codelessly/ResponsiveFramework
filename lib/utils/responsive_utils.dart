import 'package:flutter/foundation.dart';

import '../responsive_wrapper.dart';

/// Util functions for the Responsive Framework.
class ResponsiveUtils {
  /// [ResponsiveBreakpointBehavior] order.
  ///
  /// For breakpoints with the same value, ordering
  /// controls proper breakpoint behavior resolution.
  /// Preserve input order for breakpoints..
  /// Tags are always ranked last because they are
  /// inert.
  static Map<ResponsiveBreakpointBehavior, int> breakpointCompartorList = {
    ResponsiveBreakpointBehavior.AUTOSCALEDOWN: 0,
    ResponsiveBreakpointBehavior.RESIZE: 0,
    ResponsiveBreakpointBehavior.AUTOSCALE: 0,
    ResponsiveBreakpointBehavior.TAG: 1,
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
    // If breakpoints are equal, return in comparator order.
    if (a.breakpoint == b.breakpoint) {
      return breakpointCompartorList[a.behavior]!
          .compareTo(breakpointCompartorList[b.behavior]!);
    }

    // Breakpoints are not equal can be compared directly.
    return a.breakpoint.compareTo(b.breakpoint);
  }

  /// Print a visual view of [breakpointSegments]
  /// for debugging purposes.
  static String debugLogBreakpointSegments(
      List<ResponsiveBreakpointSegment> responsiveBreakpointSegments) {
    var stringBuffer = StringBuffer();
    stringBuffer.write('|');
    for (int i = 0; i < responsiveBreakpointSegments.length; i++) {
      // Convenience variable.
      ResponsiveBreakpointSegment segment = responsiveBreakpointSegments[i];
      stringBuffer.write(segment.breakpoint.round());
      List<dynamic> attributes = [];
      String? name = segment.responsiveBreakpoint.name;
      if (name != null) attributes.add(name);
      double scaleFactor = segment.responsiveBreakpoint.scaleFactor;
      if (scaleFactor != 1) attributes.add(scaleFactor);
      if (attributes.isNotEmpty) {
        stringBuffer.write('(');
        for (int i = 0; i < attributes.length; i++) {
          stringBuffer.write(attributes[i]);
          if (i != attributes.length - 1) stringBuffer.write('|');
        }
        stringBuffer.write(')');
      }
      stringBuffer.write(' ----- ');
      if (segment.segmentType == ResponsiveBreakpointBehavior.AUTOSCALEDOWN &&
          segment.breakpoint < segment.responsiveBreakpoint.breakpoint) {
        stringBuffer.write(
            '${describeEnum(segment.segmentType)} from ${segment.responsiveBreakpoint.breakpoint.round()}');
      } else {
        stringBuffer.write(describeEnum(segment.responsiveBreakpoint.behavior));
      }
      if (i != responsiveBreakpointSegments.length - 1) {
        stringBuffer.write(' ----- ');
      }
    }
    stringBuffer.write(' ----- ∞ |');
    debugPrint(stringBuffer.toString());
    return stringBuffer.toString();
  }
}

enum ResponsiveTargetPlatform {
  android,
  fuchsia,
  iOS,
  linux,
  macOS,
  windows,
  web,
}

extension TargetPlatformExtension on TargetPlatform {
  ResponsiveTargetPlatform get responsiveTargetPlatform {
    switch (this) {
      case TargetPlatform.android:
        return ResponsiveTargetPlatform.android;
      case TargetPlatform.fuchsia:
        return ResponsiveTargetPlatform.fuchsia;
      case TargetPlatform.iOS:
        return ResponsiveTargetPlatform.iOS;
      case TargetPlatform.linux:
        return ResponsiveTargetPlatform.linux;
      case TargetPlatform.macOS:
        return ResponsiveTargetPlatform.macOS;
      case TargetPlatform.windows:
        return ResponsiveTargetPlatform.windows;
    }
  }
}
