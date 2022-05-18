# Changelog

## 0.2.0
- Flutter 3 release.

## 0.1.9
- Flutter 2 compatibility version. This is the last version to support Flutter 2.

## 0.1.8
- Flutter 3 support.

## 0.1.7
- Fix sort crash in web due to JS converting variables into immutable vals that cannot be sorted.

## 0.1.6
-  Enable using `background` widget for the 1st render frame if set. This allows for a smoother transition between native mobile splash screen and Flutter application UI.
-  Add generic T to support type safety and automatic type conversion in ResponsiveValue.

## 0.1.5
- Add `useShortestSide` property to calculate responsiveness based on the shortest side of the screen, instead of the actual landscape orientation.

## 0.1.4
- Fix ListIterable.firstWhere `Bad state: No element` breakpoint initialization error.

## 0.1.2
- Full support for `landscapeBreakpoints` - breakpoints in landscape mode. Create landscape overrides with `minWidthLandscape`, `maxWidthLandscape`, `defaultScaleLandscape`, etc.
- Use `ResponsiveTargetPlatform` to enable landscape support for platforms including web.

## 0.1.1
- Add initial support for `landscapeBreakpoints` which enables overriding default breakpoints on platforms with landscape orientations.

## 0.1.0
- Null Safety Migration.

## 0.0.15
- Fix `backgroundColor` incorrectly requiring a widget.
- Fix context null error when widget parent is destroyed on layout update.

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
- Calculate ViewInsets for keyboa rd offset correctly.

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