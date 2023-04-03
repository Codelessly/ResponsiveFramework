import 'dart:math';

import 'package:flutter/material.dart';

class ResponsiveScaledBox extends StatelessWidget {
  final double width;
  final Widget child;
  final bool autoCalculateMediaQueryData;

  const ResponsiveScaledBox(
      {Key? key,
      required this.width,
      required this.child,
      this.autoCalculateMediaQueryData = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        MediaQueryData mediaQueryData = MediaQuery.of(context);

        double aspectRatio = constraints.maxWidth / constraints.maxHeight;
        double scaledWidth = width;
        double scaledHeight = width / aspectRatio;

        bool overrideMediaQueryData = autoCalculateMediaQueryData &&
            (mediaQueryData.size ==
                Size(constraints.maxWidth, constraints.maxHeight));

        EdgeInsets scaledViewInsets = getScaledViewInsets(
            mediaQueryData: mediaQueryData,
            screenSize: mediaQueryData.size,
            scaledSize: Size(scaledWidth, scaledHeight));
        EdgeInsets scaledViewPadding = getScaledViewPadding(
            mediaQueryData: mediaQueryData,
            screenSize: mediaQueryData.size,
            scaledSize: Size(scaledWidth, scaledHeight));
        EdgeInsets scaledPadding = getScaledPadding(
            padding: scaledViewPadding, insets: scaledViewInsets);

        Widget childHolder = FittedBox(
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
          child: Container(
            width: width,
            height: scaledHeight,
            alignment: Alignment.center,
            child: child,
          ),
        );

        if (overrideMediaQueryData) {
          return MediaQuery(
            data: mediaQueryData.copyWith(
                size: Size(scaledWidth, scaledHeight),
                viewInsets: scaledViewInsets,
                viewPadding: scaledViewPadding,
                padding: scaledPadding),
            child: childHolder,
          );
        }

        return childHolder;
      },
    );
  }

  EdgeInsets getScaledViewInsets(
      {required MediaQueryData mediaQueryData,
      required Size screenSize,
      required Size scaledSize}) {
    double leftInsetFactor = mediaQueryData.viewInsets.left / screenSize.width;
    double topInsetFactor = mediaQueryData.viewInsets.top / screenSize.height;
    double rightInsetFactor =
        mediaQueryData.viewInsets.right / screenSize.width;
    double bottomInsetFactor =
        mediaQueryData.viewInsets.bottom / screenSize.height;

    double scaledLeftInset = leftInsetFactor * scaledSize.width;
    double scaledTopInset = topInsetFactor * scaledSize.height;
    double scaledRightInset = rightInsetFactor * scaledSize.width;
    double scaledBottomInset = bottomInsetFactor * scaledSize.height;

    return EdgeInsets.fromLTRB(
        scaledLeftInset, scaledTopInset, scaledRightInset, scaledBottomInset);
  }

  EdgeInsets getScaledViewPadding(
      {required MediaQueryData mediaQueryData,
      required Size screenSize,
      required Size scaledSize}) {
    double scaledLeftPadding;
    double scaledTopPadding;
    double scaledRightPadding;
    double scaledBottomPadding;

    double leftPaddingFactor =
        mediaQueryData.viewPadding.left / screenSize.width;
    double topPaddingFactor =
        mediaQueryData.viewPadding.top / screenSize.height;
    double rightPaddingFactor =
        mediaQueryData.viewPadding.right / screenSize.width;
    double bottomPaddingFactor =
        mediaQueryData.viewPadding.bottom / screenSize.height;

    scaledLeftPadding = leftPaddingFactor * scaledSize.width;
    scaledTopPadding = topPaddingFactor * scaledSize.height;
    scaledRightPadding = rightPaddingFactor * scaledSize.width;
    scaledBottomPadding = bottomPaddingFactor * scaledSize.height;

    return EdgeInsets.fromLTRB(scaledLeftPadding, scaledTopPadding,
        scaledRightPadding, scaledBottomPadding);
  }

  EdgeInsets getScaledPadding(
      {required EdgeInsets padding, required EdgeInsets insets}) {
    double scaledLeftPadding;
    double scaledTopPadding;
    double scaledRightPadding;
    double scaledBottomPadding;

    scaledLeftPadding = max(0.0, padding.left - insets.left);
    scaledTopPadding = max(0.0, padding.top - insets.top);
    scaledRightPadding = max(0.0, padding.right - insets.right);
    scaledBottomPadding = max(0.0, padding.bottom - insets.bottom);

    return EdgeInsets.fromLTRB(scaledLeftPadding, scaledTopPadding,
        scaledRightPadding, scaledBottomPadding);
  }
}
