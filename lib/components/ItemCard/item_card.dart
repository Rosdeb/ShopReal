import 'package:flutter/material.dart';
import 'package:messageapp/components/AppText/appText.dart';
import 'package:messageapp/core/utils/app_colour.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String brand;
  final String title;
  final String description;
  final String price;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.brand,
    required this.title,
    required this.description,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: AppColors.Black.withValues(alpha: .15),
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 130,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.broken_image_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.electric_bolt,
                          size: 12,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: AppText(
                          brand,
                          fontSize: 11,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: AppText(
                    price,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF10B981),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            AppText(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),

            const SizedBox(height: 4),

            AppText(
              description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              fontSize: 11,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}
