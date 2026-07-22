import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double borderRadius;
  final Widget? prefix;
  final Widget? suffix;
  final bool loading;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.backgroundColor = const Color(0xFF16A34A),
    this.textColor = Colors.white,
    this.height = 52,
    this.borderRadius = 14,
    this.prefix,
    this.suffix,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF16A34A),
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF10B981), // #B37FEB
              Color(0xFF18A751), // #D2AEF5 with 0% opacity (0x00)
            ],
          ),
          border: Border.all(
            width: 2,
            color: Color(0xFF16A34A),
          )
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: loading ? null : onTap,
          child: Center(
            child: loading
                ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation(textColor),
              ),
            )
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (prefix != null) ...[
                  prefix!,
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (suffix != null) ...[
                  const SizedBox(width: 8),
                  suffix!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}