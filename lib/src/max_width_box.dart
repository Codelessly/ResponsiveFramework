import 'package:flutter/material.dart';

class MaxWidthBox extends StatelessWidget {
  final double? maxWidth;
  final Widget child;

  /// Control child alignment.
  /// Defaults to [Alignment.topCenter] because app
  /// content is usually top aligned.
  final AlignmentGeometry alignment;
  final EdgeInsets? padding;
  final Color? backgroundColor;

  const MaxWidthBox(
      {super.key,
      required this.maxWidth,
      required this.child,
      this.alignment = Alignment.topCenter,
      this.padding,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    if (maxWidth != null) {
      if (mediaQuery.size.width > maxWidth!) {
        mediaQuery = mediaQuery.copyWith(
            size: Size(maxWidth! - (padding?.horizontal ?? 0),
                mediaQuery.size.height - (padding?.vertical ?? 0)));
      }
    }

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: Container(
          color: backgroundColor,
          padding: padding,
          child: MediaQuery(
            data: mediaQuery,
            child: child,
          ),
        ),
      ),
    );
  }
}
