import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

/// A convenience wrapper for responsive [Row] and
/// [Column] switching with padding and spacing.
///
/// ResponsiveRowColumn combines responsiveness
/// behaviors for managing rows and columns into one
/// convenience widget. This widget requires all [children]
/// to be [ResponsiveRowColumnItem] widgets.
/// Row vs column layout is controlled by [rowColumn].
/// RowColumn is Row layout when true and Column
/// layout when false.
/// Add spacing between widgets with [rowSpacing] and
/// [columnSpacing]. Add padding around widgets with
/// [rowPadding] and [columnPadding].
///
/// See [ResponsiveRowColumnItem] for [Flex] and
/// [FlexFit] options.
class ResponsiveRowColumn extends StatelessWidget {
  final List<ResponsiveRowColumnItem> children;
  final bool rowColumn;
  final MainAxisAlignment rowMainAxisAlignment;
  final MainAxisSize rowMainAxisSize;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final TextDirection rowTextDirection;
  final VerticalDirection rowVerticalDirection;
  final TextBaseline rowTextBaseline;
  final MainAxisAlignment columnMainAxisAlignment;
  final MainAxisSize columnMainAxisSize;
  final CrossAxisAlignment columnCrossAxisAlignment;
  final TextDirection columnTextDirection;
  final VerticalDirection columnVerticalDirection;
  final TextBaseline columnTextBaseline;
  final double rowSpacing;
  final double columnSpacing;
  final EdgeInsets rowPadding;
  final EdgeInsets columnPadding;
  get isRow => rowColumn;
  get isColumn => !rowColumn;

  const ResponsiveRowColumn(
      {Key key,
      this.children = const [],
      @required this.rowColumn,
      this.rowMainAxisAlignment = MainAxisAlignment.start,
      this.rowMainAxisSize = MainAxisSize.max,
      this.rowCrossAxisAlignment = CrossAxisAlignment.center,
      this.rowTextDirection,
      this.rowVerticalDirection = VerticalDirection.down,
      this.rowTextBaseline,
      this.columnMainAxisAlignment = MainAxisAlignment.start,
      this.columnMainAxisSize = MainAxisSize.max,
      this.columnCrossAxisAlignment = CrossAxisAlignment.center,
      this.columnTextDirection,
      this.columnVerticalDirection = VerticalDirection.down,
      this.columnTextBaseline,
      this.rowSpacing,
      this.columnSpacing,
      this.rowPadding = EdgeInsets.zero,
      this.columnPadding = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return rowColumn
        ? Padding(
            padding: rowPadding,
            child: Row(
              mainAxisAlignment: rowMainAxisAlignment,
              mainAxisSize: rowMainAxisSize,
              crossAxisAlignment: rowCrossAxisAlignment,
              textDirection: rowTextDirection,
              verticalDirection: rowVerticalDirection,
              textBaseline: rowTextBaseline,
              children: [
                ...buildChildren(children, rowColumn, rowSpacing),
              ],
            ),
          )
        : Padding(
            padding: columnPadding,
            child: Column(
              mainAxisAlignment: columnMainAxisAlignment,
              mainAxisSize: columnMainAxisSize,
              crossAxisAlignment: columnCrossAxisAlignment,
              textDirection: columnTextDirection,
              verticalDirection: columnVerticalDirection,
              textBaseline: columnTextBaseline,
              children: [
                ...buildChildren(children, rowColumn, columnSpacing),
              ],
            ),
          );
  }

  /// Logic to construct widget [children].
  List<Widget> buildChildren(
      List<ResponsiveRowColumnItem> children, bool rowColumn, double spacing) {
    // Sort ResponsiveRowColumnItems by their order.
    List<ResponsiveRowColumnItem> childrenHolder = children;
    childrenHolder.sort((a, b) {
      if (rowColumn) {
        return a.rowOrder.compareTo(b.rowOrder);
      } else {
        return a.columnOrder.compareTo(b.columnOrder);
      }
    });
    // Add padding between widgets..
    List<Widget> widgetList = [];
    for (int i = 0; i < childrenHolder.length; i++) {
      widgetList.add(childrenHolder[i].copyWith(rowColumn: rowColumn));
      if (spacing != null && i != childrenHolder.length - 1)
        widgetList.add(Padding(
            padding: rowColumn
                ? EdgeInsets.only(right: spacing)
                : EdgeInsets.only(bottom: spacing)));
    }
    return widgetList;
  }
}

/// A wrapper for [ResponsiveRowColumn] children with
/// responsiveness.
///
/// Control the order of widgets within [ResponsiveRowColumn]
/// by assigning a [rowOrder] or [columnOrder] value.
/// Widgets without an order value are ranked behind
/// those with order values.
/// Set a widget's [Flex] value through [rowFlex] and
/// [columnFlex]. Set a widget's [FlexFit] through
/// [rowFit] and [columnFit].
class ResponsiveRowColumnItem extends StatelessWidget {
  final Widget child;
  final int rowOrder;
  final int columnOrder;
  final bool rowColumn;
  final int rowFlex;
  final int columnFlex;
  final FlexFit rowFit;
  final FlexFit columnFit;

  const ResponsiveRowColumnItem(
      {Key key,
      @required this.child,
      this.rowOrder = 1073741823,
      this.columnOrder = 1073741823,
      this.rowColumn = true,
      this.rowFlex,
      this.columnFlex,
      this.rowFit,
      this.columnFit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rowColumn && (rowFlex != null || rowFit != null)) {
      return Flexible(
          flex: rowFlex ?? 1, fit: rowFit ?? FlexFit.loose, child: child);
    } else if (!rowColumn && (columnFlex != null || columnFit != null)) {
      return Flexible(
          flex: columnFlex ?? 1, fit: columnFit ?? FlexFit.loose, child: child);
    }

    return child;
  }

  ResponsiveRowColumnItem copyWith({
    Widget child,
    int rowOrder,
    int columnOrder,
    bool rowColumn,
    int rowFlex,
    int columnFlex,
    FlexFit rowFlexFit,
    FlexFit columnFlexFit,
  }) =>
      ResponsiveRowColumnItem(
        child: child ?? this.child,
        rowOrder: rowOrder ?? this.rowOrder,
        columnOrder: columnOrder ?? this.columnOrder,
        rowColumn: rowColumn ?? this.rowColumn,
        rowFlex: rowFlex ?? this.rowFlex,
        columnFlex: columnFlex ?? this.columnFlex,
        rowFit: rowFlexFit ?? this.rowFit,
        columnFit: columnFlexFit ?? this.columnFit,
      );
}
