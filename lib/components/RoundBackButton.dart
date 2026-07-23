import 'package:flutter/material.dart';
import '../core/utils/app_colour.dart';

class RoundBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const RoundBackButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.Black.withValues(alpha: 0.15),
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Color(0xFF1E293B),
          size: 18,
        ),
      ),
    );
  }
}
