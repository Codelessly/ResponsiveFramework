import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void setScreenSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
}

void resetScreenSize(WidgetTester tester) {
  addTearDown(tester.view.resetPhysicalSize);
}
