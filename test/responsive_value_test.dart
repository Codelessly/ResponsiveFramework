import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'test_utils.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var paddingWidth = ResponsiveValue(context, defaultValue: 10.0, valueWhen: [
      const Condition.smallerThan(breakpoint: 300, value: 5.0),
    ]).value;
    return Container(
      key: const Key('testContainer'),
      padding: EdgeInsets.all(paddingWidth),
    );
  }
}

void main() {
  group("Responsive Value", () {
    testWidgets("return default value", (WidgetTester tester) async {
      setScreenSize(tester, const Size(450, 1200));
      const expectedPadding = EdgeInsets.all(10.0);

      await tester.pumpWidget(MaterialApp(
          builder: (context, widget) => ResponsiveWrapper.builder(widget),
          home: const TestWidget()));
      await tester.pump();

      Container container = tester.firstWidget(find.byKey(const Key("testContainer")));
      expect(container.padding, expectedPadding);
    });

    testWidgets("return the conditioned value", (WidgetTester tester) async {
      setScreenSize(tester, const Size(200, 1200));
      const expectedPadding = EdgeInsets.all(5.0);

      await tester.pumpWidget(MaterialApp(
          builder: (context, widget) => ResponsiveWrapper.builder(widget),
          home: const TestWidget()));
      await tester.pump();

      Container container = tester.firstWidget(find.byKey(const Key("testContainer")));
      expect(container.padding, expectedPadding);
    });
  });
}
