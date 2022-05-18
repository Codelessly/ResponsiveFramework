// ignore_for_file: constant_identifier_names

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/widgets.dart';

import 'responsive_framework.dart';

/// Conditional values based on the active breakpoint.
///
/// Get a [value] that corresponds to active breakpoint
/// determined by [Condition]s set in [valueWhen].
/// Set a [defaultValue] for when no condition is
/// active. Requires a parent [context] that contains
/// a [ResponsiveWrapper].
///
/// No validation is performed on [Condition]s so
/// valid conditions must be passed.
class ResponsiveValue<T> {
  T? value;
  final T defaultValue;
  final List<Condition<T>> valueWhen;

  final BuildContext context;

  ResponsiveValue(this.context,
      {required this.defaultValue, required this.valueWhen}) {
    // Breakpoint reference check. Verify a parent
    // [ResponsiveWrapper] exists if a reference is found.
    if (valueWhen.firstWhereOrNull((element) => element.name != null) != null) {
      try {
        ResponsiveWrapper.of(context);
      } catch (e) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'A ResponsiveCondition was caught referencing a nonexistant breakpoint.'),
          ErrorDescription(
              'A ResponsiveCondition requires a parent ResponsiveWrapper '
              'to reference breakpoints. Add a ResponsiveWrapper or remove breakpoint references.')
        ]);
      }
    }

    List<Condition> conditions = [];
    conditions.addAll(valueWhen);
    List<ResponsiveBreakpointSegment>? segments =
        ResponsiveWrapper.of(context).breakpointSegments;
    conditions = conditions.map((e) {
      if (e.breakpoint == null) {
        return e.copyWith(
            breakpoint: segments
                .firstWhere(
                    (element) => element.responsiveBreakpoint.name == e.name,
                    orElse: () =>
                        throw ('No breakpoint named `${e.name}` found.'))
                .responsiveBreakpoint
                .breakpoint
                .toInt());
      }
      return e;
    }).toList();
    conditions.sort((a, b) => a.breakpoint!.compareTo(b.breakpoint!));
    // Get visible value from active condition.
    value = getValue(context, conditions) ?? defaultValue;
  }

  T? getValue(BuildContext context, List<Condition> conditions) {
    // Find the active condition.
    Condition? activeCondition = getActiveCondition(context, conditions);
    if (activeCondition == null) return null;
    // Return landscape value if orientation is landscape and landscape override value is provided.
    if (ResponsiveWrapper.of(context).orientation == Orientation.landscape &&
        activeCondition.landscapeValue != null) {
      return activeCondition.landscapeValue;
    }
    // Return active condition value or default value if null.
    return activeCondition.value;
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
  Condition? getActiveCondition(
      BuildContext context, List<Condition> conditions) {
    Condition? equalsCondition = conditions.firstWhereOrNull((element) {
      if (element.condition == Conditional.EQUALS) {
        return ResponsiveWrapper.of(context).activeBreakpoint.name ==
            element.name;
      }

      return false;
    });
    if (equalsCondition != null) {
      return equalsCondition;
    }

    Condition? smallerThanCondition = conditions.firstWhereOrNull((element) {
      if (element.condition == Conditional.SMALLER_THAN) {
        if (element.name != null) {
          return ResponsiveWrapper.of(context).isSmallerThan(element.name!);
        }

        return MediaQuery.of(context).size.width < element.breakpoint!;
      }
      return false;
    });
    if (smallerThanCondition != null) {
      return smallerThanCondition;
    }

    Condition? largerThanCondition =
        conditions.reversed.firstWhereOrNull((element) {
      if (element.condition == Conditional.LARGER_THAN) {
        if (element.name != null) {
          return ResponsiveWrapper.of(context).isLargerThan(element.name);
        }

        return MediaQuery.of(context).size.width >= element.breakpoint!;
      }
      return false;
    });
    if (largerThanCondition != null) {
      return largerThanCondition;
    }

    return null;
  }
}

/// Internal equality comparators.
enum Conditional {
  LARGER_THAN,
  EQUALS,
  SMALLER_THAN,
}

/// A conditional value provider.
///
/// Provides the [value] when the [condition] is active.
/// Compare conditions by setting either [breakpoint] or
/// [name] values.
class Condition<T> {
  final int? breakpoint;
  final String? name;
  final Conditional? condition;
  final T? value;
  final T? landscapeValue;

  const Condition._(
      {this.breakpoint,
      this.name,
      this.condition,
      this.value,
      this.landscapeValue})
      : assert(breakpoint != null || name != null),
        assert((condition == Conditional.EQUALS) ? name != null : true);

  const Condition.equals({required this.name, this.value, this.landscapeValue})
      : breakpoint = null,
        condition = Conditional.EQUALS;

  const Condition.largerThan(
      {this.breakpoint, this.name, this.value, this.landscapeValue})
      : condition = Conditional.LARGER_THAN;

  const Condition.smallerThan(
      {this.breakpoint, this.name, this.value, this.landscapeValue})
      : condition = Conditional.SMALLER_THAN;

  Condition copyWith({
    int? breakpoint,
    String? name,
    Conditional? condition,
    T? value,
    T? landscapeValue,
  }) =>
      Condition._(
        breakpoint: breakpoint ?? this.breakpoint,
        name: name ?? this.name,
        condition: condition ?? this.condition,
        value: value ?? this.value,
        landscapeValue: landscapeValue ?? this.value,
      );

  @override
  String toString() =>
      'Condition(breakpoint: $breakpoint, name: $name, condition: $condition, value: $value, landscapeValue: $landscapeValue)';

  int sort(Condition a, Condition b) {
    if (a.breakpoint == b.breakpoint) return 0;

    return (a.breakpoint! < b.breakpoint!) ? -1 : 1;
  }
}

/// A convenience wrapper for responsive [Visibility].
///
/// ResponsiveVisibility accepts [Condition]s in
/// [visibleWhen] and [hiddenWhen] convenience
/// fields. The [child] widget is [visible] by default.
class ResponsiveVisibility extends StatelessWidget {
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
    Key? key,
    required this.child,
    this.visible = true,
    this.visibleWhen = const [],
    this.hiddenWhen = const [],
    this.replacement = const SizedBox.shrink(),
    this.maintainState = false,
    this.maintainAnimation = false,
    this.maintainSize = false,
    this.maintainSemantics = false,
    this.maintainInteractivity = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize mutable value holders.
    List<Condition> conditions = [];
    bool? visibleValue = visible;

    // Combine Conditions.
    conditions.addAll(visibleWhen.map((e) => e.copyWith(value: true)));
    conditions.addAll(hiddenWhen.map((e) => e.copyWith(value: false)));
    // Get visible value from active condition.
    visibleValue = ResponsiveValue(context,
            defaultValue: visibleValue, valueWhen: conditions)
        .value;

    return Visibility(
      replacement: replacement,
      visible: visibleValue!,
      maintainState: maintainState,
      maintainAnimation: maintainAnimation,
      maintainSize: maintainSize,
      maintainSemantics: maintainSemantics,
      maintainInteractivity: maintainInteractivity,
      child: child,
    );
  }
}

class ResponsiveConstraints extends StatelessWidget {
  final Widget child;
  final BoxConstraints? constraint;
  final List<Condition> constraintsWhen;

  const ResponsiveConstraints(
      {Key? key,
      required this.child,
      this.constraint,
      this.constraintsWhen = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize mutable value holders.
    BoxConstraints? constraintValue = constraint;
    // Get value from active condition.
    constraintValue = ResponsiveValue(context,
            defaultValue: constraintValue, valueWhen: constraintsWhen)
        .value;

    return Container(
      constraints: constraintValue,
      child: child,
    );
  }
}
