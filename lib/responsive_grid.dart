import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A GridView with responsive capabilities.
///
/// ResponsiveGridView extends [GridView] with
/// a custom [ResponsiveGridDelegate] [gridDelegate]
/// that adds more grid layout controls.
/// See [ResponsiveGridDelegate] for shrink and
/// fixed item size options.
/// Additional customization parameters [alignment]
/// and [maxRowCount] adds the ability to align
/// items and limit items in a row.
class ResponsiveGridView extends StatelessWidget {
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;

  /// Align grid items together as a group.
  final AlignmentGeometry alignment;

  /// A custom [SliverGridDelegate] with item size control.
  final ResponsiveGridDelegate gridDelegate;
  final IndexedWidgetBuilder itemBuilder;
  final int? itemCount;
  final int? maxRowCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final Clip clipBehavior;
  final String? restorationId;

  const ResponsiveGridView.builder({
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.alignment = Alignment.centerLeft,
    required this.gridDelegate,
    required this.itemBuilder,
    this.itemCount,
    this.maxRowCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder provides constraints required for item sizing calculation.
    return LayoutBuilder(builder: (context, constraints) {
      // A padding calculation variable that resolves null
      // to a temporary zero value. The original null padding
      // must be preserved for the [BoxScrollView] to calculate
      // an effective padding with SafeArea. Create a
      // temporary variable here to avoid overwriting null.
      EdgeInsets paddingHolder = padding as EdgeInsets? ?? EdgeInsets.zero;
      // The maximum number of items that can fit on one row.
      int crossAxisCount;
      // The maximum number of items that fit under the max row count.
      int? maxItemCount;
      // Manual padding adjustment for alignment.
      EdgeInsetsGeometry alignmentPadding;
      // The width of all items and padding.
      double crossAxisWidth;
      // The maximum width available for items.
      double crossAxisExtent = constraints.maxWidth - paddingHolder.horizontal;
      assert(crossAxisExtent > 0,
          '$paddingHolder exceeds layout width (${constraints.maxWidth})');
      // Switch between grid delegate behavior.
      if (gridDelegate.crossAxisExtent != null) {
        // Fixed item size.
        crossAxisCount = (crossAxisExtent /
                (gridDelegate.crossAxisExtent! + gridDelegate.crossAxisSpacing))
            .floor();
        crossAxisWidth = crossAxisCount *
                (gridDelegate.crossAxisExtent! +
                    gridDelegate.crossAxisSpacing) +
            paddingHolder.horizontal;
      } else if (gridDelegate.maxCrossAxisExtent != null) {
        // Max item size.
        crossAxisCount = (crossAxisExtent /
                (gridDelegate.maxCrossAxisExtent! +
                    gridDelegate.crossAxisSpacing))
            .ceil();
        final double usableCrossAxisExtent = crossAxisExtent -
            gridDelegate.crossAxisSpacing * (crossAxisCount - 1);
        final double childCrossAxisExtent =
            usableCrossAxisExtent / crossAxisCount;
        crossAxisWidth = crossAxisCount *
                (childCrossAxisExtent + gridDelegate.crossAxisSpacing) +
            paddingHolder.horizontal;
      } else {
        // Min item size.
        crossAxisCount = (crossAxisExtent /
                (gridDelegate.minCrossAxisExtent! +
                    gridDelegate.crossAxisSpacing))
            .floor();
        final double usableCrossAxisExtent = crossAxisExtent -
            gridDelegate.crossAxisSpacing * (crossAxisCount - 1);
        final double childCrossAxisExtent =
            usableCrossAxisExtent / crossAxisCount;
        crossAxisWidth = crossAxisCount *
                (childCrossAxisExtent + gridDelegate.crossAxisSpacing) +
            paddingHolder.horizontal;
      }
      // Calculate padding adjustment for alignment.
      if (alignment == Alignment.centerLeft ||
          alignment == Alignment.topLeft ||
          alignment == Alignment.bottomLeft) {
        // Align left, no padding.
        alignmentPadding = const EdgeInsets.only(left: 0);
      } else if (alignment == Alignment.center ||
          alignment == Alignment.topCenter ||
          alignment == Alignment.bottomCenter) {
        // Align center, divide remaining space between left and right
        // after subtracting last item spacing padding.
        double paddingCalc = constraints.maxWidth - crossAxisWidth;
        if (paddingCalc <= 0) {
          // There is no additional space. No padding.
          alignmentPadding = const EdgeInsets.only(left: 0);
        } else if (paddingCalc > gridDelegate.crossAxisSpacing) {
          // There is enough room to center items correctly.
          // Add padding equivalent to the last item to the first item.
          // Then split the remaining space.
          alignmentPadding = EdgeInsets.only(
              left: ((constraints.maxWidth -
                          crossAxisWidth -
                          gridDelegate.crossAxisSpacing) /
                      2) +
                  gridDelegate.crossAxisSpacing);
        } else {
          // There is not enough space to correctly center items.
          // Add all remaining space to left padding.
          alignmentPadding = EdgeInsets.only(left: paddingCalc);
        }
      } else {
        // Align right, add all remaining space to left padding.
        alignmentPadding =
            EdgeInsets.only(left: constraints.maxWidth - crossAxisWidth);
      }
      // Force row limit by calculating item limit.
      if (maxRowCount != null) {
        maxItemCount = maxRowCount! * crossAxisCount;
      }
      // Internal children builder delegate.
      SliverChildDelegate childrenDelegate = SliverChildBuilderDelegate(
          itemBuilder,
          childCount: maxItemCount ?? itemCount,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes);
      return Container(
        padding: alignmentPadding,
        child: _ResponsiveGridViewLayout(
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          gridDelegate: gridDelegate,
          childrenDelegate: childrenDelegate,
          itemCount: itemCount,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          clipBehavior: clipBehavior,
          restorationId: restorationId,
        ),
      );
    });
  }
}

/// Internal [SliverGridLayout] implementation.
class _ResponsiveGridViewLayout extends BoxScrollView {
  final ResponsiveGridDelegate gridDelegate;
  final SliverChildDelegate childrenDelegate;
  final int? itemCount;

  const _ResponsiveGridViewLayout({
    Key? key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    required this.gridDelegate,
    required this.childrenDelegate,
    this.itemCount,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  }) : super(
          key: key,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount ?? itemCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );

  @override
  Widget buildChildLayout(BuildContext context) {
    return SliverGrid(
      delegate: childrenDelegate,
      gridDelegate: gridDelegate,
    );
  }
}

/// A [SliverGridDelegate] with item sizing control.
///
/// Set a fixed item size by setting the [crossAxisExtent].
/// Set the maximum item size with [maxCrossAxisExtent].
/// Set the minimum item size with [minCrossAxisExtent].
/// One and only one cross axis extent is required.
class ResponsiveGridDelegate extends SliverGridDelegate {
  const ResponsiveGridDelegate({
    this.crossAxisExtent,
    this.maxCrossAxisExtent,
    this.minCrossAxisExtent,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1,
  })  : assert(
            (crossAxisExtent != null && crossAxisExtent >= 0) ||
                (maxCrossAxisExtent != null && maxCrossAxisExtent >= 0) ||
                (minCrossAxisExtent != null && minCrossAxisExtent >= 0),
            'Must provide a valid cross axis extent.'),
        assert(mainAxisSpacing >= 0),
        assert(crossAxisSpacing >= 0),
        assert(childAspectRatio > 0);

  /// Fixed item size.
  final double? crossAxisExtent;

  /// Maximum item size.
  final double? maxCrossAxisExtent;

  /// Minimum item size.
  final double? minCrossAxisExtent;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  bool _debugAssertIsValid(double crossAxisExtent) {
    assert(crossAxisExtent > 0.0);
    assert(mainAxisSpacing >= 0.0);
    assert(crossAxisSpacing >= 0.0);
    assert(childAspectRatio > 0.0);
    return true;
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    assert(_debugAssertIsValid(constraints.crossAxisExtent));
    // The maximum number of items that can fit on one row.
    int crossAxisCount;
    // Item height with padding.
    double mainAxisStride;
    // Item width with padding.
    double crossAxisStride;
    // Item height.
    double childMainAxisExtent;
    // Item width.
    double? childCrossAxisExtent;
    // Switch between item sizing behaviors.
    if (crossAxisExtent != null) {
      crossAxisCount =
          (constraints.crossAxisExtent / (crossAxisExtent! + crossAxisSpacing))
              .floor();
      childCrossAxisExtent = crossAxisExtent;
      childMainAxisExtent = childCrossAxisExtent! / childAspectRatio;
      mainAxisStride = childMainAxisExtent + mainAxisSpacing;
      crossAxisStride = childCrossAxisExtent + crossAxisSpacing;
    } else if (maxCrossAxisExtent != null) {
      crossAxisCount = (constraints.crossAxisExtent /
              (maxCrossAxisExtent! + crossAxisSpacing))
          .ceil();
      final double usableCrossAxisExtent =
          constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1);
      childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
      childMainAxisExtent = childCrossAxisExtent / childAspectRatio;
      mainAxisStride = childMainAxisExtent + mainAxisSpacing;
      crossAxisStride = childCrossAxisExtent + crossAxisSpacing;
    } else {
      crossAxisCount = (constraints.crossAxisExtent /
              (minCrossAxisExtent! + crossAxisSpacing))
          .floor();
      final double usableCrossAxisExtent =
          constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1);
      childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
      childMainAxisExtent = childCrossAxisExtent / childAspectRatio;
      mainAxisStride = childMainAxisExtent + mainAxisSpacing;
      crossAxisStride = childCrossAxisExtent + crossAxisSpacing;
    }
    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: mainAxisStride,
      crossAxisStride: crossAxisStride,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(ResponsiveGridDelegate oldDelegate) {
    return oldDelegate.crossAxisExtent != crossAxisExtent ||
        oldDelegate.maxCrossAxisExtent != maxCrossAxisExtent ||
        oldDelegate.minCrossAxisExtent != minCrossAxisExtent ||
        oldDelegate.mainAxisSpacing != mainAxisSpacing ||
        oldDelegate.crossAxisSpacing != crossAxisSpacing ||
        oldDelegate.childAspectRatio != childAspectRatio;
  }
}
