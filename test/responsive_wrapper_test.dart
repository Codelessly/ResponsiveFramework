import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'test_utils.dart';

void main() {
  group('ResponsiveWrapper', () {
    // Verify empty widget does nothing.
    testWidgets('Empty', (WidgetTester tester) async {
      setScreenSize(tester, Size(450, 1200));
      Key key = UniqueKey();
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          child: Container(),
          shrinkWrap: false,
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
      MediaQuery mediaQuery = tester.widget(find.descendant(
          of: find.byKey(key), matching: find.byType(MediaQuery)));
      expect(mediaQuery.data.size, Size(450, 1200));
    });

    // Verify empty wrapper does nothing.
    testWidgets('Empty', (WidgetTester tester) async {
      setScreenSize(tester, Size(450, 1200));
      Key key = UniqueKey();
      Widget widget = MaterialApp(
        builder: (context, widget) => ResponsiveWrapper.builder(
          widget,
        ),
        home: Container(),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      ResponsiveWrapper responsiveWrapper =
          tester.widget(find.byType(ResponsiveWrapper));
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
      MediaQuery mediaQuery = tester.widget(find.descendant(
          of: find.byType(ResponsiveWrapper),
          matching: find.byType(MediaQuery)));
      expect(mediaQuery.data.size, Size(450, 1200));
    });

    // Verify initialization returns [SizedBox.shrink].
    testWidgets('Initialization', (WidgetTester tester) async {
      setScreenSize(tester, Size(450, 1200));
      // No breakpoints.
      Key key = UniqueKey();
      String defaultName = 'defaultName';
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          breakpoints: [
            ResponsiveBreakpoint(
                breakpoint: 450, name: MOBILE, autoScale: true),
          ],
          child: Container(color: Colors.white),
          shrinkWrap: false,
        ),
      );
      await tester.pumpWidget(widget);
      // Initialization is empty and returns SizedBox widget.
      expect(
          find.descendant(of: find.byKey(key), matching: find.byType(SizedBox)),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.byKey(key), matching: find.byType(Container)),
          findsNothing);
      await tester.pump();
      // Container is created on first frame.
      expect(
          find.descendant(
              of: find.byKey(key), matching: find.byType(Container).first),
          findsOneWidget);
    });

    // Verify default name settings.
    testWidgets('Default Name', (WidgetTester tester) async {
      setScreenSize(tester, Size(450, 1200));
      // No breakpoints.
      Key key = UniqueKey();
      String defaultName = 'defaultName';
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultName: defaultName,
          child: Container(),
          shrinkWrap: false,
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      expect(state.activeBreakpoint?.name, defaultName);

      // Single breakpoint.
      List<double> boundaryValues = [
        449,
        450,
        451,
      ];
      List<dynamic> expectedValues = [defaultName, null, null];

      for (var i = 0; i < boundaryValues.length; i++) {
        resetScreenSize(tester);
        setScreenSize(tester, Size(boundaryValues[i], 1200));
        await tester.pump();
        key = UniqueKey();
        widget = MaterialApp(
          home: ResponsiveWrapper(
            key: key,
            defaultName: defaultName,
            breakpoints: [
              ResponsiveBreakpoint(breakpoint: 450, autoScale: false),
            ],
            child: Container(),
            shrinkWrap: false,
          ),
        );
        await tester.pumpWidget(widget);
        await tester.pump();
        state = tester.state(find.byKey(key));
        expect(state.activeBreakpoint?.name, expectedValues[i]);
      }

      // Multiple breakpoints.
      boundaryValues = [449, 450, 451, 500, 600, 601];
      expectedValues = [defaultName, MOBILE, MOBILE, null, TABLET, TABLET];
      for (var i = 0; i < boundaryValues.length; i++) {
        resetScreenSize(tester);
        setScreenSize(tester, Size(boundaryValues[i], 1200));
        await tester.pump();
        key = UniqueKey();
        widget = MaterialApp(
          home: ResponsiveWrapper(
            key: key,
            defaultName: defaultName,
            breakpoints: [
              ResponsiveBreakpoint(
                  breakpoint: 450, name: MOBILE, autoScale: false),
              ResponsiveBreakpoint(breakpoint: 500, autoScale: false),
              ResponsiveBreakpoint(
                  breakpoint: 600, name: TABLET, autoScale: false),
            ],
            child: Container(),
            shrinkWrap: false,
          ),
        );
        await tester.pumpWidget(widget);
        await tester.pump();
        state = tester.state(find.byKey(key));
        expect(state.activeBreakpoint?.name, expectedValues[i]);
      }
    });

    // Verify inherited mediaQueryData is used.
    testWidgets('MediaQueryData Inherited', (WidgetTester tester) async {
      setScreenSize(tester, Size(450, 1200));
      Key key = UniqueKey();
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          mediaQueryData:
              MediaQueryData(size: Size(600, 1200), devicePixelRatio: 3),
          child: Container(),
          shrinkWrap: false,
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      MediaQuery mediaQuery = tester.widget(find.descendant(
          of: find.byKey(key), matching: find.byType(MediaQuery)));
      expect(mediaQuery.data.size, Size(600, 1200));

      // Pass MediaQueryData through builder.
      key = UniqueKey();
      widget = MaterialApp(
        builder: (context, widget) => ResponsiveWrapper.builder(widget,
            mediaQueryData:
                MediaQueryData(size: Size(600, 1200), devicePixelRatio: 3)),
        home: Container(),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      expect(
          find
              .byType(MediaQuery)
              .allCandidates
              .firstWhere((element) => element.size == Size(600, 1200)),
          isNotNull);
    });

    // Test maxWidth and minWidth values.
    testWidgets('Max and Min Width', (WidgetTester tester) async {
      // 0 value.
      setScreenSize(tester, Size(450, 1200));
      Key key = UniqueKey();
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultScale: true,
          maxWidth: 0,
          minWidth: 0,
          child: Container(),
          shrinkWrap: false,
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      // Fallback to SizedBox.
      expect(find.byType(SizedBox), findsOneWidget);

      // Infinity value. (BoxConstraints forbid forcing double.infinity)
      key = UniqueKey();
      widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultScale: true,
          maxWidth: 1073741823,
          minWidth: 1073741823,
          child: Container(),
          shrinkWrap: false,
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();

      // maxWidth smaller than minWidth.
      // When defaultScale is false, minWidth is ignored.
      // If defaultScale is true, minWidth acts as a
      // scaleFactor multiplier when greater than maxWidth.
      key = UniqueKey();
      widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultScale: true,
          maxWidth: 200,
          minWidth: 800,
          child: Container(),
          shrinkWrap: false,
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      // Screen width is capped at maxWidth value.
      // Scale factor is 4.
      expect(state.screenWidth, 200);
    });
  });

  group('ResponsiveBreakpoint', () {
    // Test ResponsiveBreakpoint class parameters.
    test('Parameters', () {
      // Test empty breakpoint.
      ResponsiveBreakpoint responsiveBreakpoint =
          ResponsiveBreakpoint(breakpoint: null, autoScale: false);
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

    // Test duplicate breakpoints.
    testWidgets('Breakpoint Duplicate', (WidgetTester tester) async {
      setScreenSize(tester, Size(450, 1200));
      Key key = UniqueKey();
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint(breakpoint: 600, autoScale: false),
            ResponsiveBreakpoint(breakpoint: 450, autoScale: false),
            ResponsiveBreakpoint(breakpoint: 450, autoScale: false),
            ResponsiveBreakpoint(breakpoint: 450, autoScale: false),
            ResponsiveBreakpoint(breakpoint: 450, autoScale: false),
            ResponsiveBreakpoint(breakpoint: 450, autoScale: false),
            ResponsiveBreakpoint(breakpoint: 450, autoScale: false),
          ],
          child: Container(),
          shrinkWrap: false,
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      expect(state.activeBreakpoint?.breakpoint, 450);

      resetScreenSize(tester);
      setScreenSize(tester, Size(600, 1200));
      await tester.pump();
      state = tester.state(find.byKey(key));
      expect(state.activeBreakpoint?.breakpoint, 600);

      // Test duplicate named breakpoints.
      resetScreenSize(tester);
      setScreenSize(tester, Size(450, 1200));
      await tester.pump();
      key = UniqueKey();
      widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint(
                breakpoint: 600, name: TABLET, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 450, name: MOBILE, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 450, name: MOBILE, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 450, name: MOBILE, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 450, name: MOBILE, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 450, name: MOBILE, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 450, name: MOBILE, autoScale: false),
          ],
          child: Container(),
          shrinkWrap: false,
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      state = tester.state(find.byKey(key));
      expect(state.activeBreakpoint?.name, MOBILE);

      resetScreenSize(tester);
      setScreenSize(tester, Size(600, 1200));
      await tester.pump();
      state = tester.state(find.byKey(key));
      expect(state.activeBreakpoint?.name, TABLET);
    });

    // Test breakpoint bounds (0, infinity)
    testWidgets('Breakpoint Bounds', (WidgetTester tester) async {
      setScreenSize(tester, Size(450, 1200));
      Key key = UniqueKey();
      String defaultName = 'defaultName';
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultName: defaultName,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint(breakpoint: 0, name: '0', autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 1073741823, name: 'Infinity', autoScale: false),
          ],
          child: Container(),
          shrinkWrap: false,
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      expect(state.activeBreakpoint?.name, '0');
      // Negative breakpoints are not allowed.
    });

    // Test unnamed breakpoints.
    testWidgets('Breakpoints Unnamed', (WidgetTester tester) async {
      List<double> boundaryValues = [
        449,
        450,
        451,
        599,
        600,
        601,
        799,
        800,
        801,
      ];
      List<dynamic> expectedValues = [
        null,
        450,
        450,
        450,
        600,
        600,
        600,
        800,
        800,
      ];

      for (var i = 0; i < boundaryValues.length; i++) {
        resetScreenSize(tester);
        setScreenSize(tester, Size(boundaryValues[i], 1200));
        await tester.pump();
        UniqueKey key = UniqueKey();
        Widget widget = MaterialApp(
          home: ResponsiveWrapper(
            key: key,
            breakpoints: [
              ResponsiveBreakpoint(breakpoint: 450, autoScale: false),
              ResponsiveBreakpoint(breakpoint: 600, autoScale: false),
              ResponsiveBreakpoint(breakpoint: 800, autoScale: false),
            ],
            child: Container(),
            shrinkWrap: false,
          ),
        );
        await tester.pumpWidget(widget);
        await tester.pump();
        dynamic state = tester.state(find.byKey(key));
        expect(state.activeBreakpoint?.breakpoint, expectedValues[i]);
      }
    });

    // Test named breakpoints.
    testWidgets('Breakpoints Named', (WidgetTester tester) async {
      List<double> boundaryValues = [
        449,
        450,
        451,
        599,
        600,
        601,
        799,
        800,
        801
      ];
      List<dynamic> expectedValues = [
        null,
        MOBILE,
        MOBILE,
        MOBILE,
        TABLET,
        TABLET,
        TABLET,
        DESKTOP,
        DESKTOP
      ];

      for (var i = 0; i < boundaryValues.length; i++) {
        resetScreenSize(tester);
        setScreenSize(tester, Size(boundaryValues[i], 1200));
        await tester.pump();
        UniqueKey key = UniqueKey();
        Widget widget = MaterialApp(
          home: ResponsiveWrapper(
            key: key,
            breakpoints: [
              ResponsiveBreakpoint(
                  breakpoint: 450, name: MOBILE, autoScale: false),
              ResponsiveBreakpoint(
                  breakpoint: 600, name: TABLET, autoScale: false),
              ResponsiveBreakpoint(
                  breakpoint: 800, name: DESKTOP, autoScale: false),
            ],
            child: Container(),
            shrinkWrap: false,
          ),
        );
        await tester.pumpWidget(widget);
        await tester.pump();
        dynamic state = tester.state(find.byKey(key));
        expect(state.activeBreakpoint?.name, expectedValues[i]);
      }
    });

    // Test 0 screen width and height.
    // Verify no errors are thrown.
    testWidgets('Screen Size 0', (WidgetTester tester) async {
      // Screen Width 0.
      setScreenSize(tester, Size(0, 1200));
      Key key = UniqueKey();
      String defaultName = 'defaultName';
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultName: defaultName,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint(
                breakpoint: 450, name: MOBILE, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 600, name: TABLET, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 800, name: DESKTOP, autoScale: false),
          ],
          child: Container(),
          shrinkWrap: false,
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      expect(state.activeBreakpoint?.name, defaultName);
      MediaQuery mediaQuery = tester.widget(find.byType(MediaQuery).first);
      expect(mediaQuery.data.size, Size(0, 1200));

      resetScreenSize(tester);
      setScreenSize(tester, Size(450, 0));
      await tester.pump();
      state = tester.state(find.byKey(key));
      expect(state.activeBreakpoint?.name, MOBILE);
      mediaQuery = tester.widget(find.byType(MediaQuery).first);
      expect(mediaQuery.data.size, Size(450, 0));

      resetScreenSize(tester);
      setScreenSize(tester, Size(0, 0));
      await tester.pump();
      state = tester.state(find.byKey(key));
      expect(state.activeBreakpoint?.breakpoint, null);
      mediaQuery = tester.widget(find.byType(MediaQuery).first);
      expect(mediaQuery.data.size, Size(0, 0));
    });

    // Test infinite screen width and height.
    testWidgets('Screen Size Infinite', (WidgetTester tester) async {
      // Infinite screen width or height is not allowed.
    }, skip: true);

    // Test convenience comparators.
    testWidgets('Breakpoint Comparators', (WidgetTester tester) async {
      // Verify comparator at named breakpoint returns correct values.
      setScreenSize(tester, Size(600, 1200));
      Key key = UniqueKey();
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          breakpoints: [
            ResponsiveBreakpoint(
                breakpoint: 450, name: MOBILE, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 500, name: MOBILE, autoScale: false),
            ResponsiveBreakpoint(breakpoint: 550, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 600, name: TABLET, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 650, name: TABLET, autoScale: false),
            ResponsiveBreakpoint(breakpoint: 700, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 800, name: DESKTOP, autoScale: false),
          ],
          child: Container(),
          shrinkWrap: false,
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      expect(ResponsiveWrapperData.fromResponsiveWrapper(state).equals(MOBILE),
          false);
      expect(ResponsiveWrapperData.fromResponsiveWrapper(state).equals(TABLET),
          true);
      expect(ResponsiveWrapperData.fromResponsiveWrapper(state).equals(DESKTOP),
          false);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isLargerThan(MOBILE),
          true);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isLargerThan(TABLET),
          false);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isLargerThan(DESKTOP),
          false);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isSmallerThan(MOBILE),
          false);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isSmallerThan(TABLET),
          true);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isSmallerThan(DESKTOP),
          true);

      // Verify comparator at unnamed breakpoint works correctly.
      key = UniqueKey();
      widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          breakpoints: [
            ResponsiveBreakpoint(
                breakpoint: 450, name: MOBILE, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 500, name: TABLET, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 550, name: MOBILE, autoScale: false),
            ResponsiveBreakpoint(breakpoint: 600, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 650, name: TABLET, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 700, name: DESKTOP, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 800, name: DESKTOP, autoScale: false),
          ],
          child: Container(),
          shrinkWrap: false,
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      state = tester.state(find.byKey(key));
      expect(ResponsiveWrapperData.fromResponsiveWrapper(state).equals(MOBILE),
          false);
      expect(ResponsiveWrapperData.fromResponsiveWrapper(state).equals(TABLET),
          false);
      expect(ResponsiveWrapperData.fromResponsiveWrapper(state).equals(DESKTOP),
          false);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isLargerThan(MOBILE),
          true);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isLargerThan(TABLET),
          true);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isLargerThan(DESKTOP),
          false);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isSmallerThan(MOBILE),
          false);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isSmallerThan(TABLET),
          true);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isSmallerThan(DESKTOP),
          true);

      // Test largerThan upper bound.
      key = UniqueKey();
      widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          breakpoints: [
            ResponsiveBreakpoint(
                breakpoint: 450, name: MOBILE, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 500, name: TABLET, autoScale: false),
            ResponsiveBreakpoint(
                breakpoint: 550, name: DESKTOP, autoScale: false),
            ResponsiveBreakpoint(breakpoint: 600, autoScale: false),
          ],
          child: Container(),
          shrinkWrap: false,
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      state = tester.state(find.byKey(key));
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isLargerThan(MOBILE),
          true);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isLargerThan(TABLET),
          true);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isLargerThan(DESKTOP),
          true);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isSmallerThan(MOBILE),
          false);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isSmallerThan(TABLET),
          false);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isSmallerThan(DESKTOP),
          false);

      // Test default name.
      key = UniqueKey();
      String defaultName = 'defaultName';
      widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultName: defaultName,
          breakpoints: [
            ResponsiveBreakpoint(breakpoint: 600, autoScale: false),
          ],
          child: Container(),
          shrinkWrap: false,
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      state = tester.state(find.byKey(key));
      expect(ResponsiveWrapperData.fromResponsiveWrapper(state).equals(null),
          true);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isLargerThan(defaultName),
          true);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isSmallerThan(defaultName),
          false);

      // Test default name reversed.
      key = UniqueKey();
      defaultName = 'defaultName';
      widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultName: defaultName,
          breakpoints: [
            ResponsiveBreakpoint(breakpoint: 800, autoScale: false),
          ],
          child: Container(),
          shrinkWrap: false,
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      state = tester.state(find.byKey(key));
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .equals(defaultName),
          true);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isLargerThan(defaultName),
          false);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isSmallerThan(null),
          true);

      // Test null.
      key = UniqueKey();
      widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          breakpoints: [],
          child: Container(),
          shrinkWrap: false,
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      state = tester.state(find.byKey(key));
      expect(ResponsiveWrapperData.fromResponsiveWrapper(state).equals(null),
          true);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state).isLargerThan(null),
          false);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isSmallerThan(null),
          false);
    });
  });
}
