# Changelog

## 1.0.0
- New ResponsiveBreakpoints widget.
- Deprecated ResponsiveWrapper widget.

## 0.2.0
Legacy `ResponsiveWrapper` implementation.

Usage instructions:

```yaml
responsive_framework: 0.2.0
```

Add `ResponsiveWrapper.builder` to your MaterialApp or CupertinoApp.
```dart
import 'package:responsive_framework/responsive_framework.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => ResponsiveWrapper.builder(
          child,
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ],
          background: Container(color: Color(0xFFF5F5F5))),
      initialRoute: "/",
    );
  }
}
```