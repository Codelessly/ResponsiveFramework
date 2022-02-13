import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

void main() {
  group('Breakpoint Equality', () {
    test('ResponsiveBreakpoint Equality', () {
      // Default breakpoint.
      expect(
          const ResponsiveBreakpoint(breakpoint: 450) ==
              const ResponsiveBreakpoint(breakpoint: 450),
          true);
      // Default breakpoint arguments comparison.
      expect(
          const ResponsiveBreakpoint(
                  breakpoint: 450,
                  name: 'DEFAULT',
                  behavior: ResponsiveBreakpointBehavior.RESIZE,
                  scaleFactor: 1) ==
              const ResponsiveBreakpoint(
                  breakpoint: 450,
                  name: 'DEFAULT',
                  behavior: ResponsiveBreakpointBehavior.RESIZE,
                  scaleFactor: 1),
          true);
      // Default empty arguments comparison.
      expect(
          const ResponsiveBreakpoint(breakpoint: 450) ==
              const ResponsiveBreakpoint(
                  breakpoint: 450,
                  name: null,
                  behavior: ResponsiveBreakpointBehavior.RESIZE,
                  scaleFactor: 1),
          true);
      // Resize breakpoint.
      expect(
          const ResponsiveBreakpoint.resize(450) ==
              const ResponsiveBreakpoint(
                  breakpoint: 450,
                  behavior: ResponsiveBreakpointBehavior.RESIZE),
          true);
      // AutoScale breakpoint.
      expect(
          const ResponsiveBreakpoint.autoScale(450) ==
              const ResponsiveBreakpoint(
                  breakpoint: 450,
                  behavior: ResponsiveBreakpointBehavior.AUTOSCALE),
          true);
      // AutoScaleDown breakpoint.
      expect(
          const ResponsiveBreakpoint.autoScaleDown(450) ==
              const ResponsiveBreakpoint(
                  breakpoint: 450,
                  behavior: ResponsiveBreakpointBehavior.AUTOSCALEDOWN),
          true);
      // Tag breakpoint.
      expect(
          const ResponsiveBreakpoint.tag(450, name: 'DEFAULT') ==
              const ResponsiveBreakpoint(
                  breakpoint: 450,
                  behavior: ResponsiveBreakpointBehavior.TAG,
                  name: 'DEFAULT'),
          true);
      // Unequal breakpoint.
      expect(
          const ResponsiveBreakpoint(breakpoint: 450) ==
              const ResponsiveBreakpoint(breakpoint: 600),
          false);
      // Unequal name.
      expect(
          const ResponsiveBreakpoint(breakpoint: 450, name: 'PHONE') ==
              const ResponsiveBreakpoint(breakpoint: 450, name: 'TABLET'),
          false);
      // Unequal behavior.
      expect(
          const ResponsiveBreakpoint.resize(450) ==
              const ResponsiveBreakpoint.autoScale(450),
          false);
      // Unequal scale factor.
      expect(
          const ResponsiveBreakpoint(breakpoint: 450, scaleFactor: 1) ==
              const ResponsiveBreakpoint(breakpoint: 450, scaleFactor: 2),
          false);
    });
    test('ResponsiveBreakpointSegment Equality', () {
      // Breakpoint segment.
      expect(
          const ResponsiveBreakpointSegment(
                  breakpoint: 450,
                  segmentType: ResponsiveBreakpointBehavior.RESIZE,
                  responsiveBreakpoint: ResponsiveBreakpoint.resize(450)) ==
              const ResponsiveBreakpointSegment(
                  breakpoint: 450,
                  segmentType: ResponsiveBreakpointBehavior.RESIZE,
                  responsiveBreakpoint: ResponsiveBreakpoint.resize(450)),
          true);
      // Breakpoint segment 2.
      expect(
          const ResponsiveBreakpointSegment(
                  breakpoint: 0,
                  segmentType: ResponsiveBreakpointBehavior.TAG,
                  responsiveBreakpoint:
                      ResponsiveBreakpoint.tag(450, name: 'DEFAULT')) ==
              const ResponsiveBreakpointSegment(
                  breakpoint: 0,
                  segmentType: ResponsiveBreakpointBehavior.TAG,
                  responsiveBreakpoint:
                      ResponsiveBreakpoint.tag(450, name: 'DEFAULT')),
          true);
      // Unequal breakpoint.
      expect(
          const ResponsiveBreakpointSegment(
                  breakpoint: 0,
                  segmentType: ResponsiveBreakpointBehavior.RESIZE,
                  responsiveBreakpoint: ResponsiveBreakpoint.resize(450)) ==
              const ResponsiveBreakpointSegment(
                  breakpoint: 450,
                  segmentType: ResponsiveBreakpointBehavior.RESIZE,
                  responsiveBreakpoint: ResponsiveBreakpoint.resize(450)),
          false);
      // Unequal behavior.
      expect(
          const ResponsiveBreakpointSegment(
                  breakpoint: 450,
                  segmentType: ResponsiveBreakpointBehavior.RESIZE,
                  responsiveBreakpoint: ResponsiveBreakpoint.resize(450)) ==
              const ResponsiveBreakpointSegment(
                  breakpoint: 450,
                  segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
                  responsiveBreakpoint: ResponsiveBreakpoint.resize(450)),
          false);
      // Unequal ResponsiveBreakpoint.
      expect(
          const ResponsiveBreakpointSegment(
                  breakpoint: 450,
                  segmentType: ResponsiveBreakpointBehavior.RESIZE,
                  responsiveBreakpoint: ResponsiveBreakpoint.resize(0)) ==
              const ResponsiveBreakpointSegment(
                  breakpoint: 450,
                  segmentType: ResponsiveBreakpointBehavior.RESIZE,
                  responsiveBreakpoint: ResponsiveBreakpoint.resize(450)),
          false);
    });
  });
  group('Breakpoint Merge', () {
    test('ResponsiveBreakpoint Merge', () {
      // Merge different breakpoints. Merged breakpoint
      // overwrites original breakpoint.
      ResponsiveBreakpoint responsiveBreakpoint1 =
          const ResponsiveBreakpoint.resize(320);
      ResponsiveBreakpoint responsiveBreakpoint2 =
          const ResponsiveBreakpoint.resize(400);
      expect(responsiveBreakpoint1.merge(responsiveBreakpoint2),
          responsiveBreakpoint2);
      // Merge different breakpoint behaviors.
      // Merged breakpoint overwrites original behavior.
      responsiveBreakpoint2 = const ResponsiveBreakpoint.autoScale(320);
      expect(responsiveBreakpoint1.merge(responsiveBreakpoint2),
          responsiveBreakpoint2);
      // Merge optional parameters.
      responsiveBreakpoint2 =
          const ResponsiveBreakpoint.resize(320, name: 'PHONE', scaleFactor: 1.5);
      expect(responsiveBreakpoint1.merge(responsiveBreakpoint2),
          responsiveBreakpoint2);
      // Merge empty name preserves existing name.
      // Merge overwrites scaleFactor.
      responsiveBreakpoint1 = const ResponsiveBreakpoint.resize(320);
      responsiveBreakpoint2 =
          const ResponsiveBreakpoint.resize(320, name: 'PHONE', scaleFactor: 1.5);
      expect(responsiveBreakpoint2.merge(responsiveBreakpoint1),
          const ResponsiveBreakpoint.resize(320, name: 'PHONE', scaleFactor: 1.0));
      // Merge non-empty name overwrites name
      responsiveBreakpoint1 = const ResponsiveBreakpoint.resize(320, name: 'DEFAULT');
      responsiveBreakpoint2 = const ResponsiveBreakpoint.resize(320, name: 'PHONE');
      expect(responsiveBreakpoint1.merge(responsiveBreakpoint2),
          const ResponsiveBreakpoint.resize(320, name: 'PHONE'));
      // Merge tag appends tag name.
      responsiveBreakpoint1 = const ResponsiveBreakpoint.resize(320, name: 'DEFAULT');
      responsiveBreakpoint2 = const ResponsiveBreakpoint.tag(320, name: 'PHONE');
      expect(responsiveBreakpoint1.merge(responsiveBreakpoint2),
          const ResponsiveBreakpoint.resize(320, name: 'PHONE'));
    });
    test('ResponsiveBreakpointSegment Merge', () {
      // Merge different segments. Merged segment
      // overwrites original segment.
      ResponsiveBreakpointSegment responsiveBreakpointSegment1 =
          const ResponsiveBreakpointSegment(
              breakpoint: 320,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint: ResponsiveBreakpoint.resize(320));
      ResponsiveBreakpointSegment responsiveBreakpointSegment2 =
          const ResponsiveBreakpointSegment(
              breakpoint: 400,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint: ResponsiveBreakpoint.resize(400));
      expect(responsiveBreakpointSegment1.merge(responsiveBreakpointSegment2),
          responsiveBreakpointSegment2);
      // Merge different segment types. Merged segment
      // overwrites existing type.
      responsiveBreakpointSegment2 = const ResponsiveBreakpointSegment(
          breakpoint: 320,
          segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
          responsiveBreakpoint: ResponsiveBreakpoint.autoScale(400));
      expect(responsiveBreakpointSegment1.merge(responsiveBreakpointSegment2),
          responsiveBreakpointSegment2);
      // Merge non-tag segment and tag. Tag does not overwrite
      // existing segment except for the name.
      responsiveBreakpointSegment2 = const ResponsiveBreakpointSegment(
          breakpoint: 320,
          segmentType: ResponsiveBreakpointBehavior.TAG,
          responsiveBreakpoint: ResponsiveBreakpoint.tag(320, name: 'PHONE'));
      expect(
          responsiveBreakpointSegment1.merge(responsiveBreakpointSegment2),
          const ResponsiveBreakpointSegment(
              breakpoint: 320,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.resize(320, name: 'PHONE')));
      // Merge non-tag segment with name and tag.
      // Tag overwrites only existing name.
      responsiveBreakpointSegment1 = const ResponsiveBreakpointSegment(
          breakpoint: 320,
          segmentType: ResponsiveBreakpointBehavior.RESIZE,
          responsiveBreakpoint: ResponsiveBreakpoint.resize(320,
              name: 'DEFAULT', scaleFactor: 1.5));
      responsiveBreakpointSegment2 = const ResponsiveBreakpointSegment(
          breakpoint: 320,
          segmentType: ResponsiveBreakpointBehavior.TAG,
          responsiveBreakpoint: ResponsiveBreakpoint.tag(320, name: 'PHONE'));
      expect(
          responsiveBreakpointSegment1.merge(responsiveBreakpointSegment2),
          const ResponsiveBreakpointSegment(
              breakpoint: 320,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint: ResponsiveBreakpoint.resize(320,
                  name: 'PHONE', scaleFactor: 1.5)));
      // Merge two tags. Overwrite existing tag.
      responsiveBreakpointSegment1 = const ResponsiveBreakpointSegment(
          breakpoint: 320,
          segmentType: ResponsiveBreakpointBehavior.TAG,
          responsiveBreakpoint: ResponsiveBreakpoint.tag(320, name: 'DEFAULT'));
      responsiveBreakpointSegment2 = const ResponsiveBreakpointSegment(
          breakpoint: 320,
          segmentType: ResponsiveBreakpointBehavior.TAG,
          responsiveBreakpoint:
              ResponsiveBreakpoint.resize(320, name: 'PHONE'));
      expect(responsiveBreakpointSegment1.merge(responsiveBreakpointSegment2),
          responsiveBreakpointSegment2);
    });
  });
  group('GetBreakpoints', () {
    ResponsiveBreakpoint defaultBreakpoint =
        const ResponsiveBreakpoint(breakpoint: 450);
    test('No Breakpoints', () {
      List<ResponsiveBreakpoint> responsiveBreakpoints = [];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // Breakpoint segment always starts from 0.
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0.0,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint: ResponsiveBreakpoint(
                  breakpoint: 450.0,
                  name: null,
                  behavior: ResponsiveBreakpointBehavior.RESIZE,
                  scaleFactor: 1.0)));
    });
    test('Default Breakpoint', () {
      List<ResponsiveBreakpoint> responsiveBreakpoints = [
        const ResponsiveBreakpoint.autoScale(450)
      ];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // Breakpoint segment starts at 0. Inherits behavior from default breakpoint.
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint: ResponsiveBreakpoint.resize(450)));
      // Second segment returns breakpoint behavior.
      expect(
          responsiveBreakpointSegments[1],
          const ResponsiveBreakpointSegment(
              breakpoint: 450,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(450)));
    });
    test('Default Breakpoint AutoScale', () {
      ResponsiveBreakpoint defaultBreakpoint =
          const ResponsiveBreakpoint.autoScale(450);
      List<ResponsiveBreakpoint> responsiveBreakpoints = [
        const ResponsiveBreakpoint.resize(600)
      ];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // AutoScale breakpoint segment from 450 - 0.
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(450)));
      // AutoScale breakpoint from default 450 - 600.
      expect(
          responsiveBreakpointSegments[1],
          const ResponsiveBreakpointSegment(
              breakpoint: 450,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(450)));
      // Resize breakpoint from 600 - ∞.
      expect(
          responsiveBreakpointSegments[2],
          const ResponsiveBreakpointSegment(
              breakpoint: 600,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint: ResponsiveBreakpoint.resize(600)));
    });
    test('AutoScaleDown Smaller Than Default', () {
      ResponsiveBreakpoint defaultBreakpoint =
          const ResponsiveBreakpoint.autoScale(450);
      List<ResponsiveBreakpoint> responsiveBreakpoints = [
        const ResponsiveBreakpoint.autoScaleDown(320)
      ];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // AutoScaleDown is the first breakpoint so the
      // behavior becomes AutoScale.
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(320)));
      expect(
          responsiveBreakpointSegments[1],
          const ResponsiveBreakpointSegment(
              breakpoint: 320,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALEDOWN,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(320)));
      expect(
          responsiveBreakpointSegments[2],
          const ResponsiveBreakpointSegment(
              breakpoint: 450,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(450)));
    });
    test('AutoScaleDown Equal To Default', () {
      ResponsiveBreakpoint defaultBreakpoint =
          const ResponsiveBreakpoint.autoScale(450);
      List<ResponsiveBreakpoint> responsiveBreakpoints = [
        const ResponsiveBreakpoint.autoScaleDown(450)
      ];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // AutoScaleDown is the first breakpoint so the
      // behavior is converted to AutoScale.
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(450)));
      // Initial AutoScaleDown segment.
      expect(
          responsiveBreakpointSegments[1],
          const ResponsiveBreakpointSegment(
              breakpoint: 450,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALEDOWN,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(450)));
    });
    test('AutoScaleDown Larger Than Default', () {
      ResponsiveBreakpoint defaultBreakpoint =
          const ResponsiveBreakpoint.autoScale(450);
      List<ResponsiveBreakpoint> responsiveBreakpoints = [
        const ResponsiveBreakpoint.autoScaleDown(600)
      ];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // Initial segment with AutoScale behavior.
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(450)));
      // Override AutoScale with AutoScaleDown breakpoint value.
      expect(
          responsiveBreakpointSegments[1],
          const ResponsiveBreakpointSegment(
              breakpoint: 450,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(600)));
      // AutoScale behavior from 600 -  ∞.
      expect(
          responsiveBreakpointSegments[2],
          const ResponsiveBreakpointSegment(
              breakpoint: 600,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALEDOWN,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(600)));
    });
    test('AutoScaleDown Resize', () {
      ResponsiveBreakpoint defaultBreakpoint = const ResponsiveBreakpoint.resize(450);
      List<ResponsiveBreakpoint> responsiveBreakpoints = [
        const ResponsiveBreakpoint.autoScaleDown(600)
      ];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // Initial segment with default Resize behavior.
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint: ResponsiveBreakpoint.resize(450)));
      // AutoScaleDown overwrites Resize behavior.
      // AutoScale down from 600.
      expect(
          responsiveBreakpointSegments[1],
          const ResponsiveBreakpointSegment(
              breakpoint: 450,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(600)));
      // AutoScale from 600 - ∞.
      expect(
          responsiveBreakpointSegments[2],
          const ResponsiveBreakpointSegment(
              breakpoint: 600,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALEDOWN,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(600)));
    });
    test('AutoScaleDown AutoScale', () {
      ResponsiveBreakpoint defaultBreakpoint =
          const ResponsiveBreakpoint.autoScale(450);
      List<ResponsiveBreakpoint> responsiveBreakpoints = [
        const ResponsiveBreakpoint.autoScaleDown(320),
        const ResponsiveBreakpoint.autoScaleDown(600),
      ];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // Initial segment with converted AutoScale behavior.
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(320)));
      // AutoScaleDown breakpoint.
      expect(
          responsiveBreakpointSegments[1],
          const ResponsiveBreakpointSegment(
              breakpoint: 320,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALEDOWN,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(320)));
      // AutoScaleDown from 600.
      expect(
          responsiveBreakpointSegments[2],
          const ResponsiveBreakpointSegment(
              breakpoint: 450,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(600)));
      // AutoScale from 600 - ∞.
      expect(
          responsiveBreakpointSegments[3],
          const ResponsiveBreakpointSegment(
              breakpoint: 600,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALEDOWN,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(600)));
    });
    test('AutoScaleDown AutoScale Override', () {
      // This test also test correct merge count because the
      // first breakpoint is merged with the default breakpoint.
      ResponsiveBreakpoint defaultBreakpoint =
          const ResponsiveBreakpoint.autoScale(450);
      List<ResponsiveBreakpoint> responsiveBreakpoints = [
        const ResponsiveBreakpoint.autoScale(450),
        const ResponsiveBreakpoint.autoScaleDown(450),
      ];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // Initial segment with converted AutoScale behavior.
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(450)));
      // AutoScaleDown segment.
      expect(
          responsiveBreakpointSegments[1],
          const ResponsiveBreakpointSegment(
              breakpoint: 450,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALEDOWN,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(450)));
    });
    test('AutoScaleDown Complex', () {
      ResponsiveBreakpoint defaultBreakpoint = const ResponsiveBreakpoint.resize(450);
      List<ResponsiveBreakpoint> responsiveBreakpoints = [
        const ResponsiveBreakpoint.autoScaleDown(360),
        const ResponsiveBreakpoint.tag(380, name: 'MOBILE'),
        const ResponsiveBreakpoint.autoScaleDown(400),
        const ResponsiveBreakpoint.autoScale(420),
        const ResponsiveBreakpoint.tag(430, name: 'DEFAULT'),
        const ResponsiveBreakpoint.tag(440, name: 'PHONE'),
        const ResponsiveBreakpoint.autoScaleDown(450),
      ];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(360)));
      expect(
          responsiveBreakpointSegments[1],
          const ResponsiveBreakpointSegment(
              breakpoint: 360,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALEDOWN,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(400)));
      expect(
          responsiveBreakpointSegments[2],
          const ResponsiveBreakpointSegment(
              breakpoint: 380,
              segmentType: ResponsiveBreakpointBehavior.TAG,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.autoScale(400, name: 'MOBILE')));
      expect(
          responsiveBreakpointSegments[3],
          const ResponsiveBreakpointSegment(
              breakpoint: 400,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALEDOWN,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(400)));
      expect(
          responsiveBreakpointSegments[4],
          const ResponsiveBreakpointSegment(
              breakpoint: 420,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(450)));
      expect(
          responsiveBreakpointSegments[5],
          const ResponsiveBreakpointSegment(
              breakpoint: 430,
              segmentType: ResponsiveBreakpointBehavior.TAG,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.autoScale(450, name: 'DEFAULT')));
      expect(
          responsiveBreakpointSegments[6],
          const ResponsiveBreakpointSegment(
              breakpoint: 440.0,
              segmentType: ResponsiveBreakpointBehavior.TAG,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.autoScale(450, name: 'PHONE')));
      expect(
          responsiveBreakpointSegments[7],
          const ResponsiveBreakpointSegment(
              breakpoint: 450,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALEDOWN,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(450)));
      expect(responsiveBreakpointSegments.length, 8);
    });
    test('AutoScaleDown AutoScaleDown', () {
      ResponsiveBreakpoint defaultBreakpoint = const ResponsiveBreakpoint.resize(600);
      List<ResponsiveBreakpoint> responsiveBreakpoints = [
        const ResponsiveBreakpoint.autoScaleDown(320),
        const ResponsiveBreakpoint.autoScaleDown(360),
        const ResponsiveBreakpoint.autoScaleDown(400),
        const ResponsiveBreakpoint.autoScaleDown(480),
      ];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // Initial AutoScaleDown segment.
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(320)));
      // AutoScaleDown from next breakpoint.
      expect(
          responsiveBreakpointSegments[1],
          const ResponsiveBreakpointSegment(
              breakpoint: 320,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALEDOWN,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(360)));
      // AutoScaleDown from next breakpoint.
      expect(
          responsiveBreakpointSegments[2],
          const ResponsiveBreakpointSegment(
              breakpoint: 360,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALEDOWN,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(400)));
      // AutoScaleDown from next breakpoint.
      expect(
          responsiveBreakpointSegments[3],
          const ResponsiveBreakpointSegment(
              breakpoint: 400,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALEDOWN,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(480)));
      // AutoScale up to next Resize breakpoint.
      expect(
          responsiveBreakpointSegments[4],
          const ResponsiveBreakpointSegment(
              breakpoint: 480,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALEDOWN,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(480)));
    });
  });
  group('MinWidth', () {
    ResponsiveBreakpoint defaultBreakpoint =
        const ResponsiveBreakpoint.autoScale(450);
    test('No Breakpoints', () {
      List<ResponsiveBreakpoint> responsiveBreakpoints = [];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // Initial segment from 0 - ∞
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(450)));
    });
    test('Breakpoint Smaller', () {
      List<ResponsiveBreakpoint> responsiveBreakpoints = [
        const ResponsiveBreakpoint.tag(320, name: 'DEFAULT'),
      ];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // Initial segment from 0 - 320.
      // Inherits default behavior from 450.
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(450)));
      // Tag segment from 320 - 450.
      // Default behavior with name appended.
      expect(
          responsiveBreakpointSegments[1],
          const ResponsiveBreakpointSegment(
              breakpoint: 320,
              segmentType: ResponsiveBreakpointBehavior.TAG,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.autoScale(450, name: 'DEFAULT')));
      // MinWidth segment from 450 - ∞.
      expect(
          responsiveBreakpointSegments[2],
          const ResponsiveBreakpointSegment(
              breakpoint: 450,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(450)));
    });
    test('Breakpoint Larger', () {
      List<ResponsiveBreakpoint> responsiveBreakpoints = [
        const ResponsiveBreakpoint.tag(600, name: 'DEFAULT'),
      ];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // Initial segment from 0 - 450.
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(450)));
      // MinWidth segment from 450 - 600.
      expect(
          responsiveBreakpointSegments[1],
          const ResponsiveBreakpointSegment(
              breakpoint: 450,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(450)));
      // Tag segment from 600 - ∞.
      // Inherits behavior from MinWidth.
      expect(
          responsiveBreakpointSegments[2],
          const ResponsiveBreakpointSegment(
              breakpoint: 600,
              segmentType: ResponsiveBreakpointBehavior.TAG,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.autoScale(450, name: 'DEFAULT')));
    });
    test('Two Smaller Breakpoints', () {
      List<ResponsiveBreakpoint> responsiveBreakpoints = [
        const ResponsiveBreakpoint.resize(320, name: 'DEFAULT'),
        const ResponsiveBreakpoint.tag(360, name: 'PHONE'),
      ];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // Initial segment from 0 - 320.
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint: ResponsiveBreakpoint.autoScale(320)));
      // Segment from 320 - 360.
      expect(
          responsiveBreakpointSegments[1],
          const ResponsiveBreakpointSegment(
              breakpoint: 320,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.resize(320, name: 'DEFAULT')));
      // Tag segment from 360 - 420.
      // Inherits previous breakpoint behavior.
      expect(
          responsiveBreakpointSegments[2],
          const ResponsiveBreakpointSegment(
              breakpoint: 360,
              segmentType: ResponsiveBreakpointBehavior.TAG,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.resize(320, name: 'PHONE')));
    });
  });
  group('Tag', () {
    ResponsiveBreakpoint defaultBreakpoint =
        const ResponsiveBreakpoint(breakpoint: 450);
    test('Tags Simple', () {
      List<ResponsiveBreakpoint> responsiveBreakpoints = [
        const ResponsiveBreakpoint.tag(0, name: 'ZERO'),
        const ResponsiveBreakpoint.tag(450, name: 'DEFAULT'),
        const ResponsiveBreakpoint.tag(450, name: 'PHONE'),
        const ResponsiveBreakpoint.tag(800, name: 'TABLET'),
        const ResponsiveBreakpoint.tag(1200, name: 'DESKTOP'),
      ];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // Tag is appended to initial breakpoint.
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.resize(450, name: 'ZERO')));
      // Last tag is appended to default breakpoint.
      expect(
          responsiveBreakpointSegments[1],
          const ResponsiveBreakpointSegment(
              breakpoint: 450,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.resize(450, name: 'PHONE')));
      // Tag segment with inherited Resize behavior.
      expect(
          responsiveBreakpointSegments[2],
          const ResponsiveBreakpointSegment(
              breakpoint: 800,
              segmentType: ResponsiveBreakpointBehavior.TAG,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.resize(450, name: 'TABLET')));
    });
    test('Tags Resize', () {
      defaultBreakpoint = const ResponsiveBreakpoint.resize(450);
      List<ResponsiveBreakpoint> responsiveBreakpoints = [
        const ResponsiveBreakpoint.tag(0, name: 'ZERO'),
        const ResponsiveBreakpoint.tag(320, name: 'PHONE'),
        const ResponsiveBreakpoint.tag(450, name: 'DEFAULT'),
        const ResponsiveBreakpoint.tag(600, name: 'TABLET'),
      ];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // Initial segment with Resize behavior and tag appended.
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.resize(450, name: 'ZERO')));
      // Inbetween tag segment.
      expect(
          responsiveBreakpointSegments[1],
          const ResponsiveBreakpointSegment(
              breakpoint: 320,
              segmentType: ResponsiveBreakpointBehavior.TAG,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.resize(450, name: 'PHONE')));
      // MinWidth breakpoint with tag appended
      expect(
          responsiveBreakpointSegments[2],
          const ResponsiveBreakpointSegment(
              breakpoint: 450,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.resize(450, name: 'DEFAULT')));
      // Tag segment from 600 - ∞.
      // Inherits behavior from MinWidth.
      expect(
          responsiveBreakpointSegments[3],
          const ResponsiveBreakpointSegment(
              breakpoint: 600,
              segmentType: ResponsiveBreakpointBehavior.TAG,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.resize(450, name: 'TABLET')));
    });
    test('Tags AutoScale', () {
      defaultBreakpoint = const ResponsiveBreakpoint.autoScale(450);
      List<ResponsiveBreakpoint> responsiveBreakpoints = [
        const ResponsiveBreakpoint.tag(0, name: 'ZERO'),
        const ResponsiveBreakpoint.tag(320, name: 'PHONE'),
        const ResponsiveBreakpoint.tag(450, name: 'DEFAULT'),
        const ResponsiveBreakpoint.tag(600, name: 'TABLET'),
      ];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // Initial segment with AutoScale behavior and tag appended.
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.autoScale(450, name: 'ZERO')));
      // Inbetween tag segment.
      expect(
          responsiveBreakpointSegments[1],
          const ResponsiveBreakpointSegment(
              breakpoint: 320,
              segmentType: ResponsiveBreakpointBehavior.TAG,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.autoScale(450, name: 'PHONE')));
      // MinWidth breakpoint with tag appended
      expect(
          responsiveBreakpointSegments[2],
          const ResponsiveBreakpointSegment(
              breakpoint: 450,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALE,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.autoScale(450, name: 'DEFAULT')));
      // Tag segment from 600 - ∞.
      // Inherits behavior from MinWidth.
      expect(
          responsiveBreakpointSegments[3],
          const ResponsiveBreakpointSegment(
              breakpoint: 600,
              segmentType: ResponsiveBreakpointBehavior.TAG,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.autoScale(450, name: 'TABLET')));
    });
    test('Tags AutoScaleDown', () {
      defaultBreakpoint = const ResponsiveBreakpoint.resize(320);
      List<ResponsiveBreakpoint> responsiveBreakpoints = [
        const ResponsiveBreakpoint.tag(0, name: 'ZERO'),
        const ResponsiveBreakpoint.tag(320, name: 'PHONE'),
        const ResponsiveBreakpoint.tag(450, name: 'DEFAULT'),
        const ResponsiveBreakpoint.autoScaleDown(450),
        const ResponsiveBreakpoint.tag(600, name: 'TABLET'),
      ];
      List<ResponsiveBreakpointSegment?> responsiveBreakpointSegments =
          getBreakpointSegments(responsiveBreakpoints, defaultBreakpoint);
      // Initial AutoScaleDown segment with behavior
      // converted to AutoScale.
      expect(
          responsiveBreakpointSegments[0],
          const ResponsiveBreakpointSegment(
              breakpoint: 0,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.resize(320, name: 'ZERO')));
      // Inbetween tag segment.
      expect(
          responsiveBreakpointSegments[1],
          const ResponsiveBreakpointSegment(
              breakpoint: 320,
              segmentType: ResponsiveBreakpointBehavior.RESIZE,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.autoScale(450, name: 'PHONE')));
      // MinWidth breakpoint with tag appended
      expect(
          responsiveBreakpointSegments[2],
          const ResponsiveBreakpointSegment(
              breakpoint: 450,
              segmentType: ResponsiveBreakpointBehavior.AUTOSCALEDOWN,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.autoScale(450, name: 'DEFAULT')));
      // Tag segment from 600 - ∞.
      // Inherits behavior from MinWidth.
      expect(
          responsiveBreakpointSegments[3],
          const ResponsiveBreakpointSegment(
              breakpoint: 600,
              segmentType: ResponsiveBreakpointBehavior.TAG,
              responsiveBreakpoint:
                  ResponsiveBreakpoint.autoScale(450, name: 'TABLET')));
    });
  });
}
