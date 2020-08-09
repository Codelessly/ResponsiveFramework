import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ResponsiveGridView extends StatelessWidget {
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController controller;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final ResponsiveGridDelegate gridDelegate;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final int maxRowCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double cacheExtent;
  final int semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  ResponsiveGridView.builder({
    Key key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.alignment = Alignment.centerLeft,
    @required this.gridDelegate,
    @required this.itemBuilder,
    this.itemCount,
    this.maxRowCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  }) : assert(gridDelegate != null);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount;
      int maxItemCount;
      EdgeInsetsGeometry alignmentPadding;
      double crossAxisWidth;
      double crossAxisExtent = constraints.maxWidth - padding.horizontal;
      assert(crossAxisExtent > 0,
          '$padding exceeds layout width (${constraints.maxWidth})');
      if (gridDelegate.crossAxisExtent != null) {
        crossAxisCount = (crossAxisExtent /
                (gridDelegate.crossAxisExtent + gridDelegate.crossAxisSpacing))
            .floor();
        crossAxisWidth = crossAxisCount *
                (gridDelegate.crossAxisExtent + gridDelegate.crossAxisSpacing) +
            padding.horizontal;
      } else if (gridDelegate.maxCrossAxisExtent != null) {
        crossAxisCount = (crossAxisExtent /
                (gridDelegate.maxCrossAxisExtent +
                    gridDelegate.crossAxisSpacing))
            .ceil();
        final double usableCrossAxisExtent = crossAxisExtent -
            gridDelegate.crossAxisSpacing * (crossAxisCount - 1);
        final double childCrossAxisExtent =
            usableCrossAxisExtent / crossAxisCount;
        crossAxisWidth = crossAxisCount *
                (childCrossAxisExtent + gridDelegate.crossAxisSpacing) +
            padding.horizontal;
      } else {
        crossAxisCount = (crossAxisExtent /
                (gridDelegate.minCrossAxisExtent +
                    gridDelegate.crossAxisSpacing))
            .floor();
        final double usableCrossAxisExtent = crossAxisExtent -
            gridDelegate.crossAxisSpacing * (crossAxisCount - 1);
        final double childCrossAxisExtent =
            usableCrossAxisExtent / crossAxisCount;
        crossAxisWidth = crossAxisCount *
                (childCrossAxisExtent + gridDelegate.crossAxisSpacing) +
            padding.horizontal;
      }
      if (alignment == Alignment.centerLeft ||
          alignment == Alignment.topLeft ||
          alignment == Alignment.bottomLeft) {
        alignmentPadding = EdgeInsets.only(left: 0);
      } else if (alignment == Alignment.center ||
          alignment == Alignment.topCenter ||
          alignment == Alignment.bottomCenter) {
        double paddingCalc = constraints.maxWidth - crossAxisWidth;
        if (paddingCalc <= 0) {
          alignmentPadding = EdgeInsets.only(left: 0);
        } else if (paddingCalc > gridDelegate.crossAxisSpacing) {
          alignmentPadding = EdgeInsets.only(
              left: ((constraints.maxWidth -
                          crossAxisWidth -
                          gridDelegate.crossAxisSpacing) /
                      2) +
                  gridDelegate.crossAxisSpacing);
        } else {
          alignmentPadding = EdgeInsets.only(left: paddingCalc);
        }
      } else {
        alignmentPadding =
            EdgeInsets.only(left: constraints.maxWidth - crossAxisWidth);
      }
      if (maxRowCount != null) {
        maxItemCount = maxRowCount * crossAxisCount;
      }
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
          itemBuilder: itemBuilder,
          itemCount: itemCount,
          maxRowCount: maxRowCount,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
        ),
      );
    });
  }
}

class _ResponsiveGridViewLayout extends BoxScrollView {
  final ResponsiveGridDelegate gridDelegate;
  final SliverChildDelegate childrenDelegate;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final int maxRowCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;

  _ResponsiveGridViewLayout({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    @required this.gridDelegate,
    @required this.childrenDelegate,
    @required this.itemBuilder,
    this.itemCount,
    this.maxRowCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    double cacheExtent,
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
  })  : assert(gridDelegate != null),
        super(
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
        );

  @override
  Widget buildChildLayout(BuildContext context) {
    return SliverGrid(
      delegate: childrenDelegate,
      gridDelegate: gridDelegate,
    );
  }
}

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
        assert(mainAxisSpacing != null && mainAxisSpacing >= 0),
        assert(crossAxisSpacing != null && crossAxisSpacing >= 0),
        assert(childAspectRatio != null && childAspectRatio > 0);

  final double crossAxisExtent;
  final double maxCrossAxisExtent;
  final double minCrossAxisExtent;
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
    int crossAxisCount;
    double mainAxisStride;
    double crossAxisStride;
    double childMainAxisExtent;
    double childCrossAxisExtent;
    if (this.crossAxisExtent != null) {
      crossAxisCount =
          (constraints.crossAxisExtent / (crossAxisExtent + crossAxisSpacing))
              .floor();
      childCrossAxisExtent = crossAxisExtent;
      childMainAxisExtent = childCrossAxisExtent / childAspectRatio;
      mainAxisStride = childMainAxisExtent + mainAxisSpacing;
      crossAxisStride = childCrossAxisExtent + crossAxisSpacing;
    } else if (this.maxCrossAxisExtent != null) {
      crossAxisCount = (constraints.crossAxisExtent /
              (maxCrossAxisExtent + crossAxisSpacing))
          .ceil();
      final double usableCrossAxisExtent =
          constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1);
      childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
      childMainAxisExtent = childCrossAxisExtent / childAspectRatio;
      mainAxisStride = childMainAxisExtent + mainAxisSpacing;
      crossAxisStride = childCrossAxisExtent + crossAxisSpacing;
    } else {
      crossAxisCount = (constraints.crossAxisExtent /
              (minCrossAxisExtent + crossAxisSpacing))
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
