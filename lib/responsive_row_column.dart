import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class ResponsiveRowColumn extends StatelessWidget {
  final List<ResponsiveRowColumnItem> children;
  final bool isRow;
  final bool isColumn;
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
  final bool fillRow;

  const ResponsiveRowColumn(
      {Key key,
      this.children = const [],
      this.isRow,
      this.isColumn,
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
      this.fillRow = false,
      this.rowPadding = EdgeInsets.zero,
      this.columnPadding = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(isRow != null || isColumn != null,
        "Missing default isRow or isColumn value.");
    assert(!(isRow != null && isColumn != null),
        "isRow and isColumn are mutually exclusive and cannot be used simultaneously.");
    bool rowColumn;
    if (isRow != null) {
      rowColumn = isRow;
    }
    if (isColumn != null) {
      rowColumn = !isColumn;
    }
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
    // Add padding between items.
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
    if (rowColumn && rowFlex != null) {
      return Flexible(flex: rowFlex, fit: rowFit, child: child);
    } else if (!rowColumn && columnFlex != null) {
      return Flexible(flex: columnFlex, fit: columnFit, child: child);
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
