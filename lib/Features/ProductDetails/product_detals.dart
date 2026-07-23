import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:messageapp/Features/ProductDetails/widgets/price_chat_shimmer.dart';
import 'package:messageapp/core/constants/asset_constants.dart';
import '../../components/ExpandableDescription.dart';
import '../../core/utils/app_colour.dart';
import 'data/models/product_model.dart';
import 'providers/prodcut_providers.dart';
import '../History/presentation/providers/save_providers.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final ScannedProduct product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceHistory = ref.watch(priceHistoryProvider(product.id));
    final savedProductsState = ref.watch(savedProductsProvider);
    final isSaved = savedProductsState.value?.bookmarks.any((b) => b.productId == product.id) ?? false;

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
                          icon: isSaved ? Assets.heart_fillup : Assets.heart,
                          onTap: () {
                            ref.read(savedProductsProvider.notifier).toggleSave(product);
                          },
                        ),
                      ],
                    ),
                  ),

                  // --- SCROLLABLE MAIN CONTENT ---
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
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
                                       product.imageUrls.isNotEmpty
                                           ? product.imageUrls.first
                                           : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqqdAMrQcJJr0-KSmcWeuYoJRYi6KSAczCOocvlPPg4A&s=10',
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
                          _buildPriceChartCard(priceHistory),
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
  Widget _buildRoundButton({required String icon, required VoidCallback onTap, Color? iconColor}) {
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
        child: SvgPicture.asset(
          icon,
          colorFilter: iconColor != null ? ColorFilter.mode(iconColor, BlendMode.srcIn) : null,
        ),
      ),
    );
  }

  // Insight Analytics Card Widget
  Widget _buildInsightAnalyticsCard() {
    final currencySymbol = product.currency == 'USD' ? '\$' : '${product.currency} ';
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
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF061B21)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expandabledescription(
            text: product.description ?? "No description available.",
            ),

          // Text(
          //   product.title,
          //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B),letterSpacing: 0),
          // ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(color: Color(0xFF525151), height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceRow("MSRP:", "$currencySymbol${product.originalPrice ?? product.price ?? 0.0}"),
              _buildPriceRow("Source Price:", "$currencySymbol${product.price ?? 0.0}"),
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
  Widget _buildPriceChartCard(AsyncValue<List<PriceHistoryItem>> priceHistoryAsync) {
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
                  const Text("History Log", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),

          priceHistoryAsync.when(
            data: (history) {
              if (history.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "No price history records",
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    ),
                  ),
                );
              }

              // Take last 7 items for chart
              final chartItems = history.length > 7
                  ? history.sublist(history.length - 7)
                  : history;

              // Find max price to scale heights (avoid divide by zero)
              final maxPrice = chartItems
                  .map((e) => e.price)
                  .fold<double>(0.01, (prev, price) => price > prev ? price : prev);

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: chartItems.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
                  final dayStr = item.date.split('-').last;
                  final currencySymbol = item.currency == 'USD' ? '\$' : '${item.currency} ';
                  final tooltipStr = "$currencySymbol${item.price}";

                  // Compute scale height (min 15, max 80)
                  final double calculatedHeight = (item.price / maxPrice) * 75.0;
                  final double barHeight = calculatedHeight < 15 ? 15 : calculatedHeight;

                  // Make the last item selected/active
                  final isLast = idx == chartItems.length - 1;

                  return _buildBar(
                    day: dayStr,
                    height: barHeight,
                    isSelected: isLast,
                    tooltip: isLast ? tooltipStr : null,
                  );
                }).toList(),
              );
            },
            loading: () {
              final shimmerColor = Colors.grey.shade200;
              final dummyHeights = [30.0, 50.0, 25.0, 60.0, 40.0, 70.0, 55.0];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: dummyHeights.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final height = entry.value;
                  final isLast = idx == dummyHeights.length - 1;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLast) ...[
                        Container(
                          width: 45,
                          height: 16,
                          decoration: BoxDecoration(
                            color: shimmerColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 4),
                      ] else ...[
                        const SizedBox(height: 20),
                      ],
                      Container(
                        height: height,
                        width: 24,
                        decoration: BoxDecoration(
                          color: shimmerColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 16,
                        height: 11,
                        decoration: BoxDecoration(
                          color: shimmerColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
            },
            error: (err, stack) => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Failed to load price history",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ),
          ),
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
    // Get confidence score from latestScan
    final score = product.latestScan?.confidenceScore ?? 0;
    final progressValue = score / 100.0;

    // Define colors and labels based on confidence ranges
    final Color progressColor;
    final String probabilityLabel;
    
    if (score >= 90) {
      progressColor = const Color(0xFF2563EB); // Blue
      probabilityLabel = "Very High";
    } else if (score >= 70) {
      progressColor = const Color(0xFF10B981); // Green
      probabilityLabel = "High Prob.";
    } else if (score >= 40) {
      progressColor = const Color(0xFFF59E0B); // Orange/Yellow
      probabilityLabel = "Med. Prob.";
    } else {
      progressColor = const Color(0xFFEF4444); // Red
      probabilityLabel = "Low Prob.";
    }

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
                  value: progressValue,
                  strokeWidth: 6,
                  backgroundColor: const Color(0xFFF1F5F9),
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$score%",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      Text(
                        probabilityLabel,
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
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.3),
                    children: [
                      const TextSpan(text: "Identified on "),
                      TextSpan(text: "${product.scanCount}", style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                      const TextSpan(text: " marketplace including global wholesale distributors."),
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
    final domainAge = product.domain?.domainAgeDays;
    final String ageStr;
    if (domainAge != null) {
      if (domainAge < 365) {
        ageStr = "$domainAge days";
      } else {
        final years = domainAge ~/ 365;
        final remainingDays = domainAge % 365;
        ageStr = remainingDays == 0
            ? "$years ${years == 1 ? 'year' : 'years'}"
            : "$years ${years == 1 ? 'year' : 'years'} $remainingDays ${remainingDays == 1 ? 'day' : 'days'}";
      }
    } else {
      ageStr = "Unknown";
    }
    final trustScore = product.domain?.trustScore;
    final trustStr = trustScore != null ? "$trustScore%" : "N/A";

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricItem(
                icon: Icons.storefront_outlined,
                iconColor: const Color(0xFFF97316),
                bgColor: const Color(0xFFFFF7ED),
                title: "Source Store",
                value: product.storeName ?? product.domain?.hostname ?? "Unknown",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricItem(
                icon: Icons.dashboard_outlined,
                iconColor: const Color(0xFF10B981),
                bgColor: const Color(0xFFECFDF5),
                title: "Trust Score",
                value: trustStr,
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
                title: "SSL Status",
                value: product.domain?.sslValid == true ? "Valid SSL" : "Invalid/No SSL",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricItem(
                icon: Icons.calendar_month_outlined,
                iconColor: const Color(0xFF3B82F6),
                bgColor: const Color(0xFFEFF6FF),
                title: "Domain age",
                value: ageStr,
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