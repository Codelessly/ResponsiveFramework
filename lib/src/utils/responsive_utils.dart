import 'package:flutter/foundation.dart';

import '../breakpoint.dart';

/// Util functions for the Responsive Framework.
class ResponsiveUtils {
  /// Comparator function to order [Breakpoint]s from small to large by start sections.
  static int breakpointComparator(Breakpoint a, Breakpoint b) {
    return a.start.compareTo(b.start);
  }

  /// Print a visual view of [breakpoints]
  /// for debugging purposes.
  static String debugLogBreakpoints(List<Breakpoint>? breakpoints) {
    if (breakpoints == null || breakpoints.isEmpty) return '| Empty |';
    List<Breakpoint> breakpointsHolder = List.from(breakpoints);
    breakpointsHolder.sort(breakpointComparator);

    var stringBuffer = StringBuffer();
    stringBuffer.write('| ');
    for (int i = 0; i < breakpointsHolder.length; i++) {
      // Convenience variable.
      Breakpoint breakpoint = breakpointsHolder[i];
      stringBuffer.write(breakpoint.start);
      stringBuffer.write(' ----- ');
      List<dynamic> attributes = [];
      String? name = breakpoint.name;
      if (name != null) attributes.add(name);
      if (attributes.isNotEmpty) {
        stringBuffer.write('(');
        for (int i = 0; i < attributes.length; i++) {
          stringBuffer.write(attributes[i]);
          if (i != attributes.length - 1) stringBuffer.write(',');
        }
        stringBuffer.write(')');
        stringBuffer.write(' ----- ');
      }
      if (breakpoint.end == double.infinity) {
        stringBuffer.write('∞');
      } else {
        stringBuffer.write(breakpoint.end);
      }
      if (i != breakpoints.length - 1) {
        stringBuffer.write(' ----- ');
      }
    }
    stringBuffer.write(' |');
    debugPrint(stringBuffer.toString());
    return stringBuffer.toString();
  }
}

/// A superset of [TargetPlatform] that includes [web] as an enum option.
/// Flutter's TargetPlatform does not include web as a platform option.
enum ResponsiveTargetPlatform {
  android,
  fuchsia,
  iOS,
  linux,
  macOS,
  windows,
  web,
}

/// A helper extension to convert [TargetPlatform] to [ResponsiveTargetPlatform].
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
