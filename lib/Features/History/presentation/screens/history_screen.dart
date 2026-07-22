import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messageapp/components/AppText/appText.dart';
import 'package:messageapp/core/constants/app_constants.dart';
import 'package:messageapp/core/utils/app_colour.dart';

import '../../../../components/CustomTextField/CustomTextfield.dart';
import '../../../../components/ItemCard/item_card.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8FBF0), Color(0xFFF4FDF9)],
          ),
        ),
        child: Stack(
          children: [
            // Background Decorative Image
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                "assets/images/Ellipse 86.png",
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),

            // Main Layout Structure
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header Section
                  Align(
                    alignment: Alignment.topCenter,
                    child: AppText(
                      "History",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: CustomTextField(
                      controller: _searchController,
                      hintText: "Search products...",
                      keyboardType: TextInputType.text,
                      filColor: Colors.white,
                      borderColor: const Color(0xFFE2E8F0),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF94A3B8),
                        size: 22,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Color(0xFF94A3B8),
                                size: 20,
                              ),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      autovalidateMode: AutovalidateMode.disabled,
                      validator: (value) => null,
                      onChanged: (value) {
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Grid View Section (Now safely expanded within the Column)
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 70,
                      ),
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio:
                            0.76, // Adjusted to 0.68 to give your product text & price breathing room
                      ),
                      itemCount: 8,
                      itemBuilder: (_, index) {
                        return ProductCard(
                          imageUrl:
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqqdAMrQcJJr0-KSmcWeuYoJRYi6KSAczCOocvlPPg4A&s=10",
                          brand: "BatManft",
                          title: "Mini Multi-Functional",
                          description:
                              "Non-stick coating, for food contact. Multi-fun...",
                          price: "\$13.40",
                          onTap: () {
                            context.push(AppPaths.product_details);
                          },
                        );
                      },
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
}
