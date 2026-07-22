import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:messageapp/core/constants/asset_constants.dart';
import '../../core/utils/app_colour.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8FBF0),
              Color(0xFFF4FDF9),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background Ellipse decoration
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                "assets/images/Ellipse 86.png",
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  // --- CUSTOM APP BAR ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildRoundButton(
                          icon: Assets.arrow,
                          onTap: () => Navigator.pop(context),
                        ),
                        const Text(
                          "Product Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        _buildRoundButton(
                          icon: Assets.heart,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  // --- SCROLLABLE MAIN CONTENT ---
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),

                          // 1. Image Container Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.Black.withValues(alpha: .15),
                                  blurRadius: 2,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFF1F5F9)),
                            ),
                            child: Column(
                              children: [
                                 ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqqdAMrQcJJr0-KSmcWeuYoJRYi6KSAczCOocvlPPg4A&s=10', // Replace with your image asset or dynamic URL
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      height: 200,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                                    ),
                                  ),
                                const SizedBox(height: 12),
                                _buildInsightAnalyticsCard(),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // 2. Info Card (Insight Analytics & Prices)


                          // 3. Price Chart Card
                          _buildPriceChartCard(),
                          const SizedBox(height: 12),

                          // 4. Product Confidence Indicator Card
                          _buildProductConfidenceCard(),
                          const SizedBox(height: 12),

                          // 5. Quad Metric Grid Info Cards
                          _buildQuadMetricsGrid(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Round Custom Button Helper
  Widget _buildRoundButton({required String icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,

        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.Black.withValues(alpha: .15),
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(icon,),
      ),
    );
  }

  // Insight Analytics Card Widget
  Widget _buildInsightAnalyticsCard() {
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.electric_bolt, color: Colors.orange, size: 14),
              ),
              const SizedBox(width: 8),
              const Text(
                "Insight Analytics",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Mini Multi-Functional",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 8),
          const Text(
            "Non-stick coating, for food contact. Multi-function cooking, delicacy. Two levels of firepower, firepower can be big or small...",
            style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500, color: Color(0xFF94A3B8), height: 1.4),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(color: Color(0xFF525151), height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceRow("MSRP:", "\$110"),
              _buildPriceRow("Source Price:", "\$110.90"),
            ],
          )
        ],
      );
  }

  Widget _buildPriceRow(String title, String price) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 13, color: Colors.black)),
        const SizedBox(width: 4),
        Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
      ],
    );
  }

  // Custom Bar Chart Card Widget
  Widget _buildPriceChartCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.Black.withValues(alpha: .15),
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Price Chart",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 2),
                  const Text("Last 7 day", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                ],
              ),
              Row(
                children: [
                  const Text("November", style: TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontWeight: FontWeight.w500)),
                  const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B), size: 18),
                ],
              )
            ],
          ),
          const SizedBox(height: 28),

          // Beautiful Custom Bar Chart Visualizer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar(day: "12", height: 35),
              _buildBar(day: "13", height: 50),
              _buildBar(day: "14", height: 45),
              _buildBar(day: "15", height: 75, isSelected: true, tooltip: "3,680"),
              _buildBar(day: "16", height: 55),
              _buildBar(day: "17", height: 30, isVeryLight: true),
              _buildBar(day: "18", height: 50, isVeryLight: true),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBar({
    required String day,
    required double height,
    bool isSelected = false,
    bool isVeryLight = false,
    String? tooltip,
  }) {
    Color barColor = isSelected
        ? const Color(0xFF10B981)
        : isVeryLight
        ? const Color(0xFFCADDCC).withValues(alpha: 0.8)
        : const Color(0xFFCADDCC);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (tooltip != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              tooltip,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
        ],
        Container(
          height: height,
          width: 24,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(10),
            gradient: isSelected ? LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFC3F130), Color(0xFF08A240)],
            ) : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w700, color: Color(
            0xFF784040))),
      ],
    );
  }

  // Product Confidence Progress Widget
  Widget _buildProductConfidenceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.Black.withValues(alpha: .15),
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          // Circular Progress Indicator Stack
          SizedBox(
            height: 76,
            width: 76,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 0.65,
                  strokeWidth: 6,
                  backgroundColor: const Color(0xFFF1F5F9),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "2,181",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      Text(
                        "High Prob.",
                        style: TextStyle(fontSize: 8, color: const Color(0xFF64748B).withOpacity(0.8)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Product Confidence",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.3),
                    children: [
                      TextSpan(text: "Identified on "),
                      TextSpan(text: "0", style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                      TextSpan(text: " marketplace including global wholesale distributors."),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Quad Grid Details Layout Widget
  Widget _buildQuadMetricsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricItem(
                icon: Icons.storefront_outlined,
                iconColor: const Color(0xFFF97316),
                bgColor: const Color(0xFFFFF7ED),
                title: "Marketplaces",
                value: "0",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricItem(
                icon: Icons.dashboard_outlined,
                iconColor: const Color(0xFF10B981),
                bgColor: const Color(0xFFECFDF5),
                title: "Gross markup",
                value: "44%",
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricItem(
                icon: Icons.verified_user_outlined,
                iconColor: const Color(0xFF10B981),
                bgColor: const Color(0xFFECFDF5),
                title: "Whois status",
                value: "Protected",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricItem(
                icon: Icons.calendar_month_outlined,
                iconColor: const Color(0xFF3B82F6),
                bgColor: const Color(0xFFEFF6FF),
                title: "Domain age",
                value: "Unknown",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.Black.withValues(alpha: .15),
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}