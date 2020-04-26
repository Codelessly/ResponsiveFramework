import 'package:flutter/widgets.dart';

import 'responsive_framework.dart';

typedef T Value<T>();
typedef StartListening<T> = VoidCallback Function(Value<T> element, T value);

class ResponsiveValue<T> {
  T value;
  String greaterThan = ">";
  String smallerThan = "<";
}

class ResponsiveVisibility extends StatefulWidget {
  final Widget child;
  final bool visible;
  final List<Condition> visibleWhen;
  final List<Condition> hiddenWhen;
  final Widget replacement;
  final bool maintainState;
  final bool maintainAnimation;
  final bool maintainSize;
  final bool maintainSemantics;
  final bool maintainInteractivity;

  const ResponsiveVisibility({
    Key key,
    @required this.child,
    this.visible = true,
    this.visibleWhen,
    this.hiddenWhen,
    this.replacement = const SizedBox.shrink(),
    this.maintainState = false,
    this.maintainAnimation = false,
    this.maintainSize = false,
    this.maintainSemantics = false,
    this.maintainInteractivity = false,
  }) : super(key: key);

  @override
  _ResponsiveVisibilityState createState() => _ResponsiveVisibilityState();
}

class _ResponsiveVisibilityState extends State<ResponsiveVisibility>
    with WidgetsBindingObserver {
  List<Condition> conditions = [];
  Condition activeCondition;
  bool visibleValue;

  void setDimensions() {
    // Breakpoint reference check. Verify a parent
    // [ResponsiveWrapper] exists if a reference is found.
    if (conditions.firstWhere((element) => element.name != null,
            orElse: () => null) !=
        null) {
      try {
        ResponsiveWrapper.of(context);
      } catch (e) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              "A ResponsiveCondition was caught referencing a nonexistant breakpoint."),
          ErrorDescription(
              "A ResponsiveCondition requires a parent ResponsiveWrapper "
              "to reference breakpoints. Add a ResponsiveWrapper or remove breakpoint references.")
        ]);
      }
    }

    // Find the active condition.
    activeCondition = getActiveCondition();
    // Set value to active condition value or default value if null.
    visibleValue = activeCondition?.value ?? widget.visible;
  }

  /// Set [activeCondition].
  /// The active condition is found by matching the
  /// search criteria in order of precedence:
  /// 1. [Conditional.EQUALS]
  /// Named breakpoints from a parent [ResponsiveWrapper].
  /// 2. [Conditional.SMALLER_THAN]
  ///   a. Named breakpoints.
  ///   b. Unnamed breakpoints.
  /// 3. [Conditional.LARGER_THAN]
  ///   a. Named breakpoints.
  ///   b. Unnamed breakpoints.
  /// Returns null if no Active Condition is found.
  Condition getActiveCondition() {
    Condition equalsCondition = conditions.firstWhere((element) {
      if (element.condition == Conditional.EQUALS) {
        return ResponsiveWrapper.of(context).activeBreakpoint?.name ==
            element.name;
      }

      return false;
    }, orElse: () => null);
    if (equalsCondition != null) {
      return equalsCondition;
    }

    Condition smallerThanCondition = conditions.firstWhere((element) {
      if (element.condition == Conditional.SMALLER_THAN) {
        if (element.name != null) {
          return ResponsiveWrapper.of(context).isSmallerThan(element.name);
        }

        return MediaQuery.of(context).size.width < element.breakpoint;
      }
      return false;
    }, orElse: () => null);
    if (smallerThanCondition != null) {
      return smallerThanCondition;
    }

    Condition largerThanCondition = conditions.reversed.firstWhere((element) {
      if (element.condition == Conditional.LARGER_THAN) {
        if (element.name != null) {
          return ResponsiveWrapper.of(context).isLargerThan(element.name);
        }

        return MediaQuery.of(context).size.width >= element.breakpoint;
      }
      return false;
    }, orElse: () => null);
    if (largerThanCondition != null) {
      return largerThanCondition;
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    // Initialize value.
    visibleValue = widget.visible;
    // Combine [ResponsiveCondition]s.
    conditions
        .addAll(widget.visibleWhen?.map((e) => e.copyWith(value: true)) ?? []);
    conditions
        .addAll(widget.hiddenWhen?.map((e) => e.copyWith(value: false)) ?? []);
    // Sort by breakpoint value.
    conditions.sort((a, b) => a.breakpoint.compareTo(b.breakpoint));

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setDimensions();
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(ResponsiveVisibility oldWidget) {
    super.didUpdateWidget(oldWidget);
    setDimensions();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: widget.child,
      replacement: widget.replacement,
      visible: visibleValue,
      maintainState: widget.maintainState,
      maintainAnimation: widget.maintainAnimation,
      maintainSize: widget.maintainSize,
      maintainSemantics: widget.maintainSemantics,
      maintainInteractivity: widget.maintainInteractivity,
    );
  }
}

enum Conditional {
  LARGER_THAN,
  EQUALS,
  SMALLER_THAN,
}

class Condition {
  final int breakpoint;
  final String name;
  final Conditional condition;
  final bool value;

  Condition._({this.breakpoint, this.name, this.condition, this.value})
      : assert(breakpoint != null || name != null),
        assert(breakpoint == null || name == null),
        assert((condition == Conditional.EQUALS) ? name != null : true);

  Condition.equals(String name, {bool value})
      : this.breakpoint = null,
        this.name = name,
        this.condition = Conditional.EQUALS,
        this.value = value;

  Condition.largerThan({int breakpoint, String name, bool value})
      : this.breakpoint = breakpoint ?? double.infinity,
        this.name = name,
        this.condition = Conditional.LARGER_THAN,
        this.value = value;

  Condition.smallerThan({int breakpoint, String name, bool value})
      : this.breakpoint = breakpoint ?? double.negativeInfinity,
        this.name = name,
        this.condition = Conditional.SMALLER_THAN,
        this.value = value;

  Condition copyWith({
    int breakpoint,
    String name,
    Conditional condition,
    bool value,
  }) =>
      Condition._(
        breakpoint: breakpoint ?? this.breakpoint,
        name: name ?? this.name,
        condition: condition ?? this.condition,
        value: value ?? this.value,
      );

  @override
  String toString() =>
      "Condition(" +
      "breakpoint: " +
      breakpoint.toString() +
      ", name: " +
      name.toString() +
      ", condition: " +
      condition.toString() +
      ", value: " +
      value?.toString() +
      ")";

  int sort(Condition a, Condition b) {
    if (a.breakpoint == b.breakpoint) return 0;

    return (a.breakpoint < b.breakpoint) ? -1 : 1;
  }
}
