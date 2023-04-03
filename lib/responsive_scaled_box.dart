import 'package:flutter/material.dart';

class ResponsiveScaledBox extends StatelessWidget {
  final double width;
  final Widget child;

  const ResponsiveScaledBox(
      {Key? key, required this.width, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    return MediaQuery(
      data: mediaQueryData,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double aspectRatio = constraints.maxWidth / constraints.maxHeight;
          double scaledHeight = width / aspectRatio;

          return FittedBox(
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
            child: Container(
              width: width,
              height: scaledHeight,
              alignment: Alignment.center,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
