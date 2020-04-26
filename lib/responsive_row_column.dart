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
  final EdgeInsets rowSpacing;
  final EdgeInsets columnSpacing;
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
      this.fillRow = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(isRow != null || isColumn != null);
    assert(!(isRow == true && isColumn == true));
    bool rowColumn = false;
    if (isRow == null) {
      rowColumn = false;
    } else {
      rowColumn = isRow;
    }
    if (isColumn == null) {
      rowColumn = true;
    } else {
      rowColumn = !isColumn;
    }
    print("Row Column: $rowColumn");
    return rowColumn
        ? Row(
            mainAxisAlignment: rowMainAxisAlignment,
            mainAxisSize: rowMainAxisSize,
            crossAxisAlignment: rowCrossAxisAlignment,
            textDirection: rowTextDirection,
            verticalDirection: rowVerticalDirection,
            textBaseline: rowTextBaseline,
            children: [
              ...buildRowChildren(children),
            ],
          )
        : Column(
            mainAxisAlignment: columnMainAxisAlignment,
            mainAxisSize: columnMainAxisSize,
            crossAxisAlignment: columnCrossAxisAlignment,
            textDirection: columnTextDirection,
            verticalDirection: columnVerticalDirection,
            textBaseline: columnTextBaseline,
            children: [
              ...buildColumnChildren(children),
            ],
          );
  }

  List<Widget> buildRowChildren(List<Widget> children) {
    List<Widget> childrenList = [];
    for (int i = 0; i < children.length; i++) {
      childrenList.add(
        Flexible(
            flex: 1,
            fit: fillRow ? FlexFit.tight : FlexFit.loose,
            child: children[i]),
      );
      if (rowSpacing != null && i != children.length - 1)
        childrenList.add(Padding(padding: rowSpacing));
    }
    return childrenList;
  }

  List<Widget> buildColumnChildren(List<Widget> children) {
    List<Widget> childrenList = [];
    for (int i = 0; i < children.length; i++) {
      childrenList.add(children[i]);
      if (columnSpacing != null && i != children.length - 1)
        childrenList.add(Padding(padding: columnSpacing));
    }
    return childrenList;
  }
}
