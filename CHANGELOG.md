# Changelog

## 0.0.14
- Dartfmt files. No functional changes.

## 0.0.12
- Add `alignment` property for setting internal Stack alignment.
- Fix ResponsiveGridView Padding null.
- Fix iOS didChangeMetrics Context null.

## 0.0.11
- Dartfmt files. No functional changes.

## 0.0.10
- Calculate padding for SafeArea scaling correctly.
- Calculate ViewInsets for keyboard offset correctly.

## 0.0.9
- Create ResponsiveGridView that extends GridView with more grid layout controls.
- Use ResponsiveGridView for shrink and fixed item sizing options with the ability to control alignment and max row count.
- Breaking - simplified `autoScaleDown` behavior to only scale down from the specified breakpoint.

## 0.0.8
- New breakpoint calculation algorithm.
- Create `debugLog` parameter. Pretty print a visual view of breakpoint segments for debugging purposes.
- Add over 100+ tests.
- Fix first frame black screen issue.

## 0.0.7
- Add links to [Flutter Website](https://github.com/Codelessly/FlutterWebsite) example.

## 0.0.6
- Create `autoScaleDown` and `tag` behaviors.
- Create ResponsiveBreakpointSegment and algorithm to calculate breakpoint segments.
- Create experimental ResponsiveValue, ResponsiveVisibility, and ResponsiveRowColumn widgets.
- Breaking - removed `autoScale` to migrate ResponsiveBreakpoint behavior to constructors.

## 0.0.5
- Add `defaultName` parameter.
- Create tests.
- Improve breakpoint calculations and API.

## 0.0.4
- New Documentation.
- Rename `scale` to `autoScale`.

## 0.0.3
- Correct MinWidth and MaxWidth scaling.
- Import [Minimal Website Demo](https://github.com/Codelessly/FlutterMinimalWebsite)

## 0.0.2
- MinWidth and MaxWidth scaling.
- Create Demo app.

## 0.0.1
- Initial Prerelease.