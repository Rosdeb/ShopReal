import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:messageapp/core/constants/app_constants.dart';

import '../../../../components/AppText/appText.dart';
import '../../../../components/CustomTextField/CustomTextfield.dart';
import '../../../../components/ItemCard/item_card.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/utils/app_colour.dart';
import '../providers/contact_providers.dart';
import '../widgets/create_contact_sheet.dart';
import '../widgets/create_group_sheet.dart';
import '../widgets/new_contact_sheet.dart';
import '../widgets/slidable_bar.dart';
class SaveScreen extends ConsumerStatefulWidget {
  const SaveScreen({super.key});

  @override
  ConsumerState<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends ConsumerState<SaveScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){

                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.all(10),
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
                              child: SvgPicture.asset(Assets.save2,height: 30,width: 30,),
                            ),
                          ),
                          AppText(
                              "Save  Products",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          GestureDetector(
                            onTap: (){

                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.all(10),
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
                              child: SvgPicture.asset(Assets.heart,height: 30,width: 30,),
                            ),
                          ),
                        ],
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
                          childAspectRatio: 0.74, // Adjusted to 0.65 to give your product text & price breathing room
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