import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  group('Breakpoint Equality', () {
    test('ResponsiveBreakpoint', () {
      // Default breakpoint.
      expect(
          ResponsiveBreakpoint(breakpoint: 450) ==
              ResponsiveBreakpoint(breakpoint: 450),
          true);
      // Default breakpoint arguments comparison.
      expect(
          ResponsiveBreakpoint(
                  breakpoint: 450,
                  name: 'DEFAULT',
                  behavior: ResponsiveBreakpointBehavior.RESIZE,
                  scaleFactor: 1) ==
              ResponsiveBreakpoint(
                  breakpoint: 450,
                  name: 'DEFAULT',
                  behavior: ResponsiveBreakpointBehavior.RESIZE,
                  scaleFactor: 1),
          true);
      // Default empty arguments comparison.
      expect(
          ResponsiveBreakpoint(breakpoint: 450) ==
              ResponsiveBreakpoint(
                  breakpoint: 450,
                  name: null,
                  behavior: ResponsiveBreakpointBehavior.RESIZE,
                  scaleFactor: 1),
          true);
      // Resize breakpoint.
      expect(
          ResponsiveBreakpoint.resize(450) ==
              ResponsiveBreakpoint(
                  breakpoint: 450,
                  behavior: ResponsiveBreakpointBehavior.RESIZE),
          true);
      // AutoScale breakpoint.
      expect(
          ResponsiveBreakpoint.autoScale(450) ==
              ResponsiveBreakpoint(
                  breakpoint: 450,
                  behavior: ResponsiveBreakpointBehavior.AUTOSCALE),
          true);
      // AutoScaleDown breakpoint.
      expect(
          ResponsiveBreakpoint.autoScaleDown(450) ==
              ResponsiveBreakpoint(
                  breakpoint: 450,
                  behavior: ResponsiveBreakpointBehavior.AUTOSCALEDOWN),
          true);
      // Tag breakpoint.
      expect(
          ResponsiveBreakpoint.tag(450, name: 'DEFAULT') ==
              ResponsiveBreakpoint(
                  breakpoint: 450,
                  behavior: ResponsiveBreakpointBehavior.TAG,
                  name: 'DEFAULT'),
          true);
      // Unequal breakpoint.
      expect(
          ResponsiveBreakpoint(breakpoint: 450) ==
              ResponsiveBreakpoint(breakpoint: 600),
          false);
      // Unequal name.
      expect(
          ResponsiveBreakpoint(breakpoint: 450, name: 'PHONE') ==
              ResponsiveBreakpoint(breakpoint: 450, name: 'TABLET'),
          false);
      // Unequal behavior.
      expect(
          ResponsiveBreakpoint.resize(450) ==
              ResponsiveBreakpoint.autoScale(450),
          false);
      // Unequal scale factor.
      expect(
          ResponsiveBreakpoint(breakpoint: 450, scaleFactor: 1) ==
              ResponsiveBreakpoint(breakpoint: 450, scaleFactor: 2),
          false);
    });
    test('ResponsiveBreakpointSegment', () {
      // Breakpoint segment.
      expect(
          ResponsiveBreakpointSegment(
                  breakpoint: 450,
                  responsiveBreakpointBehavior:
                      ResponsiveBreakpointBehavior.RESIZE,
                  responsiveBreakpoint: ResponsiveBreakpoint.resize(450)) ==
              ResponsiveBreakpointSegment(
                  breakpoint: 450,
                  responsiveBreakpointBehavior:
                      ResponsiveBreakpointBehavior.RESIZE,
                  responsiveBreakpoint: ResponsiveBreakpoint.resize(450)),
          true);
      // Breakpoint segment 2.
      expect(
          ResponsiveBreakpointSegment(
                  breakpoint: 0,
                  responsiveBreakpointBehavior:
                      ResponsiveBreakpointBehavior.TAG,
                  responsiveBreakpoint:
                      ResponsiveBreakpoint.tag(450, name: 'DEFAULT')) ==
              ResponsiveBreakpointSegment(
                  breakpoint: 0,
                  responsiveBreakpointBehavior:
                      ResponsiveBreakpointBehavior.TAG,
                  responsiveBreakpoint:
                      ResponsiveBreakpoint.tag(450, name: 'DEFAULT')),
          true);
      // Unequal breakpoint.
      expect(
          ResponsiveBreakpointSegment(
                  breakpoint: 0,
                  responsiveBreakpointBehavior:
                      ResponsiveBreakpointBehavior.RESIZE,
                  responsiveBreakpoint: ResponsiveBreakpoint.resize(450)) ==
              ResponsiveBreakpointSegment(
                  breakpoint: 450,
                  responsiveBreakpointBehavior:
                      ResponsiveBreakpointBehavior.RESIZE,
                  responsiveBreakpoint: ResponsiveBreakpoint.resize(450)),
          false);
      // Unequal behavior.
      expect(
          ResponsiveBreakpointSegment(
                  breakpoint: 450,
                  responsiveBreakpointBehavior:
                      ResponsiveBreakpointBehavior.RESIZE,
                  responsiveBreakpoint: ResponsiveBreakpoint.resize(450)) ==
              ResponsiveBreakpointSegment(
                  breakpoint: 450,
                  responsiveBreakpointBehavior:
                      ResponsiveBreakpointBehavior.AUTOSCALE,
                  responsiveBreakpoint: ResponsiveBreakpoint.resize(450)),
          false);
      // Unequal ResponsiveBreakpoint.
      expect(
          ResponsiveBreakpointSegment(
                  breakpoint: 450,
                  responsiveBreakpointBehavior:
                      ResponsiveBreakpointBehavior.RESIZE,
                  responsiveBreakpoint: ResponsiveBreakpoint.resize(0)) ==
              ResponsiveBreakpointSegment(
                  breakpoint: 450,
                  responsiveBreakpointBehavior:
                      ResponsiveBreakpointBehavior.RESIZE,
                  responsiveBreakpoint: ResponsiveBreakpoint.resize(450)),
          false);
    });
  });
  group('GetBreakpoints', () {
    ResponsiveBreakpoint defaultBreakpoint =
        ResponsiveBreakpoint(breakpoint: 450);
    test('No Breakpoints', () {
      List<ResponsiveBreakpoint> responsiveBreakpoints = [];
      List<ResponsiveBreakpointSegment> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      expect(
          responsiveBreakpointSegments[0],
          ResponsiveBreakpointSegment(
              breakpoint: 0.0,
              responsiveBreakpointBehavior: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint: ResponsiveBreakpoint(
                  breakpoint: 450.0,
                  name: null,
                  behavior: ResponsiveBreakpointBehavior.RESIZE,
                  scaleFactor: 1.0)));
    });
  });
}
