import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:messageapp/core/constants/app_constants.dart';
import 'package:messageapp/core/constants/asset_constants.dart';
import 'package:messageapp/core/utils/app_colour.dart';

import '../../../../components/ItemCard/item_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showAnalyzeCard = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 30 && _showAnalyzeCard) {
        setState(() => _showAnalyzeCard = false);
      } else if (_scrollController.offset <= 30 && !_showAnalyzeCard) {
        setState(() => _showAnalyzeCard = true);
      }
    });

  }
  @override
  void dispose() {
    _scrollController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8FBF0), Color(0xFFF4FDF9)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Fixed Header
              Padding(
                padding: const EdgeInsets.only(left: 18,right: 18,bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/150?img=47",
                      ),
                    ),
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.Black.withValues(alpha: .15),
                            blurRadius: 2,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          context.push(AppPaths.notification_screen);
                        },
                        icon: SvgPicture.asset(Assets.notification),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),
              // Scrollable Body
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAnalyzeTrustCard(),
                      const SizedBox(height: 16),

                      _buildCapacityCard(),
                      const SizedBox(height: 20),

                      const Text(
                        "Recently Searched",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 55),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.75, // Adjusted to 0.65 to give more breathing room
                        ),
                        itemCount: 8,
                        itemBuilder: (_, index) {
                          return ProductCard(
                            imageUrl:
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqqdAMrQcJJr0-KSmcWeuYoJRYi6KSAczCOocvlPPg4A&s=10",
                            brand: "BatManft",
                            title: "Mini Multi-Functional",
                            description: "Non-stick coating, for food contact. Multi-fun...",
                            price: "\$13.40",
                            onTap: () {
                             context.push(AppPaths.product_details);
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Analyze Trust Card Layout
  Widget _buildAnalyzeTrustCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color:  AppColors.Black.withValues(alpha: 0.15),
            blurRadius: 2,
            offset: Offset(0, 3),

          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Analyze Product Trust",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Validate suppliers, check profit margins, and identify dropshipping indicators.",
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Input Row (Url Paste & Camera Icon Action)
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    // Subtle grey border around the container
                  ),
                  child: TextField(
                    controller: _urlController,
                    textAlignVertical: TextAlignVertical.center,
                    // Vertically aligns the text in the middle
                    decoration: InputDecoration(
                      hintText: "Paste Product url",
                      hintStyle: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                      // Custom padding to center the text perfectly and leave space for the suffix icon
                      contentPadding: const EdgeInsets.only(
                        left: 16,
                        right: 0,
                        top: 0,
                        bottom: 0,
                      ),
                      border: InputBorder.none,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset("assets/icons/clipboard-text.svg"),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.0,
                  ),
                ),
                child: IconButton(
                  icon: SvgPicture.asset("assets/icons/camera.svg"),
                  onPressed: () {

                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Scan Button
          GestureDetector(
            onTap: () {
              context.push(AppPaths.search_product);
            },
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981), // green/600 base color
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF10B981), // #B37FEB
                    Color(0xFF18A751), // #D2AEF5 with 0% opacity (0x00)
                  ],
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Scan Product +",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Capacity Summary Card Layout
  Widget _buildCapacityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color:  AppColors.Black.withValues(alpha: 0.15),
            blurRadius: 2,
            offset: Offset(0, 3),

          )
        ],

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Capacity",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildCapacityStatusBox(
                  title: "Scans Today",
                  fractionText: "10/10",
                  highlightColor: const Color(0xFF2563EB), // Blue
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCapacityStatusBox(
                  title: "Saved Products",
                  fractionText: "0/20",
                  highlightColor: const Color(0xFF2563EB), // Blue
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityStatusBox({
    required String title,
    required String fractionText,
    required Color highlightColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:  AppColors.Black.withValues(alpha: 0.15),
            blurRadius: 2,
            offset: Offset(0, 3),

          )
        ],
        // border: Border.all(
        //   color: Color(0xFFE5E7EB),
        //   width: 0.09
        // )
      ),
      child: Row(
        children: [
          SvgPicture.asset("assets/icons/clipboard-text.svg"),

          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fractionText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: highlightColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
