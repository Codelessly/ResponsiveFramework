import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/utils/responsive_utils.dart';

import 'test_utils.dart';

void main() {
  group('ResponsiveWrapper', () {
    // Verify empty widget does nothing.
    testWidgets('Empty', (WidgetTester tester) async {
      setScreenSize(tester, const Size(450, 1200));
      Key key = UniqueKey();
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          shrinkWrap: false,
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
      MediaQuery mediaQuery = tester.widget(find.descendant(
          of: find.byKey(key), matching: find.byType(MediaQuery)));
      expect(mediaQuery.data.size, const Size(450, 1200));
    });

    // Verify empty wrapper does nothing.
    testWidgets('Empty Wrapper', (WidgetTester tester) async {
      setScreenSize(tester, const Size(450, 1200));
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
      expect(mediaQuery.data.size, const Size(450, 1200));
    });

    // Verify initialization returns [SizedBox.shrink].
    testWidgets('Initialization', (WidgetTester tester) async {
      setScreenSize(tester, const Size(450, 1200));
      // No breakpoints.
      Key key = UniqueKey();
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          breakpoints: const [
            ResponsiveBreakpoint.autoScale(450, name: MOBILE),
          ],
          shrinkWrap: false,
          child: Container(color: Colors.white),
        ),
      );
      await tester.pumpWidget(widget);
      // Initialization is empty and returns Container widget.
      expect(
          find.descendant(
              of: find.byKey(key), matching: find.byType(Container)),
          findsOneWidget);
      await tester.pump();
      // Container is created on first frame.
      expect(
          find.descendant(
              of: find.byKey(key), matching: find.byType(Container).first),
          findsOneWidget);
    });

    // Verify default name settings.
    testWidgets('Default Name', (WidgetTester tester) async {
      setScreenSize(tester, const Size(450, 1200));
      // No breakpoints.
      Key key = UniqueKey();
      String defaultName = 'defaultName';
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultName: defaultName,
          shrinkWrap: false,
          child: Container(),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      expect(
          state.activeBreakpointSegment.responsiveBreakpoint.name, defaultName);

      // Single breakpoint.
      List<double> boundaryValues = [
        449,
        450,
        451,
      ];
      List<dynamic> expectedValues = [defaultName, defaultName, defaultName];

      for (var i = 0; i < boundaryValues.length; i++) {
        resetScreenSize(tester);
        setScreenSize(tester, Size(boundaryValues[i], 1200));
        await tester.pump();
        key = UniqueKey();
        widget = MaterialApp(
          home: ResponsiveWrapper(
            key: key,
            defaultName: defaultName,
            breakpoints: const [
              ResponsiveBreakpoint.resize(450),
            ],
            shrinkWrap: false,
            child: Container(),
          ),
        );
        await tester.pumpWidget(widget);
        await tester.pump();
        state = tester.state(find.byKey(key));
        expect(state.activeBreakpointSegment.responsiveBreakpoint.name,
            expectedValues[i]);
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
            breakpoints: const [
              ResponsiveBreakpoint.resize(450, name: MOBILE),
              ResponsiveBreakpoint.resize(500),
              ResponsiveBreakpoint.resize(600, name: TABLET),
            ],
            shrinkWrap: false,
            child: Container(),
          ),
        );
        await tester.pumpWidget(widget);
        await tester.pump();
        state = tester.state(find.byKey(key));
        expect(state.activeBreakpointSegment.responsiveBreakpoint.name,
            expectedValues[i]);
      }
    });

    // Verify inherited mediaQueryData is used.
    testWidgets('MediaQueryData Inherited', (WidgetTester tester) async {
      setScreenSize(tester, const Size(450, 1200));
      Key key = UniqueKey();
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          mediaQueryData:
              const MediaQueryData(size: Size(600, 1200), devicePixelRatio: 3),
          shrinkWrap: false,
          child: Container(),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      MediaQuery mediaQuery = tester.widget(find.descendant(
          of: find.byKey(key), matching: find.byType(MediaQuery)));
      expect(mediaQuery.data.size, const Size(600, 1200));

      // Pass MediaQueryData through builder.
      key = UniqueKey();
      widget = MaterialApp(
        builder: (context, widget) => ResponsiveWrapper.builder(widget,
            mediaQueryData: const MediaQueryData(
                size: Size(600, 1200), devicePixelRatio: 3)),
        home: Container(),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      expect(
          find
              .byType(MediaQuery)
              // ignore: invalid_use_of_protected_member
              .allCandidates
              .firstWhere((element) => element.size == const Size(600, 1200)),
          isNotNull);
    });

    // Test maxWidth and minWidth values.
    testWidgets('Max and Min Width', (WidgetTester tester) async {
      // 0 value.
      setScreenSize(tester, const Size(450, 1200));
      Key key = UniqueKey();
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultScale: true,
          maxWidth: 0,
          minWidth: 0,
          shrinkWrap: false,
          child: Container(),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      // Fallback to Container.
      expect(find.byType(Container), findsOneWidget);

      // Infinity value. (BoxConstraints forbid forcing double.infinity)
      key = UniqueKey();
      widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultScale: true,
          maxWidth: 1073741823,
          minWidth: 1073741823,
          shrinkWrap: false,
          child: Container(),
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
          shrinkWrap: false,
          child: Container(),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      // Screen width is capped at maxWidth value.
      // Scale factor is 4.
      expect(state.screenWidth, 200);
    });

    testWidgets('Background Color', (WidgetTester tester) async {
      // 0 width to simulate screen loading.
      setScreenSize(tester, const Size(0, 1200));
      Widget widget = MaterialApp(
        builder: (context, widget) => ResponsiveWrapper.builder(
          widget,
          backgroundColor: Colors.amber,
        ),
        home: Container(),
      );
      // Pump once to trigger one frame build.
      await tester.pumpWidget(widget);
      // Expect only a container with color.
      widgetPredicate(Widget widget) =>
          widget is Container && widget.color == Colors.amber;
      // Confirm defaults.
      expect(find.byWidgetPredicate(widgetPredicate), findsOneWidget);
    });

    testWidgets('Background Color Null', (WidgetTester tester) async {
      // 0 width to simulate screen loading.
      setScreenSize(tester, const Size(0, 1200));
      Widget widget = MaterialApp(
        builder: (context, widget) => ResponsiveWrapper.builder(widget),
        home: Container(),
      );
      // Pump once to trigger one frame build.
      await tester.pumpWidget(widget);
      // Expect only a container with default white color.
      widgetPredicate(Widget widget) =>
          widget is Container && widget.color == Colors.white;
      // Confirm defaults.
      expect(find.byWidgetPredicate(widgetPredicate), findsOneWidget);
    });

    testWidgets('Background Widget', (WidgetTester tester) async {
      // 0 width to simulate screen loading.
      setScreenSize(tester, const Size(0, 1200));
      Widget widget = MaterialApp(
        builder: (context, widget) => ResponsiveWrapper.builder(
          widget,
          background: Container(color: Colors.blue),
          backgroundColor: Colors.amber, // Overriden by background widget.
        ),
        home: Container(),
      );
      // Pump once to trigger one frame build.
      await tester.pumpWidget(widget);
      // Expect background to be a blue container.
      widgetPredicate(Widget widget) =>
          widget is Container && widget.color == Colors.blue;
      // Confirm defaults.
      expect(find.byWidgetPredicate(widgetPredicate), findsOneWidget);
    });

    /// Rebuilding ResponsiveWrapper should not
    /// throw an error if the parent has been disposed
    /// and the context no longer exists. This test verifies
    /// that the error is fixed.
    testWidgets('Parent Destroyed Context Null', (WidgetTester tester) async {
      // 0 width to simulate screen loading.
      setScreenSize(tester, const Size(1200, 1200));
      Widget responsiveWrapper = ResponsiveWrapper.builder(
        Container(),
        minWidth: 320,
        defaultScale: false,
        breakpoints: [],
      );
      Widget widget = MaterialApp(
        key: const ValueKey('1'),
        home: responsiveWrapper,
      );
      // Pump once to trigger one frame build.
      await tester.pumpWidget(widget);
      setScreenSize(tester, const Size(300, 1200));
      // Changing the MaterialApp using a different ValueKey
      // disposes the widget and triggers the error (before the fix).
      widget = MaterialApp(
        key: const ValueKey('2'),
        home: responsiveWrapper,
      );
      await tester.pumpWidget(widget);
    });
  });

  group('ResponsiveBreakpoint', () {
    // Test ResponsiveBreakpoint class parameters.
    test('Parameters', () {
      // Test empty breakpoint.
      ResponsiveBreakpoint responsiveBreakpoint =
          const ResponsiveBreakpoint.resize(0);
      // Test print empty.
      debugPrint(responsiveBreakpoint.toString());
      expect(responsiveBreakpoint.breakpoint, 0);
      expect(responsiveBreakpoint.scaleFactor, 1);
      expect(responsiveBreakpoint.name, null);

      // Test setting parameters types.
      responsiveBreakpoint = const ResponsiveBreakpoint.autoScale(600,
          name: MOBILE, scaleFactor: 1.2);
      // Test print parameters.
      debugPrint(responsiveBreakpoint.toString());
    });

    // Test duplicate breakpoints.
    testWidgets('Breakpoint Duplicate', (WidgetTester tester) async {
      setScreenSize(tester, const Size(450, 1200));
      Key key = UniqueKey();
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(600),
            ResponsiveBreakpoint.resize(450),
            ResponsiveBreakpoint.resize(450),
            ResponsiveBreakpoint.resize(450),
            ResponsiveBreakpoint.resize(450),
            ResponsiveBreakpoint.resize(450),
            ResponsiveBreakpoint.resize(450),
          ],
          shrinkWrap: false,
          child: Container(),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      expect(
          state.activeBreakpointSegment.responsiveBreakpoint.breakpoint, 450);

      resetScreenSize(tester);
      setScreenSize(tester, const Size(600, 1200));
      await tester.pump();
      state = tester.state(find.byKey(key));
      expect(
          state.activeBreakpointSegment.responsiveBreakpoint.breakpoint, 600);

      // Test duplicate named breakpoints.
      resetScreenSize(tester);
      setScreenSize(tester, const Size(450, 1200));
      await tester.pump();
      key = UniqueKey();
      widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(600, name: TABLET),
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.resize(450, name: MOBILE),
          ],
          shrinkWrap: false,
          child: Container(),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      state = tester.state(find.byKey(key));
      expect(state.activeBreakpointSegment.responsiveBreakpoint.name, MOBILE);

      resetScreenSize(tester);
      setScreenSize(tester, const Size(600, 1200));
      await tester.pump();
      state = tester.state(find.byKey(key));
      expect(state.activeBreakpointSegment.responsiveBreakpoint.name, TABLET);
    });

    // Test breakpoint bounds (0, infinity)
    testWidgets('Breakpoint Bounds', (WidgetTester tester) async {
      setScreenSize(tester, const Size(400, 1200));
      Key key = UniqueKey();
      String defaultName = 'defaultName';
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          minWidth: 450,
          defaultName: defaultName,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(0, name: '0'),
            ResponsiveBreakpoint.resize(1073741823, name: 'Infinity'),
          ],
          shrinkWrap: false,
          child: Container(),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      expect(state.activeBreakpointSegment.responsiveBreakpoint.name, '0');
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
        450,
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
            breakpoints: const [
              ResponsiveBreakpoint.resize(450),
              ResponsiveBreakpoint.resize(600),
              ResponsiveBreakpoint.resize(800),
            ],
            shrinkWrap: false,
            child: Container(),
          ),
        );
        await tester.pumpWidget(widget);
        await tester.pump();
        dynamic state = tester.state(find.byKey(key));
        expect(state.activeBreakpointSegment.responsiveBreakpoint.breakpoint,
            expectedValues[i]);
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
            breakpoints: const [
              ResponsiveBreakpoint.resize(450, name: MOBILE),
              ResponsiveBreakpoint.resize(600, name: TABLET),
              ResponsiveBreakpoint.resize(800, name: DESKTOP),
            ],
            shrinkWrap: false,
            child: Container(),
          ),
        );
        await tester.pumpWidget(widget);
        await tester.pump();
        dynamic state = tester.state(find.byKey(key));
        expect(state.activeBreakpointSegment.responsiveBreakpoint.name,
            expectedValues[i]);
      }
    });

    // Test 0 screen width and height.
    // Verify no errors are thrown.
    testWidgets('Screen Size 0', (WidgetTester tester) async {
      // Screen width and height 0.
      setScreenSize(tester, const Size(0, 0));
      Key key = UniqueKey();
      String defaultName = 'defaultName';
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultName: defaultName,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.resize(600, name: TABLET),
            ResponsiveBreakpoint.resize(800, name: DESKTOP),
          ],
          shrinkWrap: false,
          child: Container(),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      expect(
          state.activeBreakpointSegment.responsiveBreakpoint.name, defaultName);
      MediaQuery mediaQuery = tester.widget(find.byType(MediaQuery).first);
      expect(mediaQuery.data.size, const Size(0, 0));

      resetScreenSize(tester);
      setScreenSize(tester, const Size(450, 0));
      await tester.pump();
      state = tester.state(find.byKey(key));
      expect(state.activeBreakpointSegment.responsiveBreakpoint.name, MOBILE);
      mediaQuery = tester.widget(find.byType(MediaQuery).first);
      expect(mediaQuery.data.size, const Size(450, 0));

      resetScreenSize(tester);
      setScreenSize(tester, const Size(0, 0));
      await tester.pump();
      state = tester.state(find.byKey(key));
      expect(
          state.activeBreakpointSegment.responsiveBreakpoint.breakpoint, 450);
      mediaQuery = tester.widget(find.byType(MediaQuery).first);
      expect(mediaQuery.data.size, const Size(0, 0));
    });

    testWidgets('Screen Width 0 Initialization', (WidgetTester tester) async {
      // Screen width and height 0.
      setScreenSize(tester, const Size(0, 1200));
      Key key = UniqueKey();
      String defaultName = 'defaultName';
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultName: defaultName,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.resize(600, name: TABLET),
            ResponsiveBreakpoint.resize(800, name: DESKTOP),
          ],
          shrinkWrap: false,
          child: Container(),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      MediaQuery mediaQuery = tester.widget(find.byType(MediaQuery).first);
      expect(mediaQuery.data.size, const Size(0, 1200));
    });

    testWidgets('Screen Height 0 Initialization', (WidgetTester tester) async {
      // Screen width and height 0.
      setScreenSize(tester, const Size(1200, 0));
      Key key = UniqueKey();
      String defaultName = 'defaultName';
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          defaultName: defaultName,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.resize(600, name: TABLET),
            ResponsiveBreakpoint.resize(800, name: DESKTOP),
          ],
          shrinkWrap: false,
          child: Container(),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      MediaQuery mediaQuery = tester.widget(find.byType(MediaQuery).first);
      expect(mediaQuery.data.size, const Size(1200, 0));
    });

    // Test infinite screen width and height.
    // Infinite screen width or height is not allowed.

    // Test convenience comparators.
    testWidgets('Breakpoint Comparators', (WidgetTester tester) async {
      // Verify comparator at named breakpoint returns correct values.
      setScreenSize(tester, const Size(600, 1200));
      Key key = UniqueKey();
      Widget widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          breakpoints: const [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.resize(500, name: MOBILE),
            ResponsiveBreakpoint.resize(550),
            ResponsiveBreakpoint.resize(600, name: TABLET),
            ResponsiveBreakpoint.resize(650, name: TABLET),
            ResponsiveBreakpoint.resize(700),
            ResponsiveBreakpoint.resize(800, name: DESKTOP),
          ],
          shrinkWrap: false,
          child: Container(),
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
          false);
      expect(
          ResponsiveWrapperData.fromResponsiveWrapper(state)
              .isSmallerThan(DESKTOP),
          true);

      // Verify comparator at unnamed breakpoint works correctly.
      key = UniqueKey();
      widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          breakpoints: const [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.resize(500, name: MOBILE),
            ResponsiveBreakpoint.resize(550, name: MOBILE),
            ResponsiveBreakpoint.resize(600),
            ResponsiveBreakpoint.resize(650, name: TABLET),
            ResponsiveBreakpoint.resize(700, name: DESKTOP),
            ResponsiveBreakpoint.resize(800, name: DESKTOP),
          ],
          shrinkWrap: false,
          child: Container(),
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

      // Test largerThan upper bound.
      key = UniqueKey();
      widget = MaterialApp(
        home: ResponsiveWrapper(
          key: key,
          breakpoints: const [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.resize(500, name: TABLET),
            ResponsiveBreakpoint.resize(550, name: DESKTOP),
            ResponsiveBreakpoint.resize(600),
          ],
          shrinkWrap: false,
          child: Container(),
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
          breakpoints: const [
            ResponsiveBreakpoint.resize(600),
          ],
          shrinkWrap: false,
          child: Container(),
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
          breakpoints: const [
            ResponsiveBreakpoint.resize(800),
          ],
          shrinkWrap: false,
          child: Container(),
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
          breakpoints: const [],
          shrinkWrap: false,
          child: Container(),
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

  group('Landscape Mode', () {
    // Test if platform correctly detects landscape mode.
    testWidgets('Landscape Platform Android', (WidgetTester tester) async {
      // Width is greater than height.
      setScreenSize(tester, const Size(1200, 800));

      // Set target platform to Android.
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      Key key = UniqueKey();
      Widget widget = Builder(
        builder: (context) {
          return MaterialApp(
            home: ResponsiveWrapper(
              key: key,
              breakpoints: const [],
              shrinkWrap: false,
              child: Container(),
            ),
          );
        },
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      // Landscape supported in Android by default.
      expect(state.isLandscapePlatform, true);

      // Unset global to avoid crash.
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('Landscape Platform iOS', (WidgetTester tester) async {
      // Width is greater than height.
      setScreenSize(tester, const Size(1200, 800));

      // Set target platform to Android.
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      Key key = UniqueKey();
      Widget widget = Builder(
        builder: (context) {
          return MaterialApp(
            home: ResponsiveWrapper(
              key: key,
              breakpoints: const [],
              shrinkWrap: false,
              child: Container(),
            ),
          );
        },
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      // Landscape supported in Android by default.
      expect(state.isLandscapePlatform, true);

      // Unset global to avoid crash.
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('Landscape Platform Windows', (WidgetTester tester) async {
      // Width is greater than height.
      setScreenSize(tester, const Size(1200, 800));

      // Set target platform to Windows.
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;

      Key key = UniqueKey();
      Widget widget = Builder(
        builder: (context) {
          return MaterialApp(
            home: ResponsiveWrapper(
              key: key,
              breakpoints: const [],
              shrinkWrap: false,
              child: Container(),
            ),
            // Set target platform to Windows.
          );
        },
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      // Landscape not supported in windows by default.
      expect(state.isLandscapePlatform, false);

      // Unset global to avoid crash.
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('Landscape Platform Web', (WidgetTester tester) async {
      // TODO: How to simulate test on web?
    });

    // Test landscape platforms override
    testWidgets('Landscape Platform Override', (WidgetTester tester) async {
      // Width is greater than height.
      setScreenSize(tester, const Size(1200, 800));

      // Set target platform to Windows.
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;

      Key key = UniqueKey();
      Widget widget = Builder(
        builder: (context) {
          return MaterialApp(
            home: ResponsiveWrapper(
              key: key,
              breakpoints: const [],
              shrinkWrap: false,
              // Override platform to enable landscape on windows.
              landscapePlatforms: const [ResponsiveTargetPlatform.windows],
              child: Container(),
            ),
            // Set target platform to Windows.
          );
        },
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      expect(state.isLandscapePlatform, true);

      // Unset global to avoid crash.
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('isLandscape Function', (WidgetTester tester) async {
      // Width is greater than height.
      setScreenSize(tester, const Size(1200, 800));

      // Set target platform to Android.
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      Key key = UniqueKey();
      Widget widget = Builder(
        builder: (context) {
          return MaterialApp(
            home: ResponsiveWrapper(
              key: key,
              breakpoints: const [],
              breakpointsLandscape: const [
                ResponsiveBreakpoint.autoScale(800),
              ],
              shrinkWrap: false,
              child: Container(),
            ),
          );
        },
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      // Landscape supported in Android by default.
      expect(state.isLandscape, true);

      // Switch to portrait.
      setScreenSize(tester, const Size(800, 1200));
      await tester.pump();
      state = tester.state(find.byKey(key));
      expect(state.isLandscape, false);

      // Unset global to avoid crash.
      debugDefaultTargetPlatformOverride = null;
    });

    // Text active breakpoints.
    testWidgets('Landscape Active Breakpoints', (WidgetTester tester) async {
      // Width is greater than height.
      setScreenSize(tester, const Size(1200, 800));

      // Set target platform to Android.
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      List<ResponsiveBreakpoint> breakpoints = [
        const ResponsiveBreakpoint.autoScale(400),
        const ResponsiveBreakpoint.autoScale(800),
        const ResponsiveBreakpoint.autoScale(1200),
      ];

      Key key = UniqueKey();
      Widget widget = Builder(
        builder: (context) {
          return MaterialApp(
            home: ResponsiveWrapper(
              key: key,
              breakpoints: const [],
              breakpointsLandscape: breakpoints,
              shrinkWrap: false,
              child: Container(),
            ),
          );
        },
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      expect(state.breakpoints, breakpoints);

      // Unset global to avoid crash.
      debugDefaultTargetPlatformOverride = null;
    });

    // Test switch active breakpoints.
    testWidgets('Landscape Switch Breakpoints', (WidgetTester tester) async {
      // Width is greater than height.
      setScreenSize(tester, const Size(1200, 800));

      // Set target platform to Android.
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      List<ResponsiveBreakpoint> breakpoints = [
        const ResponsiveBreakpoint.autoScale(600),
        const ResponsiveBreakpoint.autoScale(700),
        const ResponsiveBreakpoint.autoScale(1000),
      ];

      List<ResponsiveBreakpoint> breakpointsLandscape = [
        const ResponsiveBreakpoint.autoScale(400),
        const ResponsiveBreakpoint.autoScale(800),
        const ResponsiveBreakpoint.autoScale(1200),
      ];

      Key key = UniqueKey();
      Widget widget = Builder(
        builder: (context) {
          return MaterialApp(
            home: ResponsiveWrapper(
              key: key,
              breakpoints: breakpoints,
              breakpointsLandscape: breakpointsLandscape,
              minWidth: 400,
              minWidthLandscape: 800,
              maxWidth: 1200,
              maxWidthLandscape: 2560,
              defaultScale: true,
              defaultScaleLandscape: false,
              defaultScaleFactor: 0.8,
              defaultScaleFactorLandscape: 1.2,
              defaultName: 'PORTRAIT',
              defaultNameLandscape: 'LANDSCAPE',
              shrinkWrap: false,
              child: Container(),
            ),
          );
        },
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      expect(state.breakpoints, breakpointsLandscape);
      expect(state.minWidth, 800);
      expect(state.maxWidth, 2560);
      expect(state.defaultScale, false);
      expect(state.defaultScaleFactor, 1.2);
      expect(state.defaultName, 'LANDSCAPE');

      resetScreenSize(tester);
      setScreenSize(tester, const Size(600, 1200));
      await tester.pump();
      expect(state.breakpoints, breakpoints);
      expect(state.minWidth, 400);
      expect(state.maxWidth, 1200);
      expect(state.defaultScale, true);
      expect(state.defaultScaleFactor, 0.8);
      expect(state.defaultName, 'PORTRAIT');

      // Unset global to avoid crash.
      debugDefaultTargetPlatformOverride = null;
    });
  });

  group('useShortestSide Behaviour', () {
    // Test that useShortestSide is disabled by default
    testWidgets('useShortestSide Disabled', (WidgetTester tester) async {
      // Width is greater than height.
      setScreenSize(tester, const Size(1200, 800));

      // Set target platform to Android.
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      Key key = UniqueKey();
      Widget widget = Builder(
        builder: (context) {
          return MaterialApp(
            home: ResponsiveWrapper(
              key: key,
              breakpoints: const [],
              breakpointsLandscape: const [],
              minWidth: 400,
              minWidthLandscape: 800,
              maxWidth: 1200,
              maxWidthLandscape: 2560,
              shrinkWrap: false,
              child: Container(),
            ),
          );
        },
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      // Test Landscape
      expect(state.useShortestSide, false);
      expect(state.minWidth, 800);
      expect(state.maxWidth, 2560);
      // Change to Portrait
      resetScreenSize(tester);
      setScreenSize(tester, const Size(600, 1200));
      await tester.pump();
      // Test Portrait
      expect(state.useShortestSide, false);
      expect(state.minWidth, 400);
      expect(state.maxWidth, 1200);
      // Unset global to avoid crash.
      debugDefaultTargetPlatformOverride = null;
    });

    // Test that useShortestSide is disabled by default
    testWidgets('useShortestSide + Breakpoints', (WidgetTester tester) async {
      // Height is greater than width.
      setScreenSize(tester, const Size(400, 800));

      // Set target platform to Android.
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      List<ResponsiveBreakpoint> breakpoints = [
        const ResponsiveBreakpoint.autoScale(350, scaleFactor: 1),
        const ResponsiveBreakpoint.autoScale(600, scaleFactor: 2),
        const ResponsiveBreakpoint.autoScale(750, scaleFactor: 3),
      ];

      Key key = UniqueKey();
      Widget widget = Builder(
        builder: (context) {
          return MaterialApp(
            home: ResponsiveWrapper(
              key: key,
              breakpoints: breakpoints,
              minWidth: 100,
              useShortestSide: true,
              maxWidth: 400,
              shrinkWrap: false,
              child: Container(),
            ),
          );
        },
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      // Test Portrait scaleFactor
      expect(state.useShortestSide, true);
      expect(state.activeBreakpointSegment.responsiveBreakpoint.scaleFactor, 1);
      // Change to Landscape
      resetScreenSize(tester);
      setScreenSize(tester, const Size(800, 400));
      await tester.pump();
      // Test Landscape scaleFactor
      expect(state.useShortestSide, true);
      expect(state.activeBreakpointSegment.responsiveBreakpoint.scaleFactor, 1);
      // Make screen biggger
      resetScreenSize(tester);
      setScreenSize(tester, const Size(650, 900));
      await tester.pump();
      // Test Portrait scaleFactor
      expect(state.useShortestSide, true);
      expect(state.activeBreakpointSegment.responsiveBreakpoint.scaleFactor, 2);
      // Change to Landscape
      resetScreenSize(tester);
      setScreenSize(tester, const Size(900, 650));
      await tester.pump();
      // Test Landscape scaleFactor
      expect(state.useShortestSide, true);
      expect(state.activeBreakpointSegment.responsiveBreakpoint.scaleFactor, 2);
      // Make screen biggger
      resetScreenSize(tester);
      setScreenSize(tester, const Size(800, 1200));
      await tester.pump();
      // Test Portrait scaleFactor
      expect(state.useShortestSide, true);
      expect(state.activeBreakpointSegment.responsiveBreakpoint.scaleFactor, 3);
      // Change to Landscape
      resetScreenSize(tester);
      setScreenSize(tester, const Size(1200, 800));
      await tester.pump();
      // Test Landscape scaleFactor
      expect(state.useShortestSide, true);
      expect(state.activeBreakpointSegment.responsiveBreakpoint.scaleFactor, 3);
      // Unset global to avoid crash.
      debugDefaultTargetPlatformOverride = null;
    });
    testWidgets('useShortestSide + Breakpoints + breakpointsLandscape',
        (WidgetTester tester) async {
      // Height is greater than width.
      setScreenSize(tester, const Size(400, 800));

      // Set target platform to Android.
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      List<ResponsiveBreakpoint> breakpoints = [
        const ResponsiveBreakpoint.autoScale(350, scaleFactor: 1),
        const ResponsiveBreakpoint.autoScale(600, scaleFactor: 2),
        const ResponsiveBreakpoint.autoScale(750, scaleFactor: 3),
      ];
      // Over exagerated to note the difference
      List<ResponsiveBreakpoint> breakpointsLandscape = [
        const ResponsiveBreakpoint.autoScale(350, scaleFactor: 6),
        const ResponsiveBreakpoint.autoScale(600, scaleFactor: 7),
        const ResponsiveBreakpoint.autoScale(750, scaleFactor: 8),
      ];

      Key key = UniqueKey();
      Widget widget = Builder(
        builder: (context) {
          return MaterialApp(
            home: ResponsiveWrapper(
              key: key,
              breakpoints: breakpoints,
              breakpointsLandscape: breakpointsLandscape,
              minWidth: 100,
              useShortestSide: true,
              maxWidth: 400,
              shrinkWrap: false,
              child: Container(),
            ),
          );
        },
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      dynamic state = tester.state(find.byKey(key));
      // Test Portrait scaleFactor
      expect(state.useShortestSide, true);
      expect(state.activeBreakpointSegment.responsiveBreakpoint.scaleFactor, 1);
      // Change to Landscape
      resetScreenSize(tester);
      setScreenSize(tester, const Size(800, 400));
      await tester.pump();
      // Test Landscape scaleFactor
      expect(state.useShortestSide, true);
      expect(state.activeBreakpointSegment.responsiveBreakpoint.scaleFactor, 6);
      // Make screen biggger
      resetScreenSize(tester);
      setScreenSize(tester, const Size(650, 900));
      await tester.pump();
      // Test Portrait scaleFactor
      expect(state.useShortestSide, true);
      expect(state.activeBreakpointSegment.responsiveBreakpoint.scaleFactor, 2);
      // Change to Landscape
      resetScreenSize(tester);
      setScreenSize(tester, const Size(900, 650));
      await tester.pump();
      // Test Landscape scaleFactor
      expect(state.useShortestSide, true);
      expect(state.activeBreakpointSegment.responsiveBreakpoint.scaleFactor, 7);
      // Make screen biggger
      resetScreenSize(tester);
      setScreenSize(tester, const Size(800, 1200));
      await tester.pump();
      // Test Portrait scaleFactor
      expect(state.useShortestSide, true);
      expect(state.activeBreakpointSegment.responsiveBreakpoint.scaleFactor, 3);
      // Change to Landscape
      resetScreenSize(tester);
      setScreenSize(tester, const Size(1200, 800));
      await tester.pump();
      // Test Landscape scaleFactor
      expect(state.useShortestSide, true);
      expect(state.activeBreakpointSegment.responsiveBreakpoint.scaleFactor, 8);
      // Unset global to avoid crash.
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
