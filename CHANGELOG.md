# Changelog
## 1.2.0
- Flutter v3.19 update.
- ResponsiveValue nullable type support.
- Update ResponsiveRowColumn to use underlying Flex instead of Row and Columns.
  - Preserves nested widget state when switching between Rows and Columns.
- Fix `landscape` incorrectly set to always true.

## 1.1.1
- v1.0.0 migration guide: [Migration Guide](https://github.com/Codelessly/ResponsiveFramework/blob/master/migration_0.2.0_to_1.0.0.md)
- Fix landscape values null.
- Remove names and comments of deprecated `ResponsiveWrapper` in code.

## 1.1.0
- Breaking Change - Responsive Value Condition is no longer constant to support inheriting type nullability.
- Simplify example.

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