import 'package:flutter/material.dart';

class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double startPadding;
  final Duration duration;

  const MarqueeText({
    super.key,
    required this.text,
    this.style,
    this.startPadding = 0,
    this.duration = const Duration(seconds: 8),
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final GlobalKey _textKey = GlobalKey();

  double _textWidth = 0;
  double _containerWidth = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _containerWidth = constraints.maxWidth;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final box =
          _textKey.currentContext?.findRenderObject() as RenderBox?;
          if (box != null && mounted) {
            setState(() {
              _textWidth = box.size.width;
            });
          }
        });

        final distance = _textWidth + _containerWidth;

        return ClipRect(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              return Transform.translate(
                offset: Offset(
                  _containerWidth -
                      (distance * _controller.value) +
                      widget.startPadding,
                  0,
                ),
                child: child,
              );
            },
            child: Text(
              widget.text,
              key: _textKey,
              maxLines: 1,
              style: widget.style,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}