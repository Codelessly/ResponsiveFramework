import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A wrapper that helps child widgets resize/scale
/// to different screen dimensions.
///
/// This class automatically resizes/scales child widgets
/// on [ResponsiveBreakpoint]s. Computed [MediaQueryData]
/// and [ResponsiveWrapperData] with correct
/// dimensions are passed to child widgets.
///
/// The default Flutter behavior for layout changes
/// is resizing. To easily adapt to a wide variety of
/// screen sizes, [ResponsiveWrapper] can proportionally scale
/// a layout. This eliminates the need to manually adapt
/// layouts to [MOBILE], [TABLET], and [DESKTOP].
///
/// To understand the difference between resizing
/// and scaling, take the following example.
/// An [AppBar] looks correct on a phone. When
/// viewed on a desktop however, the AppBar is
/// too short and the title looks too small. This is
/// because Flutter does not scale widgets by default.
/// Here is what happens with each behavior:
/// 1. Resizing (default) - the AppBar's width is
/// double.infinity so it stretches to fill the available
/// width. The [kToolbarHeight] is fixed and stays 56dp.
/// 2. Scaling - the AppBar's width stretches to fill
/// the available width. The height scales proportionally
/// using an aspect ratio automatically calculated
/// from the nearest [ResponsiveBreakpoint]. As the
/// width increases, the height increases proportionally.
///
/// An arbitrary number of breakpoints can be set.
/// Resizing/scaling behavior can be mixed and
/// matched as below.
/// 1400+: scale on extra large 4K displays so
/// text is still legible and widgets are not spaced
/// too far apart.
/// 1400-800: resize on desktops to use available space.
/// 800-600: scale on tablets to avoid elements
/// appearing too small.
/// 600-350: resize on phones for native widget sizes.
/// below 350: resize on small screens to avoid
/// cramp and overflow errors.
class ResponsiveWrapper extends StatefulWidget {
  final Widget child;
  final List<ResponsiveBreakpoint> breakpoints;
  final double maxWidth;
  final double minWidth;
  final String defaultName;
  final bool defaultScale;
  final double defaultScaleFactor;
  final Widget background;
  final MediaQueryData mediaQueryData;

  /// A wrapper widget that makes child widgets responsive.
  const ResponsiveWrapper({
    Key key,
    @required this.child,
    this.breakpoints = const [],
    this.maxWidth,
    this.minWidth = 450,
    this.defaultName,
    this.defaultScale = false,
    this.defaultScaleFactor = 1,
    this.background,
    this.mediaQueryData,
  }) : super(key: key);

  @override
  _ResponsiveWrapperState createState() => _ResponsiveWrapperState();

  static Widget builder(
    Widget child, {
    List<ResponsiveBreakpoint> breakpoints = const [],
    double maxWidth,
    double minWidth = 450,
    String defaultName,
    bool defaultScale = false,
    double defaultScaleFactor = 1,
    Widget background,
    MediaQueryData mediaQueryData,
  }) {
    // Order breakpoints from largest to smallest.
    // Perform ordering operation to allow breakpoints
    // to be accepted in any order.
    breakpoints.sort((a, b) => b.breakpoint.compareTo(a.breakpoint));

    return ResponsiveWrapper(
      child: child,
      breakpoints: breakpoints,
      maxWidth: maxWidth,
      minWidth: minWidth,
      defaultName: defaultName,
      defaultScale: defaultScale,
      defaultScaleFactor: defaultScaleFactor,
      background: background,
      mediaQueryData: mediaQueryData,
    );
  }

  static ResponsiveWrapperData of(BuildContext context, {bool nullOk = false}) {
    assert(context != null);
    assert(nullOk != null);
    final InheritedResponsiveWrapper data = context
        .dependOnInheritedWidgetOfExactType<InheritedResponsiveWrapper>();
    if (data != null) return data.data;
    if (nullOk) return null;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          "ResponsiveWrapper.of() called with a context that does not contain a ResponsiveWrapper."),
      ErrorDescription(
          "No Responsive ancestor could be found starting from the context that was passed "
          "to ResponsiveWrapper.of(). Place a ResponsiveWrapper at the root of the app "
          "or supply a ResponsiveWrapper.builder."),
      context.describeElement('The context used was')
    ]);
  }
}

class _ResponsiveWrapperState extends State<ResponsiveWrapper>
    with WidgetsBindingObserver {
  double devicePixelRatio = 1;
  double getDevicePixelRatio() {
    return widget.mediaQueryData?.devicePixelRatio ??
        MediaQuery.of(context).devicePixelRatio;
  }

  double windowWidth = 0;
  double getWindowWidth() {
    return widget.mediaQueryData?.size?.width ??
        MediaQuery.of(context).size.width;
  }

  double windowHeight = 0;
  double getWindowHeight() {
    return widget.mediaQueryData?.size?.height ??
        MediaQuery.of(context).size.height;
  }

  get breakpoints => widget.breakpoints;

  /// Get screen width calculation.
  double screenWidth = 0;
  double getScreenWidth() {
    activeBreakpoint = getActiveBreakpoint(windowWidth);
    // Check if screenWidth exceeds maxWidth.
    if (widget.maxWidth != null) if (windowWidth > widget.maxWidth) {
      // Check if there is an active breakpoint with autoScale set to true.
      if (activeBreakpoint.breakpoint != null &&
          activeBreakpoint.breakpoint > widget.maxWidth &&
          activeBreakpoint.autoScale) {
        return widget.maxWidth + (windowWidth - activeBreakpoint.breakpoint);
      } else {
        // Max Width reached. Return Max Width because no breakpoint is active.
        return widget.maxWidth;
      }
    }

    return windowWidth;
  }

  /// Get screen height calculations.
  double screenHeight = 0;
  double getScreenHeight() {
    // Check if screenWidth exceeds maxWidth.
    if (widget.maxWidth != null) if (windowWidth > widget.maxWidth) {
      // Check if there is an active breakpoint with autoScale set to true.
      if (activeBreakpoint.breakpoint != null &&
          activeBreakpoint.breakpoint > widget.maxWidth &&
          activeBreakpoint.autoScale) {
        // Scale screen height by the amount the width was scaled.
        return windowHeight / (screenWidth / widget.maxWidth);
      }
    }

    // Return default window height as height.
    return windowHeight;
  }

  ResponsiveBreakpoint activeBreakpoint;

  /// Simulated content width calculations.
  ///
  /// The [scaledWidth] is computed with the
  /// following algorithm:
  /// 1. Find the active breakpoint and resize using
  /// that breakpoint's logic.
  /// 2. If no breakpoint is found, check if the [screenWidth]
  /// is smaller than the smallest breakpoint. If so,
  /// follow [widget.defaultScale] behavior to resize.
  /// 3. There are no breakpoints set. Resize using
  /// [widget.defaultScale] behavior and [widget.minWidth].
  double scaledWidth = 1;
  double getScaledWidth() {
    // No breakpoint is set. Return default calculated width.
    if (activeBreakpoint.breakpoint == null) {
      // If widget should resize, use default screenWidth.
      if (widget.defaultScale == false)
        return screenWidth / widget.defaultScaleFactor;
      // Scale using default minWidth.
      return widget.minWidth / widget.defaultScaleFactor;
    }
    // If widget should resize, use screenWidth.
    if (activeBreakpoint.autoScale == false)
      return screenWidth / activeBreakpoint.scaleFactor;

    // Screen is larger than max width. Scale from max width.
    if (widget.maxWidth != null) if (activeBreakpoint.breakpoint >
        widget.maxWidth) return widget.maxWidth / activeBreakpoint.scaleFactor;

    // Return width from breakpoint with scale factor applied.
    return activeBreakpoint.breakpoint / activeBreakpoint.scaleFactor;
  }

  /// Simulated content height calculations.
  ///
  /// The [scaledHeight] is dependent upon the
  /// [screenWidth] and [widget.breakpoints].
  /// If the widget is scaled, the height is computed
  /// to preserve the scaled aspect ratio.
  /// The [scaledHeight] is computed with the
  /// following algorithm:
  /// 1. Find the active breakpoint. If the widget should
  /// resize, nothing more needs to be done.
  /// 2. If the widget should scale, calculate the screen
  /// aspect ratio and return the proportional height.
  /// 3. If there are no active breakpoints and [widget.defaultScale]
  /// is resize, nothing more needs to be done.
  /// 4. Return calculated proportional height with
  /// [widget.minWidth].
  double scaledHeight = 1;
  double getScaledHeight() {
    if (activeBreakpoint.breakpoint == null) {
      // If widget should resize, use default screenHeight.
      if (widget.defaultScale == false)
        return screenHeight / widget.defaultScaleFactor;
      // Scale using default minWidth.
      return screenHeight /
          (screenWidth / widget.minWidth) /
          widget.defaultScaleFactor;
    }
    // If widget should resize, use screenHeight.
    if (activeBreakpoint.autoScale == false)
      return screenHeight / activeBreakpoint.scaleFactor;

    // Screen is larger than max width. Calculate height
    // from max width.
    if (widget.maxWidth != null) if (activeBreakpoint.breakpoint >
        widget.maxWidth) {
      return screenHeight / activeBreakpoint.scaleFactor;
    }

    // Find width adjustment scale to proportionally scale height.
    // If screenWidth is scaled 1.5x larger than the breakpoint,
    // decrease screenHeight by 33.33% to proportionally scale content.
    double widthScale = screenWidth / activeBreakpoint.breakpoint;
    // Scale height with width scale and scale factor applied.
    return screenHeight / widthScale / activeBreakpoint.scaleFactor;
  }

  double get activeScaleFactor {
    if (activeBreakpoint.breakpoint != null &&
        activeBreakpoint.autoScale == true) return activeBreakpoint.scaleFactor;

    return widget.defaultScaleFactor;
  }

  /// Fullscreen is enabled if maxWidth is not set.
  /// Default fullscreen enabled.
  get fullscreen => widget.maxWidth == null;

  /// Calculate updated dimensions.
  void setDimensions() {
    devicePixelRatio = getDevicePixelRatio();
    windowWidth = getWindowWidth();
    windowHeight = getWindowHeight();
    screenWidth = getScreenWidth();
    screenHeight = getScreenHeight();
    scaledWidth = getScaledWidth();
    scaledHeight = getScaledHeight();
  }

  /// Set [activeBreakpoint].
  /// Active breakpoint is the first breakpoint smaller
  /// or equal to the [screenWidth].
  ResponsiveBreakpoint getActiveBreakpoint(double screenWidth) {
    return widget.breakpoints.firstWhere(
        (element) => screenWidth >= element.breakpoint,
        orElse: // No breakpoint found.
            () => ResponsiveBreakpoint(
                breakpoint: null, name: widget.defaultName));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setDimensions();
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // When physical dimensions change, update state.
    // The required MediaQueryData is only available
    // on the next frame for physical dimension changes.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setDimensions();
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(ResponsiveWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When [ResponsiveWrapper]'s constructor is
    // used directly in the widget tree and a parent
    // MediaQueryData changes, update state.
    // The screen dimensions are passed immediately.
    setDimensions();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return (screenWidth ==
            0) // Initialization check. Window measurements not available until postFrameCallback.
        ? Container()
        : InheritedResponsiveWrapper(
            data: ResponsiveWrapperData.fromResponsiveWrapper(this),
            child: MediaQuery(
              data: calculateMediaQueryData(),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  widget.background ?? Container(),
                  SizedBox(
                    width: screenWidth,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: scaledWidth,
                        height: scaledHeight,
                        alignment: Alignment.center,
                        child: widget.child,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  /// Return updated [MediaQueryData] values.
  ///
  /// If [widget.mediaQueryData] exists, update
  /// existing values. Else, find [mediaQueryData]
  /// ancestor in the widget tree and update.
  MediaQueryData calculateMediaQueryData() {
    // Update passed in MediaQueryData.
    if (widget.mediaQueryData != null) {
      return widget.mediaQueryData.copyWith(
          size: Size(scaledWidth, scaledHeight),
          devicePixelRatio: devicePixelRatio * activeScaleFactor);
    }

    return MediaQuery.of(context).copyWith(
        size: Size(scaledWidth, scaledHeight),
        devicePixelRatio: devicePixelRatio * activeScaleFactor);
  }
}

// Device Type Constants.
const String MOBILE = "MOBILE";
const String TABLET = "TABLET";
const String PHONE = "PHONE";
const String DESKTOP = "DESKTOP";

/// Responsive data about the current screen.
///
/// Resized and scaled values can be accessed
/// like [ResponsiveWrapperData.scaledWidth].
@immutable
class ResponsiveWrapperData {
  final double screenWidth;
  final double screenHeight;
  final double scaledWidth;
  final double scaledHeight;
  final List<ResponsiveBreakpoint> breakpoints;
  final ResponsiveBreakpoint activeBreakpoint;
  final bool isMobile;
  final bool isPhone;
  final bool isTablet;
  final bool isDesktop;

  /// Creates responsive data with explicit values.
  ///
  /// Consider using [ResponsiveWrapperData.fromResponsiveWrapper]
  /// to create data based on the [ResponsiveWrapper] state.
  const ResponsiveWrapperData({
    this.screenWidth,
    this.screenHeight,
    this.scaledWidth,
    this.scaledHeight,
    this.breakpoints,
    this.activeBreakpoint,
    this.isMobile,
    this.isPhone,
    this.isTablet,
    this.isDesktop,
  });

  /// Creates data based on the [ResponsiveWrapper] state.
  static ResponsiveWrapperData fromResponsiveWrapper(
      _ResponsiveWrapperState state) {
    return ResponsiveWrapperData(
      screenWidth: state.screenWidth,
      screenHeight: state.screenHeight,
      scaledWidth: state.scaledWidth,
      scaledHeight: state.scaledHeight,
      breakpoints: state.breakpoints,
      activeBreakpoint: state?.activeBreakpoint,
      isMobile: state?.activeBreakpoint?.name == MOBILE,
      isPhone: state?.activeBreakpoint?.name == PHONE,
      isTablet: state?.activeBreakpoint?.name == TABLET,
      isDesktop: state?.activeBreakpoint?.name == DESKTOP,
    );
  }

  @override
  String toString() =>
      "ResponsiveWrapperData(" +
      "screenWidth: " +
      screenWidth?.toString() +
      ", screenHeight: " +
      screenHeight?.toString() +
      ", scaledWidth: " +
      scaledWidth?.toString() +
      ", scaledHeight: " +
      scaledHeight?.toString() +
      ", breakpoints: " +
      breakpoints?.asMap().toString() +
      ", activeBreakpoint: " +
      activeBreakpoint.toString() +
      ", isMobile: " +
      isMobile?.toString() +
      ", isPhone: " +
      isPhone?.toString() +
      ", isTablet: " +
      isTablet?.toString() +
      ", isDesktop: " +
      isDesktop?.toString() +
      ")";

  /// Is the [scaledWidth] larger than or equal to [breakpointName]?
  /// Defaults to false if the [breakpointName] cannot be found.
  bool isLargerThan(String breakpointName) =>
      scaledWidth >=
      breakpoints
          .firstWhere((element) => element.name == breakpointName,
              orElse: () => ResponsiveBreakpoint(breakpoint: 1073741823))
          .breakpoint;

  /// Is the [scaledWidth] smaller than the [breakpointName]?
  /// Defaults to false if the [breakpointName] cannot be found.
  bool isSmallerThan(String breakpointName) {
    return scaledWidth <
        breakpoints
            .firstWhere((element) => element.name == breakpointName,
                orElse: () => ResponsiveBreakpoint(breakpoint: -1073741824))
            .breakpoint;
  }
}

/// Creates an immutable widget that exposes [ResponsiveWrapperData]
/// to child widgets.
///
/// Access values such as the [ResponsiveWrapperData.scaledWidth]
/// property through [ResponsiveWrapper.of]
/// `ResponsiveWrapper.of(context).scaledWidth`.
///
/// Querying this widget with [ResponsiveWrapper.of]
/// creates a dependency that causes an automatic
/// rebuild whenever the [ResponsiveWrapperData]
/// changes.
///
/// If no [ResponsiveWrapper] is in scope then the
/// [MediaQuery.of] method will throw an exception,
/// unless the `nullOk` argument is set to true, in
/// which case it returns null.
@immutable
class InheritedResponsiveWrapper extends InheritedWidget {
  final ResponsiveWrapperData data;

  /// Creates a widget that provides [ResponsiveWrapperData] to its descendants.
  ///
  /// The [data] and [child] arguments must not be null.
  InheritedResponsiveWrapper(
      {Key key, @required this.data, @required Widget child})
      : assert(child != null),
        assert(data != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedResponsiveWrapper oldWidget) =>
      data != oldWidget.data;
}

@immutable
class ResponsiveBreakpoint {
  final int breakpoint;
  final bool autoScale;
  final double scaleFactor;
  final String name;

  const ResponsiveBreakpoint(
      {@required this.breakpoint,
      this.autoScale = false,
      this.scaleFactor = 1,
      this.name});

  @override
  String toString() =>
      "ResponsiveBreakpoint(" +
      "breakpoint: " +
      breakpoint.toString() +
      ", autoScale: " +
      autoScale.toString() +
      ", scaleFactor: " +
      scaleFactor.toString() +
      ", name: " +
      name.toString() +
      ")";
}
