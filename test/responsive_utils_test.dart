import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/utils/responsive_utils.dart';

void main() {
  group('Breakpoint Comparator', () {
    test('Sort Types', () {
      List<ResponsiveBreakpoint> breakpoints = [
        const ResponsiveBreakpoint.tag(450, name: 'DEFAULT'),
        const ResponsiveBreakpoint.autoScale(450),
        const ResponsiveBreakpoint.resize(450),
        const ResponsiveBreakpoint.autoScaleDown(450),
      ];
      breakpoints.sort(ResponsiveUtils.breakpointComparator);
      expect(breakpoints[0], const ResponsiveBreakpoint.autoScale(450));
      expect(breakpoints[1], const ResponsiveBreakpoint.resize(450));
      expect(breakpoints[2], const ResponsiveBreakpoint.autoScaleDown(450));
      expect(breakpoints[3], const ResponsiveBreakpoint.tag(450, name: 'DEFAULT'));
    });
    test('Sort Mixed', () {
      List<ResponsiveBreakpoint> breakpoints = [
        const ResponsiveBreakpoint.tag(0, name: 'ZERO'),
        const ResponsiveBreakpoint.autoScale(450),
        const ResponsiveBreakpoint.resize(600),
        const ResponsiveBreakpoint.autoScaleDown(800),
      ];
      // Randomize order.
      breakpoints.shuffle();
      breakpoints.sort(ResponsiveUtils.breakpointComparator);
      expect(breakpoints[0], const ResponsiveBreakpoint.tag(0, name: 'ZERO'));
      expect(breakpoints[1], const ResponsiveBreakpoint.autoScale(450));
      expect(breakpoints[2], const ResponsiveBreakpoint.resize(600));
      expect(breakpoints[3], const ResponsiveBreakpoint.autoScaleDown(800));
    });
    test('Sort Duplicates', () {
      List<ResponsiveBreakpoint> breakpoints = [
        const ResponsiveBreakpoint.autoScaleDown(450, name: '1'),
        const ResponsiveBreakpoint.autoScale(450),
        const ResponsiveBreakpoint.resize(450),
        const ResponsiveBreakpoint.autoScaleDown(450, name: '2'),
        const ResponsiveBreakpoint.tag(450, name: 'DEFAULT'),
        const ResponsiveBreakpoint.autoScaleDown(450, name: '3'),
      ];
      breakpoints.sort(ResponsiveUtils.breakpointComparator);
      // Duplicate behaviors have their orders preserved.
      expect(
          breakpoints[0], const ResponsiveBreakpoint.autoScaleDown(450, name: '1'));
      expect(breakpoints[1], const ResponsiveBreakpoint.autoScale(450));
      expect(breakpoints[2], const ResponsiveBreakpoint.resize(450));
      expect(breakpoints[5], const ResponsiveBreakpoint.tag(450, name: 'DEFAULT'));
    });
  });
}
