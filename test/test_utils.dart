import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void setScreenSize(WidgetTester tester, Size size) {
  tester.binding.window.physicalSizeTestValue = size;
  tester.binding.window.devicePixelRatioTestValue = 1;
}

void resetScreenSize(WidgetTester tester) {
  addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
}
