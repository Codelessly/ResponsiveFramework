// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'utils/responsive_utils.dart';

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
  final Widget? child;
  final List<ResponsiveBreakpoint>? breakpoints;

  /// A list of breakpoints that are active when the device is in landscape orientation.
  ///
  /// In Flutter, the returned device orientation is not the real device orientation,
  /// but is calculated based on the screen width and height.
  /// This means that landscape only makes sense on devices that support
  /// orientation changes. By default, landscape breakpoints are only
  /// active when the [ResponsiveTargetPlatform] is Android, iOS, or Fuchsia.
  /// To enable landscape breakpoints on other platforms, pass a custom
  /// list of supported platforms to [landscapePlatforms].
  final List<ResponsiveBreakpoint>? breakpointsLandscape;

  /// Override list of platforms to enable landscape mode on.
  /// By default, only mobile platforms support landscape mode.
  /// This override exists primarily to enable custom landscape vs portrait behavior
  /// and future compatibility with Fuschia.
  final List<ResponsiveTargetPlatform>? landscapePlatforms;
  final double minWidth;
  final double? maxWidth;
  final String? defaultName;
  final bool defaultScale;
  final double defaultScaleFactor;

  /// Calculate responsiveness based on the shortest
  /// side of the screen, instead of the actual
  /// landscape orientation.
  ///
  /// This is useful for apps that want to avoid
  /// scrolling screens and distribute their content
  /// based on width/height regardless of orientation.
  /// Size units can remain the same when the phone
  /// is in landscape mode or portrait mode.
  /// The developer needs only change a few widgets'
  /// hard-coded size depending on the orientation.
  /// The rest of the widgets maintain their size but
  /// change the way they are displayed.
  ///
  /// `useShortestSide` can be used in conjunction with
  /// [breakpointsLandscape] for additional configurability.
  /// Landscape breakpoints will activate when the
  /// physical device is in landscape mode but base
  /// calculations on the shortest side instead of
  /// the actual landscape width.
  final bool useShortestSide;

  /// Landscape minWidth value. Defaults to [minWidth] if not set.
  final double? minWidthLandscape;

  /// Landscape maxWidth value. Defaults to [maxWidth] if not set.
  final double? maxWidthLandscape;

  /// Landscape defaultName value. Defaults to [defaultName] if not set.
  final String? defaultNameLandscape;

  /// Landscape defaultScale value. Defaults to [defaultScale] if not set.
  final bool? defaultScaleLandscape;

  /// Landscape defaultScaleFactor value. Defaults to [defaultScaleFactor] if not set.
  final double? defaultScaleFactorLandscape;

  /// An optional background widget to insert behind
  /// the responsive content. The background widget
  /// expands to fill the entire space of the wrapper and
  /// is not resized.
  /// Can be used to set a background image, pattern,
  /// or solid fill.
  /// Overrides [backgroundColor] if a widget is set.
  final Widget? background;

  /// First frame initialization default background color.
  /// Because layout initialization is delayed by 1 frame,
  /// a solid background color is displayed instead.
  /// Is overridden by [background] if set.
  /// Defaults to a white background.
  final Color? backgroundColor;
  final MediaQueryData? mediaQueryData;
  final bool shrinkWrap;

  /// Control the internal Stack alignment. The ResponsiveWrapper
  /// uses a Stack to enable child widgets to resize.
  /// Defaults to [Alignment.topCenter] because app
  /// content is usually top aligned.
  final Alignment alignment;
  final bool debugLog;

  /// A wrapper widget that makes child widgets responsive.
  const ResponsiveWrapper({
    Key? key,
    required this.child,
    this.breakpoints,
    this.breakpointsLandscape,
    this.landscapePlatforms,
    this.minWidth = 450,
    this.maxWidth,
    this.defaultName,
    this.defaultScale = false,
    this.defaultScaleFactor = 1,
    this.minWidthLandscape,
    this.maxWidthLandscape,
    this.defaultNameLandscape,
    this.defaultScaleLandscape,
    this.defaultScaleFactorLandscape,
    this.background,
    this.backgroundColor,
    this.mediaQueryData,
    this.shrinkWrap = true,
    this.alignment = Alignment.topCenter,
    this.useShortestSide = false,
    this.debugLog = false,
  }) : super(key: key);

  @override
  ResponsiveWrapperState createState() => ResponsiveWrapperState();

  static Widget builder(
    Widget? child, {
    List<ResponsiveBreakpoint>? breakpoints,
    List<ResponsiveBreakpoint>? breakpointsLandscape,
    List<ResponsiveTargetPlatform>? landscapePlatforms,
    double minWidth = 450,
    double? maxWidth,
    String? defaultName,
    bool defaultScale = false,
    double defaultScaleFactor = 1,
    double? minWidthLandscape,
    bool useShortestSide = false,
    double? maxWidthLandscape,
    String? defaultNameLandscape,
    bool? defaultScaleLandscape,
    double? defaultScaleFactorLandscape,
    Widget? background,
    Color? backgroundColor,
    MediaQueryData? mediaQueryData,
    Alignment alignment = Alignment.topCenter,
    bool debugLog = false,
  }) {
    return ResponsiveWrapper(
      breakpoints: breakpoints,
      breakpointsLandscape: breakpointsLandscape,
      landscapePlatforms: landscapePlatforms,
      minWidth: minWidth,
      maxWidth: maxWidth,
      defaultName: defaultName,
      useShortestSide: useShortestSide,
      defaultScale: defaultScale,
      defaultScaleFactor: defaultScaleFactor,
      minWidthLandscape: minWidthLandscape,
      maxWidthLandscape: maxWidthLandscape,
      defaultNameLandscape: defaultNameLandscape,
      defaultScaleLandscape: defaultScaleLandscape,
      defaultScaleFactorLandscape: defaultScaleFactorLandscape,
      background: background,
      backgroundColor: backgroundColor,
      mediaQueryData: mediaQueryData,
      shrinkWrap: false,
      alignment: alignment,
      debugLog: debugLog,
      child: child,
    );
  }

  static ResponsiveWrapperData of(BuildContext context) {
    final InheritedResponsiveWrapper? data = context
        .dependOnInheritedWidgetOfExactType<InheritedResponsiveWrapper>();
    if (data != null) return data.data;
    throw FlutterError.fromParts(
      <DiagnosticsNode>[
        ErrorSummary(
            'ResponsiveWrapper.of() called with a context that does not contain a ResponsiveWrapper.'),
        ErrorDescription(
            'No Responsive ancestor could be found starting from the context that was passed '
            'to ResponsiveWrapper.of(). Place a ResponsiveWrapper at the root of the app '
            'or supply a ResponsiveWrapper.builder.'),
        context.describeElement('The context used was')
      ],
    );
  }
}

class ResponsiveWrapperState extends State<ResponsiveWrapper>
    with WidgetsBindingObserver {
  double devicePixelRatio = 1;
  double getDevicePixelRatio() {
    return widget.mediaQueryData?.devicePixelRatio ??
        MediaQuery.of(context).devicePixelRatio;
  }

  double windowWidth = 0;
  double getWindowWidth() {
    return widget.mediaQueryData?.size.width ??
        MediaQuery.of(context).size.width;
  }

  double windowHeight = 0;
  double getWindowHeight() {
    return widget.mediaQueryData?.size.height ??
        MediaQuery.of(context).size.height;
  }

  List<ResponsiveBreakpoint> breakpoints = [];
  List<ResponsiveBreakpointSegment> breakpointSegments = [];

  /// Get screen width calculation.
  double screenWidth = 0;
  double getScreenWidth() {
    double widthCalc = useShortestSide
        ? (windowWidth < windowHeight ? windowWidth : windowHeight)
        : windowWidth;
    activeBreakpointSegment = getActiveBreakpointSegment(widthCalc);
    // Special 0 width condition.
    if (activeBreakpointSegment.responsiveBreakpoint.breakpoint == 0) return 0;
    // Check if screenWidth exceeds maxWidth.
    if (maxWidth != null && windowWidth > maxWidth!) {
      // Check if there is an active breakpoint with autoScale set to true.
      if (activeBreakpointSegment.breakpoint >= maxWidth! &&
          activeBreakpointSegment.responsiveBreakpoint.isAutoScale) {
        // Proportionally scaled width that exceeds maxWidth.
        return maxWidth! +
            (windowWidth -
                activeBreakpointSegment.responsiveBreakpoint.breakpoint);
      } else {
        // Max Width reached. Return Max Width because no breakpoint is active.
        return maxWidth!;
      }
    }

    return windowWidth;
  }

  /// Get screen height calculations.
  double screenHeight = 0;
  double getScreenHeight() {
    // Special 0 height condition.
    if (activeBreakpointSegment.responsiveBreakpoint.breakpoint == 0) return 0;
    // Check if screenWidth exceeds maxWidth.
    if (maxWidth != null) {
      if (windowWidth > maxWidth!) {
        // Check if there is an active breakpoint with autoScale set to true.
        if (activeBreakpointSegment.breakpoint > maxWidth! &&
            activeBreakpointSegment.responsiveBreakpoint.isAutoScale) {
          // Scale screen height by the amount the width was scaled.
          return windowHeight / (screenWidth / maxWidth!);
        }
      }
    }

    // Return default window height as height.
    return windowHeight;
  }

  late ResponsiveBreakpointSegment activeBreakpointSegment;

  /// Simulated content width calculations.
  ///
  /// The [scaledWidth] is computed with the
  /// following algorithm:
  /// 1. Find the active breakpoint and resize using
  /// that breakpoint's logic.
  /// 2. If no breakpoint is found, check if the [screenWidth]
  /// is smaller than the smallest breakpoint. If so,
  /// follow [defaultScale] behavior to resize.
  /// 3. There are no breakpoints set. Resize using
  /// [defaultScale] behavior and [minWidth].
  double scaledWidth = 0;
  double getScaledWidth() {
    // If widget should resize, use screenWidth.
    if (activeBreakpointSegment.responsiveBreakpoint.isResize) {
      return screenWidth /
          activeBreakpointSegment.responsiveBreakpoint.scaleFactor;
    }

    // Screen is larger than max width. Scale from max width.
    if (maxWidth != null) {
      if (activeBreakpointSegment.breakpoint > maxWidth!) {
        return maxWidth! /
            activeBreakpointSegment.responsiveBreakpoint.scaleFactor;
      }
    }

    // Return width from breakpoint with scale factor applied.
    return activeBreakpointSegment.responsiveBreakpoint.breakpoint /
        activeBreakpointSegment.responsiveBreakpoint.scaleFactor;
  }

  /// Simulated content height calculations.
  ///
  /// The [scaledHeight] is dependent upon the
  /// [screenWidth] and [breakpoints].
  /// If the widget is scaled, the height is computed
  /// to preserve the scaled aspect ratio.
  /// The [scaledHeight] is computed with the
  /// following algorithm:
  /// 1. Find the active breakpoint. If the widget should
  /// resize, nothing more needs to be done.
  /// 2. If the widget should scale, calculate the screen
  /// aspect ratio and return the proportional height.
  /// 3. If there are no active breakpoints and [defaultScale]
  /// is resize, nothing more needs to be done.
  /// 4. Return calculated proportional height with
  /// [minWidth].
  double scaledHeight = 0;
  double getScaledHeight() {
    // If widget should resize, use screenHeight.
    if (activeBreakpointSegment.responsiveBreakpoint.isResize) {
      return screenHeight /
          activeBreakpointSegment.responsiveBreakpoint.scaleFactor;
    }

    // Screen is larger than max width. Calculate height
    // from max width.
    if (maxWidth != null) {
      if (activeBreakpointSegment.breakpoint > maxWidth!) {
        return screenHeight /
            activeBreakpointSegment.responsiveBreakpoint.scaleFactor;
      }
    }

    // Find width adjustment scale to proportionally scale height.
    // If screenWidth is scaled 1.5x larger than the breakpoint,
    // decrease screenHeight by 33.33% to proportionally scale content.
    double widthScale =
        screenWidth / activeBreakpointSegment.responsiveBreakpoint.breakpoint;
    // Scale height with width scale and scale factor applied.
    return screenHeight /
        widthScale /
        activeBreakpointSegment.responsiveBreakpoint.scaleFactor;
  }

  /// Simulated view inset calculations.
  ///
  /// The [viewInset] is dependent upon the
  /// [scaledWidth] and [scaledHeight] respectively.
  /// If the screen is scaled, the view insets should
  /// be scaled to preserve the aspect ratio.
  /// The [scaledViewInsets] are computed with the
  /// following algorithm:
  /// 1. Find the percentage of screen height the original view insets are
  /// 2. Calculate the number of pixels the same percentage of the scaled height is.
  /// 4. Return calculated proportional insets
  EdgeInsets? scaledViewInsets;
  EdgeInsets getScaledViewInsets() {
    double leftInsetFactor;
    double topInsetFactor;
    double rightInsetFactor;
    double bottomInsetFactor;
    double scaledLeftInset;
    double scaledTopInset;
    double scaledRightInset;
    double scaledBottomInset;

    if (widget.mediaQueryData != null) {
      leftInsetFactor = widget.mediaQueryData!.viewInsets.left / screenWidth;
      topInsetFactor = widget.mediaQueryData!.viewInsets.top / screenHeight;
      rightInsetFactor = widget.mediaQueryData!.viewInsets.right / screenWidth;
      bottomInsetFactor =
          widget.mediaQueryData!.viewInsets.bottom / screenHeight;
    } else {
      leftInsetFactor = MediaQuery.of(context).viewInsets.left / screenWidth;
      topInsetFactor = MediaQuery.of(context).viewInsets.top / screenHeight;
      rightInsetFactor = MediaQuery.of(context).viewInsets.right / screenWidth;
      bottomInsetFactor =
          MediaQuery.of(context).viewInsets.bottom / screenHeight;
    }

    scaledLeftInset = leftInsetFactor * scaledWidth;
    scaledTopInset = topInsetFactor * scaledHeight;
    scaledRightInset = rightInsetFactor * scaledWidth;
    scaledBottomInset = bottomInsetFactor * scaledHeight;

    return EdgeInsets.fromLTRB(
        scaledLeftInset, scaledTopInset, scaledRightInset, scaledBottomInset);
  }

  EdgeInsets? scaledViewPadding;
  EdgeInsets getScaledViewPadding() {
    double leftPaddingFactor;
    double topPaddingFactor;
    double rightPaddingFactor;
    double bottomPaddingFactor;
    double scaledLeftPadding;
    double scaledTopPadding;
    double scaledRightPadding;
    double scaledBottomPadding;

    if (widget.mediaQueryData != null) {
      leftPaddingFactor = widget.mediaQueryData!.viewPadding.left / screenWidth;
      topPaddingFactor = widget.mediaQueryData!.viewPadding.top / screenHeight;
      rightPaddingFactor =
          widget.mediaQueryData!.viewPadding.right / screenWidth;
      bottomPaddingFactor =
          widget.mediaQueryData!.viewPadding.bottom / screenHeight;
    } else {
      leftPaddingFactor = MediaQuery.of(context).viewPadding.left / screenWidth;
      topPaddingFactor = MediaQuery.of(context).viewPadding.top / screenHeight;
      rightPaddingFactor =
          MediaQuery.of(context).viewPadding.right / screenWidth;
      bottomPaddingFactor =
          MediaQuery.of(context).viewPadding.bottom / screenHeight;
    }

    scaledLeftPadding = leftPaddingFactor * scaledWidth;
    scaledTopPadding = topPaddingFactor * scaledHeight;
    scaledRightPadding = rightPaddingFactor * scaledWidth;
    scaledBottomPadding = bottomPaddingFactor * scaledHeight;

    return EdgeInsets.fromLTRB(scaledLeftPadding, scaledTopPadding,
        scaledRightPadding, scaledBottomPadding);
  }

  EdgeInsets? scaledPadding;
  EdgeInsets getScaledPadding() {
    double scaledLeftPadding;
    double scaledTopPadding;
    double scaledRightPadding;
    double scaledBottomPadding;

    scaledLeftPadding =
        max(0.0, getScaledViewPadding().left - getScaledViewInsets().left);
    scaledTopPadding =
        max(0.0, getScaledViewPadding().top - getScaledViewInsets().top);
    scaledRightPadding =
        max(0.0, getScaledViewPadding().right - getScaledViewInsets().right);
    scaledBottomPadding =
        max(0.0, getScaledViewPadding().bottom - getScaledViewInsets().bottom);

    return EdgeInsets.fromLTRB(scaledLeftPadding, scaledTopPadding,
        scaledRightPadding, scaledBottomPadding);
  }

  double get activeScaleFactor =>
      activeBreakpointSegment.responsiveBreakpoint.scaleFactor;

  /// Fullscreen is enabled if maxWidth is not set.
  /// Default fullscreen enabled.
  get fullscreen => maxWidth == null;

  Orientation get orientation => (windowWidth > windowHeight)
      ? Orientation.landscape
      : Orientation.portrait;

  static const List<ResponsiveTargetPlatform> _landscapePlatforms = [
    ResponsiveTargetPlatform.iOS,
    ResponsiveTargetPlatform.android,
    ResponsiveTargetPlatform.fuchsia,
  ];

  ResponsiveTargetPlatform? platform;

  void setPlatform() {
    platform = kIsWeb
        ? ResponsiveTargetPlatform.web
        : Theme.of(context).platform.responsiveTargetPlatform;
  }

  bool get isLandscapePlatform =>
      (widget.landscapePlatforms ?? _landscapePlatforms).contains(platform);

  bool get isLandscape =>
      orientation == Orientation.landscape &&
      isLandscapePlatform &&
      widget.breakpointsLandscape != null;

  double get minWidth => isLandscape
      ? (widget.minWidthLandscape ?? widget.minWidth)
      : widget.minWidth;
  double? get maxWidth => isLandscape
      ? (widget.maxWidthLandscape ?? widget.maxWidth)
      : widget.maxWidth;
  String? get defaultName => isLandscape
      ? (widget.defaultNameLandscape ?? widget.defaultName)
      : widget.defaultName;
  bool get defaultScale => isLandscape
      ? (widget.defaultScaleLandscape ?? widget.defaultScale)
      : widget.defaultScale;
  double get defaultScaleFactor => isLandscape
      ? (widget.defaultScaleFactorLandscape ?? widget.defaultScaleFactor)
      : widget.defaultScaleFactor;
  bool get useShortestSide => widget.useShortestSide;

  /// Calculate updated dimensions.
  void setDimensions() {
    devicePixelRatio = getDevicePixelRatio();
    windowWidth = getWindowWidth();
    windowHeight = getWindowHeight();
    screenWidth = getScreenWidth();
    screenHeight = getScreenHeight();
    scaledWidth = getScaledWidth();
    scaledHeight = getScaledHeight();
    scaledViewInsets = getScaledViewInsets();
    scaledViewPadding = getScaledViewPadding();
    scaledPadding = getScaledPadding();
  }

  /// Get enabled breakpoints based on [orientation] and [platform].
  List<ResponsiveBreakpoint> getActiveBreakpoints() {
    // If the device is landscape enabled and the current orientation is landscape, use landscape breakpoints.
    if (isLandscape) {
      return widget.breakpointsLandscape ?? [];
    }
    return widget.breakpoints ?? [];
  }

  /// Calculate [breakpointSegments] from [breakpoints].
  List<ResponsiveBreakpointSegment> calcBreakpointSegments(
      List<ResponsiveBreakpoint> breakpoints) {
    // Seed breakpoint based on config values.
    ResponsiveBreakpoint defaultBreakpoint = ResponsiveBreakpoint(
        breakpoint: minWidth,
        name: defaultName,
        behavior: defaultScale
            ? ResponsiveBreakpointBehavior.AUTOSCALE
            : ResponsiveBreakpointBehavior.RESIZE,
        scaleFactor: defaultScaleFactor);
    return getBreakpointSegments(breakpoints, defaultBreakpoint);
  }

  /// Set [activeBreakpointSegment].
  /// Active breakpoint segment is the first breakpoint segment
  /// smaller or equal to the [windowWidth].
  ResponsiveBreakpointSegment getActiveBreakpointSegment(double windowWidth) {
    ResponsiveBreakpointSegment activeBreakpointSegment = breakpointSegments
        .reversed
        .firstWhere((element) => windowWidth >= element.breakpoint);
    return activeBreakpointSegment;
  }

  /// Set [breakpoints] and [breakpointSegments].
  void setBreakpoints() {
    // Optimization. Only update breakpoints if dimensions have changed.
    if ((windowWidth != getWindowWidth()) ||
        (windowHeight != getWindowHeight()) ||
        (windowWidth == 0)) {
      windowWidth = getWindowWidth();
      windowHeight = getWindowHeight();
      breakpoints.clear();
      breakpointSegments.clear();
      breakpoints.addAll(getActiveBreakpoints());
      breakpointSegments.addAll(calcBreakpointSegments(breakpoints));
    }
  }

  @override
  void initState() {
    super.initState();
    // Log breakpoints to console.
    if (widget.debugLog) {
      List<ResponsiveBreakpoint> defaultBreakpoints = widget.breakpoints ?? [];
      List<ResponsiveBreakpointSegment> defaultBreakpointSegments =
          calcBreakpointSegments(defaultBreakpoints);
      // Add Portrait and Landscape annotations if landscape breakpoints are provided.
      if (widget.breakpointsLandscape != null) {
        debugPrint('**PORTRAIT**');
      }
      ResponsiveUtils.debugLogBreakpointSegments(defaultBreakpointSegments);
      // Print landscape breakpoints.
      if (widget.breakpointsLandscape != null) {
        List<ResponsiveBreakpoint> landscapeBreakpoints =
            widget.breakpointsLandscape ?? [];
        List<ResponsiveBreakpointSegment> landscapeBreakpointSegments =
            calcBreakpointSegments(landscapeBreakpoints);
        debugPrint('**LANDSCAPE**');
        ResponsiveUtils.debugLogBreakpointSegments(landscapeBreakpointSegments);
      }
    }

    // Dimensions are only available after first frame paint.
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Breakpoints must be initialized before the first frame is drawn.
      setBreakpoints();
      // Directly updating dimensions is safe because frame callbacks
      // in initState are guaranteed.
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
      // Widget could be destroyed by resize. Verify widget
      // exists before updating dimensions.
      if (mounted) {
        setBreakpoints();
        setDimensions();
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(ResponsiveWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When [ResponsiveWrapper]'s constructor is
    // used directly in the widget tree and a parent
    // MediaQueryData changes, update state.
    // The screen dimensions are passed immediately.
    setBreakpoints();
    setDimensions();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Platform initialization requires context.
    setPlatform();

    // Initialization check. Window measurements not available until postFrameCallback.
    // Return first frame with empty background.
    if (screenWidth == 0) {
      return buildBackground(
          background: widget.background, color: widget.backgroundColor);
    }

    return InheritedResponsiveWrapper(
      data: ResponsiveWrapperData.fromResponsiveWrapper(this),
      child: Stack(
        alignment: widget.alignment,
        children: [
          widget.background ?? const SizedBox.shrink(),
          MediaQuery(
            data: calculateMediaQueryData(),
            child: SizedBox(
              width: screenWidth,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
                child: Container(
                  width: scaledWidth,
                  height: (widget.shrinkWrap == true &&
                          widget.mediaQueryData == null)
                      ? null
                      : scaledHeight,
                  // Shrink wrap height if no MediaQueryData is passed.
                  alignment: Alignment.center,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ],
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
      return widget.mediaQueryData!.copyWith(
          size: Size(scaledWidth, scaledHeight),
          devicePixelRatio: devicePixelRatio * activeScaleFactor,
          viewInsets: scaledViewInsets,
          viewPadding: scaledViewPadding,
          padding: scaledPadding);
    }

    return MediaQuery.of(context).copyWith(
        size: Size(scaledWidth, scaledHeight),
        devicePixelRatio: devicePixelRatio * activeScaleFactor,
        viewInsets: scaledViewInsets,
        viewPadding: scaledViewPadding,
        padding: scaledPadding);
  }

  /// Builds a container with widget [background] or [color].
  /// Defaults to a white background.
  Widget buildBackground({Widget? background, Color? color}) {
    if (background != null) return background;
    if (color != null) return Container(color: color);

    return Container(color: Colors.white);
  }
}

// Device Type Constants.
const String MOBILE = 'MOBILE';
const String TABLET = 'TABLET';
const String PHONE = 'PHONE';
const String DESKTOP = 'DESKTOP';

/// Responsive data about the current screen.
///
/// Resized and scaled values can be accessed
/// such as [ResponsiveWrapperData.scaledWidth].
@immutable
class ResponsiveWrapperData {
  final double screenWidth;
  final double screenHeight;
  final double scaledWidth;
  final double scaledHeight;
  final List<ResponsiveBreakpoint> breakpoints;
  final List<ResponsiveBreakpointSegment> breakpointSegments;
  final ResponsiveBreakpoint activeBreakpoint;
  final bool isMobile;
  final bool isPhone;
  final bool isTablet;
  final bool isDesktop;
  final Orientation orientation;

  /// Creates responsive data with explicit values.
  ///
  /// Consider using [ResponsiveWrapperData.fromResponsiveWrapper]
  /// to create data based on the [ResponsiveWrapper] state.
  const ResponsiveWrapperData({
    this.screenWidth = 0,
    this.screenHeight = 0,
    this.scaledWidth = 0,
    this.scaledHeight = 0,
    this.breakpoints = const [],
    this.breakpointSegments = const [],
    this.activeBreakpoint = const ResponsiveBreakpoint.tag(0, name: ''),
    this.isMobile = false,
    this.isPhone = false,
    this.isTablet = false,
    this.isDesktop = false,
    this.orientation = Orientation.portrait,
  });

  /// Creates data based on the [ResponsiveWrapper] state.
  static ResponsiveWrapperData fromResponsiveWrapper(
      ResponsiveWrapperState state) {
    return ResponsiveWrapperData(
      screenWidth: state.screenWidth,
      screenHeight: state.screenHeight,
      scaledWidth: state.scaledWidth,
      scaledHeight: state.scaledHeight,
      breakpoints: state.breakpoints,
      breakpointSegments: state.breakpointSegments,
      activeBreakpoint: state.activeBreakpointSegment.responsiveBreakpoint,
      isMobile:
          state.activeBreakpointSegment.responsiveBreakpoint.name == MOBILE,
      isPhone: state.activeBreakpointSegment.responsiveBreakpoint.name == PHONE,
      isTablet:
          state.activeBreakpointSegment.responsiveBreakpoint.name == TABLET,
      isDesktop:
          state.activeBreakpointSegment.responsiveBreakpoint.name == DESKTOP,
      orientation: state.orientation,
    );
  }

  @override
  String toString() =>
      'ResponsiveWrapperData(screenWidth: $screenWidth, screenHeight: $screenHeight, scaledWidth: $scaledWidth, scaledHeight: $scaledHeight, breakpoints: ${breakpoints.asMap()}, breakpointSegments: $breakpointSegments, activeBreakpoint: $activeBreakpoint, isMobile: $isMobile, isPhone: $isPhone, isTablet: $isTablet, isDesktop: $isDesktop)';

  bool equals(String? name) => activeBreakpoint.name == name;

  /// Is the [scaledWidth] larger than or equal to [name]?
  /// Defaults to false if the [name] cannot be found.
  bool isLargerThan(String? name) {
    // No breakpoints to match.
    if (breakpoints.isEmpty) return false;

    // Breakpoint is active breakpoint.
    if (activeBreakpoint.name == name) return false;

    // Single breakpoint is active and screen width
    // is larger than default breakpoint.
    if (breakpoints.length == 1 && screenWidth >= breakpoints[0].breakpoint) {
      return true;
    }
    // Find first breakpoint end boundary that is larger
    // than screen width. Breakpoint names could be
    // chained so perform a full search from largest to smallest.
    for (var i = breakpoints.length - 2; i >= 0; i--) {
      if (breakpoints[i].name == name &&
          breakpoints[i + 1].name != name &&
          screenWidth >= breakpoints[i + 1].breakpoint) return true;
    }

    return false;
  }

  /// Is the [screenWidth] smaller than the [name]?
  /// Defaults to false if the [name] cannot be found.
  bool isSmallerThan(String? name) =>
      screenWidth <
      breakpointSegments
          .firstWhere((element) => element.responsiveBreakpoint.name == name,
              orElse: () => const ResponsiveBreakpointSegment(
                  breakpoint: 0,
                  segmentType: ResponsiveBreakpointBehavior.TAG,
                  responsiveBreakpoint: ResponsiveBreakpoint.tag(0, name: '')))
          .breakpoint;

  ResponsiveBreakpoint? firstBreakpointNamed(String name) {
    try {
      return breakpointSegments
          .firstWhere((element) => element.responsiveBreakpoint.name == name)
          .responsiveBreakpoint;
    } on StateError {
      // ignore: empty_catches
    }

    return null;
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
  const InheritedResponsiveWrapper(
      {Key? key, required this.data, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedResponsiveWrapper oldWidget) =>
      data != oldWidget.data;
}

enum ResponsiveBreakpointBehavior {
  RESIZE,
  AUTOSCALE,
  AUTOSCALEDOWN,
  TAG,
}

/// Control the responsiveness of the app at a breakpoint.
///
/// Specify a responsive [behavior] at a [breakpoint]
/// value. The following behaviors are supported:
/// Resize - default behavior.
/// AutoScale - scales UI from breakpoint up.
/// AutoScaleDown - scales UI from breakpoint down and
/// from breakpoint up. Has the same behavior as AutoScale
/// but scales down as well.
/// Tag - named breakpoint value. Inherits behavior.
/// Add a [name] to a breakpoint for ease of reference.
/// The [scaleFactor] enlarges or shrinks the UI by a
/// multiple of x. This values can be applied to all
/// breakpoints.
@immutable
class ResponsiveBreakpoint {
  final double breakpoint;
  final String? name;
  final ResponsiveBreakpointBehavior behavior;
  final double scaleFactor;

  @visibleForTesting
  const ResponsiveBreakpoint(
      {required this.breakpoint,
      this.name,
      this.behavior = ResponsiveBreakpointBehavior.RESIZE,
      this.scaleFactor = 1});

  const ResponsiveBreakpoint.resize(this.breakpoint,
      {this.name, this.scaleFactor = 1})
      : behavior = ResponsiveBreakpointBehavior.RESIZE,
        assert(breakpoint >= 0,
            'Breakpoints cannot be negative. To control behavior from 0, set `default` parameters in `ResponsiveWrapper`.');

  const ResponsiveBreakpoint.autoScale(this.breakpoint,
      {this.name, this.scaleFactor = 1})
      : behavior = ResponsiveBreakpointBehavior.AUTOSCALE,
        assert(breakpoint >= 0,
            'Breakpoints cannot be negative. To control behavior from 0, set `default` parameters in `ResponsiveWrapper`.');

  const ResponsiveBreakpoint.autoScaleDown(this.breakpoint,
      {this.name, this.scaleFactor = 1})
      : behavior = ResponsiveBreakpointBehavior.AUTOSCALEDOWN,
        assert(breakpoint >= 0,
            'Breakpoints cannot be negative. To control behavior from 0, set `default` parameters in `ResponsiveWrapper`.');

  const ResponsiveBreakpoint.tag(this.breakpoint, {required String this.name})
      : behavior = ResponsiveBreakpointBehavior.TAG,
        scaleFactor = 1,
        assert(breakpoint >= 0,
            'Breakpoints cannot be negative. To control behavior from 0, set `default` parameters in `ResponsiveWrapper`.');

  get isResize => behavior == ResponsiveBreakpointBehavior.RESIZE;

  get isAutoScale => behavior == ResponsiveBreakpointBehavior.AUTOSCALE;

  get isAutoScaleDown => behavior == ResponsiveBreakpointBehavior.AUTOSCALEDOWN;

  get isTag => behavior == ResponsiveBreakpointBehavior.TAG;

  ResponsiveBreakpoint copyWith({
    double? breakpoint,
    String? name,
    ResponsiveBreakpointBehavior? behavior,
    double? scaleFactor,
  }) =>
      ResponsiveBreakpoint(
        breakpoint: breakpoint ?? this.breakpoint,
        name: name ?? this.name,
        behavior: behavior ?? this.behavior,
        scaleFactor: scaleFactor ?? this.scaleFactor,
      );

  /// Merge overwrite operation.
  ///
  /// Overwrite existing values with new values from
  /// [responsiveBreakpoint].
  ResponsiveBreakpoint merge(ResponsiveBreakpoint responsiveBreakpoint) {
    // Tag does not overwrite existing behavior.
    // Preserve existing values when merging.
    if (responsiveBreakpoint.isTag && !isTag) {
      return copyWith(name: responsiveBreakpoint.name ?? name);
    }
    return responsiveBreakpoint.copyWith(
        name: responsiveBreakpoint.name ?? name);
  }

  @override
  String toString() =>
      'ResponsiveBreakpoint(breakpoint: $breakpoint, name: $name, behavior: $behavior, scaleFactor: $scaleFactor)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponsiveBreakpoint &&
          runtimeType == other.runtimeType &&
          breakpoint == other.breakpoint &&
          name == other.name &&
          behavior == other.behavior &&
          scaleFactor == other.scaleFactor;

  @override
  int get hashCode =>
      breakpoint.hashCode *
      name.hashCode *
      behavior.hashCode *
      scaleFactor.hashCode;
}

/// Computed breakpoint segments.
///
/// Breakpoint segments are computed from
/// 0 to infinity. The [breakpoint] specifies the
/// start position for the [segmentType].
/// The [segmentType] specifies
/// the computed segment behavior.
/// The [responsiveBreakpoint] holds the active
/// breakpoint and controls the segment behavior.
@immutable
class ResponsiveBreakpointSegment {
  final double breakpoint;
  final ResponsiveBreakpointBehavior segmentType;
  final ResponsiveBreakpoint responsiveBreakpoint;

  @visibleForTesting
  const ResponsiveBreakpointSegment(
      {required this.breakpoint,
      required this.segmentType,
      required this.responsiveBreakpoint});

  get isResize => segmentType == ResponsiveBreakpointBehavior.RESIZE;

  get isAutoScale => segmentType == ResponsiveBreakpointBehavior.AUTOSCALE;

  get isAutoScaleDown =>
      segmentType == ResponsiveBreakpointBehavior.AUTOSCALEDOWN;

  get isTag => segmentType == ResponsiveBreakpointBehavior.TAG;

  ResponsiveBreakpointSegment copyWith({
    double? breakpoint,
    ResponsiveBreakpointBehavior? segmentType,
    ResponsiveBreakpoint? responsiveBreakpoint,
  }) =>
      ResponsiveBreakpointSegment(
        breakpoint: breakpoint ?? this.breakpoint,
        segmentType: segmentType ?? this.segmentType,
        responsiveBreakpoint: responsiveBreakpoint ?? this.responsiveBreakpoint,
      );

  /// Merge overwrite operation.
  ///
  /// Overwrite existing values with new values from
  /// [responsiveBreakpointSegment].
  /// If the new segment [isTag], do not overwrite
  /// existing segment values.
  ResponsiveBreakpointSegment merge(
      ResponsiveBreakpointSegment responsiveBreakpointSegment) {
    // Tag does not overwrite existing behavior.
    // Preserve existing values when merging.
    if (responsiveBreakpointSegment.isTag && !isTag) {
      return copyWith(
          responsiveBreakpoint: responsiveBreakpoint
              .merge(responsiveBreakpointSegment.responsiveBreakpoint));
    }
    // Overwrite existing values.
    return responsiveBreakpointSegment.copyWith(
        responsiveBreakpoint: responsiveBreakpoint
            .merge(responsiveBreakpointSegment.responsiveBreakpoint));
  }

  @override
  String toString() =>
      'ResponsiveBreakpointSegment(breakpoint: $breakpoint, segmentType: $segmentType, responsiveBreakpoint: $responsiveBreakpoint)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponsiveBreakpointSegment &&
          runtimeType == other.runtimeType &&
          breakpoint == other.breakpoint &&
          segmentType == other.segmentType &&
          responsiveBreakpoint == other.responsiveBreakpoint;

  @override
  int get hashCode =>
      breakpoint.hashCode *
      segmentType.hashCode *
      responsiveBreakpoint.hashCode;
}

/// Calculate breakpoint segments algorithm.
///
/// Complex logic to compute the  breakpoint segments
/// efficiently.
List<ResponsiveBreakpointSegment> getBreakpointSegments(
    List<ResponsiveBreakpoint> breakpoints,
    ResponsiveBreakpoint defaultBreakpoint) {
  // Mutable breakpoints holder.
  List<ResponsiveBreakpoint> breakpointsHolder = [];
  breakpointsHolder.addAll(breakpoints);
  // Breakpoint segments holder.
  List<ResponsiveBreakpointSegment> breakpointSegments = [];
  // No breakpoints. Create segment from default breakpoint behavior.
  if (breakpointsHolder.isEmpty) {
    breakpointSegments.add(ResponsiveBreakpointSegment(
        breakpoint: 0,
        segmentType: defaultBreakpoint.behavior,
        responsiveBreakpoint: defaultBreakpoint));
    return breakpointSegments;
  }

  List<ResponsiveBreakpoint> breakpointTags =
      breakpointsHolder.where((element) => element.isTag).toList();
  breakpointsHolder =
      breakpointsHolder.where((element) => !element.isTag).toList();

  // Min Width is passed through the default breakpoint.
  double minWidth = defaultBreakpoint.breakpoint;

  // Breakpoint overrides MinWidth default.
  ResponsiveBreakpoint? minWidthOverride = breakpointsHolder
      .firstWhereOrNull((element) => element.breakpoint == minWidth);
  if (minWidthOverride != null) {
    breakpointsHolder.insert(
        0,
        ResponsiveBreakpoint(
                breakpoint: minWidth,
                name: defaultBreakpoint.name,
                behavior: defaultBreakpoint.behavior,
                scaleFactor: defaultBreakpoint.scaleFactor)
            .merge(minWidthOverride));
  } else {
    // Add minWidth breakpoint. MinWidth generates
    // a breakpoint segment and needs to be added.
    breakpointsHolder.insert(
        0,
        ResponsiveBreakpoint(
            breakpoint: minWidth,
            name: defaultBreakpoint.name,
            behavior: defaultBreakpoint.behavior,
            scaleFactor: defaultBreakpoint.scaleFactor));
  }

  // Order breakpoints from smallest to largest.
  // Perform ordering operation to allow breakpoints
  // to be accepted in any order.
  breakpointsHolder.sort(ResponsiveUtils.breakpointComparator);
  breakpointTags.sort(ResponsiveUtils.breakpointComparator);

  // Find the first breakpoint behavior.
  ResponsiveBreakpoint initialBreakpoint = breakpointsHolder.first;

  // Breakpoint variable that holds the active behavior.
  // Used to calculate and remember the breakpoint behavior.
  ResponsiveBreakpoint breakpointHolder = ResponsiveBreakpoint(
      breakpoint: initialBreakpoint.breakpoint,
      name: defaultBreakpoint.name,
      behavior: defaultBreakpoint.behavior,
      scaleFactor: defaultBreakpoint.scaleFactor);

  // Construct initial segment that starts from 0.
  // Initial segment inherits default behavior.
  breakpointSegments.insert(
      0,
      ResponsiveBreakpointSegment(
          breakpoint: 0,
          segmentType: defaultBreakpoint.behavior,
          // Convert initial AutoScaleDown behavior to AutoScale.
          responsiveBreakpoint: breakpointHolder.copyWith(
              behavior: (initialBreakpoint.isAutoScaleDown)
                  ? ResponsiveBreakpointBehavior.AUTOSCALE
                  : defaultBreakpoint.behavior)));

  // A counter to keep track of the actual number of added breakpoints.
  // Needed because breakpoints are merged so not every
  // for-loop iteration adds a breakpoint segment.
  int breakpointCounter = 0;
  // Calculate segments from breakpoints.
  for (int i = 0; i < breakpointsHolder.length; i++) {
    // Convenience variable.
    ResponsiveBreakpoint breakpoint = breakpointsHolder[i];
    // Segment calculation holder.
    ResponsiveBreakpointSegment? breakpointSegmentHolder;
    switch (breakpoint.behavior) {
      case ResponsiveBreakpointBehavior.RESIZE:
      case ResponsiveBreakpointBehavior.AUTOSCALE:
        breakpointSegmentHolder = ResponsiveBreakpointSegment(
            breakpoint: breakpoint.breakpoint,
            segmentType: breakpoint.behavior,
            responsiveBreakpoint: breakpoint);
        break;
      case ResponsiveBreakpointBehavior.AUTOSCALEDOWN:
        // Construct override breakpoint segment.
        // AutoScaleDown needs to override the breakpoint
        // interval because responsive calculations are
        // performed from 0 - ∞.
        int overrideBreakpointIndex = breakpointCounter;
        ResponsiveBreakpointSegment overrideBreakpointSegment =
            breakpointSegments[overrideBreakpointIndex];
        overrideBreakpointSegment = overrideBreakpointSegment.copyWith(
            responsiveBreakpoint: overrideBreakpointSegment.responsiveBreakpoint
                .copyWith(
                    breakpoint: breakpoint.breakpoint,
                    behavior: ResponsiveBreakpointBehavior.AUTOSCALE));
        breakpointSegments[overrideBreakpointIndex] = overrideBreakpointSegment;

        // AutoScaleDown acts as an AutoScale breakpoint
        // in the 0 - ∞ direction.
        breakpointSegmentHolder = ResponsiveBreakpointSegment(
            breakpoint: breakpoint.breakpoint,
            segmentType: breakpoint.behavior,
            responsiveBreakpoint: ResponsiveBreakpoint(
                breakpoint: breakpoint.breakpoint,
                name: breakpoint.name,
                behavior: ResponsiveBreakpointBehavior.AUTOSCALE,
                scaleFactor: breakpoint.scaleFactor));
        break;
      case ResponsiveBreakpointBehavior.TAG:
        break;
    }
    // Update holder with active breakpoint
    breakpointHolder = breakpoint;
    // Merge duplicate segments.
    // Compare current segment to previous segment.
    if (breakpointSegments.last.breakpoint ==
        breakpointSegmentHolder!.breakpoint) {
      breakpointSegments[breakpointSegments.length - 1] =
          breakpointSegments.last.merge(breakpointSegmentHolder);
      continue;
    }
    breakpointSegments.add(breakpointSegmentHolder);
    breakpointCounter += 1;
  }

  // Add tags to segments.
  for (int i = 0; i < breakpointTags.length; i++) {
    // Convenience variable.
    ResponsiveBreakpoint breakpointTag = breakpointTags[i];
    ResponsiveBreakpointSegment breakpointSegmentHolder =
        breakpointSegments.reversed.firstWhere(
            (element) => element.breakpoint <= breakpointTag.breakpoint);
    int breakpointHolderIndex =
        breakpointSegments.indexOf(breakpointSegmentHolder);
    if (breakpointSegmentHolder.breakpoint == breakpointTag.breakpoint) {
      breakpointSegments[breakpointHolderIndex] = ResponsiveBreakpointSegment(
        breakpoint: breakpointSegmentHolder.breakpoint,
        segmentType: breakpointSegmentHolder.segmentType,
        responsiveBreakpoint:
            breakpointSegmentHolder.responsiveBreakpoint.merge(breakpointTag),
      );
    } else {
      breakpointSegments.insert(
        breakpointHolderIndex + 1,
        ResponsiveBreakpointSegment(
            breakpoint: breakpointTag.breakpoint,
            segmentType: breakpointTag.behavior,
            responsiveBreakpoint: breakpointSegmentHolder.responsiveBreakpoint
                .merge(breakpointTag)),
      );
    }
  }

  return breakpointSegments;
}
