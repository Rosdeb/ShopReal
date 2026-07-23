import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:messageapp/components/AppText/appText.dart';
import 'package:messageapp/core/constants/app_constants.dart';
import 'package:messageapp/core/utils/app_colour.dart';

import '../../../../components/CustomTextField/CustomTextfield.dart';
import '../../../../components/ItemCard/item_card.dart';
import '../../../ProductDetails/providers/prodcut_providers.dart';
import '../../../../Features/Home/presentation/widgets/item_shimmers.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add pagination listener to load more scans as the user scrolls down
    _scrollController.addListener(() {
      debugPrint("Scroll event: pixels = ${_scrollController.position.pixels}, max = ${_scrollController.position.maxScrollExtent}");
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        debugPrint("Reached bottom threshold. Loading more history items...");
        ref.read(historyProductsProvider.notifier).loadMore();
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
    // Watch history products state and query from Riverpod
    final productsState = ref.watch(historyProductsProvider);
    final searchQuery = ref.watch(historySearchQueryProvider);

    // Sync search controller text with provider state (useful on clear/refreshes)
    if (_searchController.text != searchQuery) {
      _searchController.text = searchQuery;
    }

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

                  const SizedBox(height: 10),

                  // Search Field
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
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Color(0xFF94A3B8),
                                size: 20,
                              ),
                              onPressed: () {
                                ref.read(historySearchQueryProvider.notifier).state = '';
                              },
                            )
                          : null,
                      autovalidateMode: AutovalidateMode.disabled,
                      validator: (value) => null,
                      onChanged: (value) {
                        ref.read(historySearchQueryProvider.notifier).state = value.trim();
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Expanded List/Grid Area
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => ref.read(historyProductsProvider.notifier).refresh(),
                      child: productsState.when(
                        data: (state) {
                          final items = state.products;

                          if (items.isEmpty) {
                            return const Center(
                              child: AppText(
                                "No history records found.",
                                style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                              ),
                            );
                          }

                          return CustomScrollView(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 20,
                                ),
                                sliver: SliverGrid(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 14,
                                    crossAxisSpacing: 14,
                                    childAspectRatio: 0.76,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final item = items[index];
                                      final currencySymbol = item.currency == 'USD' ? '\$' : '${item.currency} ';
                                      return ProductCard(
                                        imageUrl: item.imageUrls.isNotEmpty ? item.imageUrls.first : "",
                                        brand: item.brand ?? "Unknown Brand",
                                        title: item.title,
                                        description: item.description ?? "",
                                        price: "$currencySymbol${item.price ?? 0.0}",
                                        onTap: () {
                                          context.push(
                                            AppPaths.product_details,
                                            extra: item,
                                          );
                                        },
                                      );
                                    },
                                    childCount: items.length,
                                  ),
                                ),
                              ),
                              if (state.loadingMore)
                                const SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 24.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                        loading: () => GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.76,
                          ),
                          itemCount: 6,
                          itemBuilder: (context, index) => const ProductItemShimmer(),
                        ),
                        error: (error, stack) => Center(
                          child: AppText(
                            "Failed to load scan history.",
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
