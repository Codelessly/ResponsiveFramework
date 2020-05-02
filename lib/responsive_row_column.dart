import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class ResponsiveRowColumn extends StatelessWidget {
  final List<ResponsiveRowColumnItem> children;
  final isRow;
  final isColumn;
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
    assert(isRow != null || isColumn != null);
    assert(!(isRow != null && isColumn != null),
        "isRow and isColumn are mutually exclusive and cannot be used simultaneously.");
    bool rowColumn;
    if (isRow != null) {
      rowColumn = isRow;
    }
    if (isColumn != null) {
      rowColumn = !isColumn;
    }
    print('Row Column: $rowColumn');
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

  List<ResponsiveRowColumnItem> buildChildren(
      List<ResponsiveRowColumnItem> children, bool rowColumn, double spacing) {
    List<ResponsiveRowColumnItem> childrenHolder = children;
    childrenHolder.sort((a, b) {
      if (rowColumn) {
        return a.rowOrder.compareTo(b.rowOrder);
      } else {
        return a.columnOrder.compareTo(b.columnOrder);
      }
    });
    List<Widget> widgetList = childrenHolder;
    for (int i = 0; i < children.length; i++) {
      widgetList.add(children[i]);
      if (spacing != null && i != children.length - 1)
        widgetList.add(Padding(padding: EdgeInsets.only(bottom: spacing)));
    }
    return widgetList;
  }
}

class ResponsiveRowColumnItem extends StatelessWidget {
  final Widget child;
  final int rowOrder;
  final int columnOrder;
  final bool isFlexible;
  final int flex;
  final FlexFit flexFit;

  const ResponsiveRowColumnItem(
      {Key key,
      @required this.child,
      this.rowOrder,
      this.columnOrder,
      this.isFlexible = false,
      this.flex,
      this.flexFit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isFlexible
        ? Flexible(flex: flex, fit: flexFit, child: child)
        : child;
  }
}
