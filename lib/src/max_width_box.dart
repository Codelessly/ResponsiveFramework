import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MaxWidthBox extends StatefulWidget {
  final double? maxWidth;

  /// Control the internal Stack alignment. This widget
  /// uses a Stack to set the widget to max width on top of
  /// a background.
  /// Defaults to [Alignment.topCenter] because app
  /// content is usually top aligned.
  final AlignmentGeometry alignment;
  final Widget child;
  final Widget? background;

  const MaxWidthBox(
      {super.key,
      required this.maxWidth,
      required this.child,
      this.background,
      this.alignment = Alignment.topCenter});

  @override
  State<MaxWidthBox> createState() => _MaxWidthBoxState();
}

class _MaxWidthBoxState extends State<MaxWidthBox> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    if (widget.maxWidth != null) {
      if (mediaQuery.size.width > widget.maxWidth!) {
        mediaQuery = mediaQuery.copyWith(
            size: Size(widget.maxWidth!, mediaQuery.size.height));
      }
    }

    return Stack(
      alignment: widget.alignment,
      children: [
        Scrollbar(
          controller: _scrollController,
          trackVisibility: true,
          thumbVisibility: true,
          child: Listener(
            onPointerSignal: (pointerSignal) {
              if (pointerSignal is PointerScrollEvent) {
                final newOffset =
                    _scrollController.offset + pointerSignal.scrollDelta.dy;

                if (newOffset < _scrollController.position.minScrollExtent) {
                  _scrollController
                      .jumpTo(_scrollController.position.minScrollExtent);
                } else if (newOffset >=
                        _scrollController.position.minScrollExtent &&
                    newOffset <= _scrollController.position.maxScrollExtent) {
                  _scrollController.jumpTo(newOffset);
                } else if (newOffset >
                    _scrollController.position.maxScrollExtent) {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                }
              }
            },
            child: widget.background ??
                Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.transparent),
          ),
        ),
        MediaQuery(
          data: mediaQuery,
          child: SizedBox(
            width: widget.maxWidth,
            child: PrimaryScrollController(
              controller: _scrollController,
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// NotificationListener<ScrollNotification>(
//   onNotification: (scrollNotification) {
//     // Forward the scroll notification to the child
//     if (scrollNotification is ScrollUpdateNotification) {
//       _scrollController.jumpTo(_scrollController.offset +
//           scrollNotification.scrollDelta!.toDouble());
//     }
//     return false; // Don't consume the notification
//   },
//   child: widget.background ??
//       Container(
//           width: double.infinity,
//           height: double.infinity,
//           color: Colors.transparent),
// ),
