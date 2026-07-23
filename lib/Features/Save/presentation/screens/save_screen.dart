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
import '../../../History/presentation/providers/save_providers.dart';
import '../../../Home/presentation/widgets/item_shimmers.dart';

class SaveScreen extends ConsumerStatefulWidget {
  const SaveScreen({super.key});

  @override
  ConsumerState<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends ConsumerState<SaveScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        ref.read(savedProductsProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
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
                              child: SvgPicture.asset(Assets.heart_fillup,height: 30,width: 30,),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    // Grid View Section (Now safely expanded within the Column)
                    Expanded(
                      child: ref.watch(savedProductsProvider).when(
                        data: (response) {
                          final bookmarks = response.bookmarks;
                          if (bookmarks.isEmpty) {
                            return const Center(
                              child: Text(
                                'No saved products found.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }
                          return RefreshIndicator(
                            onRefresh: (){
                              return ref.read(savedProductsProvider.notifier).refresh();
                            },
                            child: GridView.builder(
                              controller: _scrollController,
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
                                childAspectRatio: 0.74,
                              ),
                              itemCount: bookmarks.length,
                              itemBuilder: (_, index) {
                                final bookmark = bookmarks[index];
                                final item = bookmark.product;
                                if (item == null) return const SizedBox.shrink();
                                return ProductCard(
                                  imageUrl: item.imageUrls.isNotEmpty ? item.imageUrls.first : "",
                                  brand: item.brand ?? "Unknown Brand",
                                  title: item.title,
                                  description: item.description ?? "",
                                  price: "${item.currency == 'USD' ? '\$' : ''}${item.price ?? 0.0}",
                                  onTap: () {
                                    context.push(
                                      AppPaths.product_details,
                                      extra: item,
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                        loading: () => GridView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 70,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6, // Number of shimmer items
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.68,
                            ),
                            itemBuilder: (context, index) {
                              return const ProductItemShimmer();
                            },
                          ),
                        error: (err, stack) => Center(
                          child: Text(
                            'Failed to load saved products: $err',
                            style: const TextStyle(color: Colors.red),
                          ),
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
}