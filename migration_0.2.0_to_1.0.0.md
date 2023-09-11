# v1.0.0 Migration Guide

The legacy ResponsiveWrapper combined multiple features into one widget. This made it difficult to use at times when custom behavior was required. The updated V1 implementation separates each feature into its own widget.

**Before**

- ResponsiveWrapper

**After**
- ResponsiveBreakpoints
- ResponsiveScaledBox
- MaxWidthBox

## Example

**Before**

```dart
MaterialApp(
  builder: (context, child) => ResponsiveWrapper.builder(
      BouncingScrollWrapper.builder(context, child!),
      maxWidth: 1200,
      minWidth: 450,
      defaultScale: true,
      breakpoints: [
        const ResponsiveBreakpoint.resize(450, name: MOBILE),
        const ResponsiveBreakpoint.autoScale(800, name: TABLET),
        const ResponsiveBreakpoint.resize(1920, name: DESKTOP),
        const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
      ],
      background: Container(color: const Color(0xFFF5F5F5))),
);
```

**After**

```dart
MaterialApp(
  builder: (context, child) => ResponsiveBreakpoints.builder(
    child: child!,
    breakpoints: [
      const Breakpoint(start: 0, end: 450, name: MOBILE),
      const Breakpoint(start: 451, end: 800, name: TABLET),
      const Breakpoint(start: 801, end: 1920, name: DESKTOP),
      const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
    ],
  ),
  onGenerateRoute: (RouteSettings settings) {
    return MaterialPageRoute(builder: (context) {
      // The following code implements the legacy ResponsiveWrapper AutoScale functionality
      // using the new ResponsiveScaledBox. The ResponsiveScaledBox widget preserves
      // the legacy ResponsiveWrapper behavior, scaling the UI instead of resizing.
      //
      // **MaxWidthBox** - A widget that limits the maximum width.
      // This is used to create a gutter area on either side of the content.
      //
      // **ResponsiveScaledBox** - A widget that  renders its child
      // with a FittedBox set to the `width` value. Set the fixed width value
      // based on the active breakpoint.
      return MaxWidthBox(
        maxWidth: 1200,
        background: Container(color: const Color(0xFFF5F5F5)),
        child: ResponsiveScaledBox(
          width: ResponsiveValue<double>(context, conditionalValues: [
            Condition.equals(name: MOBILE, value: 450),
            Condition.between(start: 800, end: 1100, value: 800),
            Condition.between(start: 1000, end: 1200, value: 1000),
            // There are no conditions for width over 1200
            // because the `maxWidth` is set to 1200 via the MaxWidthBox.
          ]).value,
          child: BouncingScrollWrapper.builder(
              context, buildPage(settings.name ?? ''),
              dragWithMouse: true),
        ),
      );
    });
  },
);
```


#### ResponsiveScaledBox
> ResponsiveScaledBox(width: width, child: child);

Replaces the core AutoScale functionality of ResponsiveWrapper. ResponsiveScaledBox renders the `child` widget with the specified `width`. 

This widget wraps the Flutter `FittedBox` widget with a `LayoutBuilder` and `MediaQuery`. 

**Why should you use a `ResponsiveScaledBox`?**

Use a `ResponsiveScaledBox` instead of a `FittedBox` if the layout is full screen as the widget helps calculate correctly scaled `MediaQueryData`.

#### MaxWidthBox
> MaxWidthBox(maxWidth: maxWidth, background: background, child: child);

Limit the `child` widget to the `maxWidth` and paints an optional `background` behind the widget. 

This widget is helpful for limiting the content width on large desktop displays and creating gutters on the left and right side of the page.

## Walkthrough

### Core Concept

The v0.2.0 ResponsiveWrapper is deprecated and the old `AutoScale` functionality has been moved to `ResponsiveScaledBox`.
Now, breakpoints and `AutoScale` behavior are separated. This enables "page-level" responsiveness and more customizability in v1.0.0 which was a limitation of v0.2.0. 

The `maxWidth` feature has been moved to `MaxWidthBox`.

### Step 1: Migrate ResponsiveWrapper to ResponsiveBreakpoints

```dart
ResponsiveBreakpoints.builder(
    child: child!,
    breakpoints: [
      const Breakpoint(start: 0, end: 450, name: MOBILE),
      const Breakpoint(start: 451, end: 800, name: TABLET),
      const Breakpoint(start: 801, end: 1920, name: DESKTOP),
      const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
    ],
)
```

#### Breakpoints

**Old**
```dart
const ResponsiveBreakpoint.resize(450, name: MOBILE)
```

**New**
```dart
const Breakpoint(start: 0, end: 450, name: MOBILE)
```

In v1.0.0, breakpoints are explicit and clearly define a `start` and `end`. 
It's highly recommended to create contiguous breakpoints from `0` to `double.infinity`.

#### Tags

**Old**
```dart
const ResponsiveBreakpoint.tag(900, name: 'EXPAND_SIDE_PANEL')
```

**New**
```dart
const Breakpoint(start: 900, end: 900, name: 'EXPAND_SIDE_PANEL')
```

To create a "TAG", set the start and end breakpoints to the same value.
For example, if you're building a Material 3 Navigation Rail and want to expand the menu to full width once there is enough room, you can add a custom `EXPAND_SIDE_PANEL` breakpoint.

Then, in your code, show the Rail based on the breakpoint condition.

> expand: ResponsiveBreakpoints.of(context).largerThan('EXPAND_SIDE_PANEL')

## Step 2: Migrate AutoScale to ResponsiveScaledBox

The `ResponsiveScaledBox` replaces the AutoScale functionality from `ResponsiveWrapper`. 

**Before**

```dart 
ResponsiveWrapper.builder(
  child: child,
  maxWidth: 1200,
  minWidth: 450,
  defaultScale: true,
  breakpoints: [...],
)
```

**After**

```dart
ResponsiveScaledBox(
  width: ResponsiveValue<double>(context, conditionalValues: [
    Condition.equals(name: MOBILE, value: 450),
    Condition.between(start: 800, end: 1100, value: 800),
    Condition.between(start: 1000, end: 1200, value: 1000),
  ]).value,
  child: child,
)
```

The ResponsiveScaledBox takes a ResponsiveValue<double> for its width property. The ResponsiveValue looks up the value based on breakpoint conditions.

For example:

> Condition.equals(name: MOBILE, value: 450),

The first condition checks if the active breakpoint name equals "MOBILE". If true, it will return the value 450.

When the MOBILE breakpoint is active (the screen width is between 0 and 450), this condition will match and the ResponsiveScaledBox width will be set to 450. This is useful for AutoScaling on screens that are too small and avoiding layout errors.

The ResponsiveValue allows you to define different width values for each breakpoint. It will find the first condition that matches the current active breakpoint, and return that conditional value.

Define fixed width values per breakpoint with Conditions. `Condition.equals()`, `Condition.between()`, etc.

## Step 3: Migrate MaxWidth to MaxWidthBox
The `MaxWidthBox` replaces the maxWidth property from `ResponsiveWrapper`.

**Before**

```dart
ResponsiveWrapper.builder(
  maxWidth: 1200,
  child: child 
)
```

**After**

```dart
MaxWidthBox(
  maxWidth: 1200,
  child: child
)  
```

Wrap the `MaxWidthBox` around a page to limit the max width.