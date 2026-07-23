import 'package:flutter/material.dart';

class PriceChartShimmer extends StatelessWidget {
  const PriceChartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final heights = [28.0, 55.0, 42.0, 70.0, 48.0, 60.0, 35.0];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(7, (index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Tooltip placeholder for selected bar
            if (index == 6)
              Container(
                width: 42,
                height: 18,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),

            Container(
              width: 24,
              height: heights[index],
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            const SizedBox(height: 8),

            Container(
              width: 18,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        );
      }),
    );
  }
}