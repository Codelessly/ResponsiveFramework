import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/utils/responsive_utils.dart';

void main() {
  group('Breakpoint Comparator', () {
    test('Sort Types', () {
      List<ResponsiveBreakpoint> breakpoints = [
        ResponsiveBreakpoint.tag(450, name: 'DEFAULT'),
        ResponsiveBreakpoint.autoScale(450),
        ResponsiveBreakpoint.resize(450),
        ResponsiveBreakpoint.autoScaleDown(450),
      ];
      // Randomize order.
      breakpoints.shuffle();
      breakpoints.sort(ResponsiveUtils.breakpointComparator);
      expect(breakpoints[0], ResponsiveBreakpoint.autoScaleDown(450));
      expect(breakpoints[1], ResponsiveBreakpoint.resize(450));
      expect(breakpoints[2], ResponsiveBreakpoint.autoScale(450));
      expect(breakpoints[3], ResponsiveBreakpoint.tag(450, name: 'DEFAULT'));
    });
    test('Sort Mixed', () {
      List<ResponsiveBreakpoint> breakpoints = [
        ResponsiveBreakpoint.tag(0, name: 'ZERO'),
        ResponsiveBreakpoint.autoScale(450),
        ResponsiveBreakpoint.resize(600),
        ResponsiveBreakpoint.autoScaleDown(800),
      ];
      // Randomize order.
      breakpoints.shuffle();
      breakpoints.sort(ResponsiveUtils.breakpointComparator);
      expect(breakpoints[0], ResponsiveBreakpoint.tag(0, name: 'ZERO'));
      expect(breakpoints[1], ResponsiveBreakpoint.autoScale(450));
      expect(breakpoints[2], ResponsiveBreakpoint.resize(600));
      expect(breakpoints[3], ResponsiveBreakpoint.autoScaleDown(800));
    });
    test('Sort Duplicates', () {
      List<ResponsiveBreakpoint> breakpoints = [
        ResponsiveBreakpoint.autoScaleDown(450, name: '1'),
        ResponsiveBreakpoint.autoScale(450),
        ResponsiveBreakpoint.resize(450),
        ResponsiveBreakpoint.autoScaleDown(450, name: '2'),
        ResponsiveBreakpoint.tag(450, name: 'DEFAULT'),
        ResponsiveBreakpoint.autoScaleDown(450, name: '3'),
      ];
      breakpoints.sort(ResponsiveUtils.breakpointComparator);
      // Duplicate behaviors have their orders preserved.
      expect(
          breakpoints[0], ResponsiveBreakpoint.autoScaleDown(450, name: '1'));
      expect(
          breakpoints[1], ResponsiveBreakpoint.autoScaleDown(450, name: '2'));
      expect(
          breakpoints[2], ResponsiveBreakpoint.autoScaleDown(450, name: '3'));
      expect(breakpoints[5], ResponsiveBreakpoint.tag(450, name: 'DEFAULT'));
    });
  });
}
