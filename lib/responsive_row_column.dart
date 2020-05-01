import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class ResponsiveRowColumn extends StatelessWidget {
  final List<Widget> children;
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
                ...buildChildren(children, rowSpacing),
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
                ...buildChildren(children, columnSpacing),
              ],
            ),
          );
  }

  List<Widget> buildChildren(List<Widget> children, double spacing) {
    List<Widget> childrenList = [];
    for (int i = 0; i < children.length; i++) {
      childrenList.add(children[i]);
      if (spacing != null && i != children.length - 1)
        childrenList.add(Padding(padding: EdgeInsets.only(bottom: spacing)));
    }
    return childrenList;
  }
}

class ResponsiveFlexible extends StatelessWidget {
  final bool isFlexible;
  final int flex;
  final FlexFit flexFit;
  final Widget child;

  const ResponsiveFlexible(
      {Key key, this.isFlexible = false, this.flex, this.flexFit, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isFlexible
        ? Flexible(flex: flex, fit: flexFit, child: child)
        : child;
  }
}
