import 'package:flutter/material.dart';
class Expandabledescription extends StatefulWidget {
  final String text;
  Expandabledescription({super.key, required this.text});

  @override
  State<Expandabledescription> createState() => _ExpandabledescriptionState();
}

class _ExpandabledescriptionState extends State<Expandabledescription> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Construct a TextPainter to calculate if the text exceeds 2 lines
        final textSpan = TextSpan(
          text: widget.text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black.withValues(alpha: .6),
            height: 1.4,
          ),
        );

        final textPainter = TextPainter(
          text: textSpan,
          maxLines: 2,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout(maxWidth: constraints.maxWidth);
        final isOverflowing = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              maxLines: _expanded ? null : 2,
              overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black.withValues(alpha: .6),
                height: 1.4,
              ),
            ),
            if (isOverflowing) ...[
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                child: Text(
                  _expanded ? "Show less" : "Read more",
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
