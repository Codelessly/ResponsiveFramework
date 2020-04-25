// Test Breakpoint and MaxWidth collision.
// ResponsiveBreakpoint(breakpoint: 1200, scaleFactor: 2)
// maxWidth: 1200
// Expected Result: UI Scales 2x at 1200.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'test_utils.dart';

void main() {
  group('ResponsiveWrapper', () {
    /// Verify empty widget does nothing.
    testWidgets('Empty', (WidgetTester tester) async {
      setScreenSize(tester, Size(450, 1200));
      Key key = Key('Test');
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          child: Container(),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      ResponsiveWrapper responsiveWrapper = tester.widget(find.byKey(key));
      // Confirm defaults.
      expect(responsiveWrapper.breakpoints, null);
      expect(responsiveWrapper.background, null);
      expect(responsiveWrapper.minWidth, 450);
      expect(responsiveWrapper.maxWidth, null);
      expect(responsiveWrapper.defaultName, null);
      expect(responsiveWrapper.defaultScale, false);
      expect(responsiveWrapper.defaultScaleFactor, 1);
      expect(responsiveWrapper.mediaQueryData, null);
      // Verify dimensions unchanged.
      MediaQuery mediaQueryData = tester.widget(find.descendant(
          of: find.byKey(key), matching: find.byType(MediaQuery)));
      expect(mediaQueryData.data.size, Size(450, 1200));
    });
  });

  test('ResponsiveBreakpoint', () {
    // Test empty breakpoint.
    ResponsiveBreakpoint responsiveBreakpoint =
        ResponsiveBreakpoint(breakpoint: null);
    // Test print empty.
    print(responsiveBreakpoint);
    expect(responsiveBreakpoint.breakpoint, null);
    expect(responsiveBreakpoint.autoScale, false);
    expect(responsiveBreakpoint.scaleFactor, 1);
    expect(responsiveBreakpoint.name, null);

    // Test setting parameters types.
    responsiveBreakpoint = ResponsiveBreakpoint(
        breakpoint: 600, name: MOBILE, autoScale: true, scaleFactor: 1.2);
    // Test print parameters.
    print(responsiveBreakpoint);
  });
}
