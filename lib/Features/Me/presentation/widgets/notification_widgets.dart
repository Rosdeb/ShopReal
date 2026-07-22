import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationRow extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  const NotificationRow({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.activeColor = const Color(0xFF0BE968),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
          ),
          Transform.scale(
            scale: 0.80,
            child: CupertinoSwitch(
              value: value,
              activeColor: activeColor,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}