import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messageapp/core/constants/app_constants.dart';
import 'package:messageapp/core/constants/asset_constants.dart';
import 'package:messageapp/core/utils/app_colour.dart';

import '../../../../components/ItemCard/item_card.dart';
import '../../../Me/data/models/profile_model.dart';
import '../../../Me/presentation/providers/profile_provider.dart';
import '../../../ProductDetails/providers/prodcut_providers.dart';
import '../providers/notification_providers.dart';
import '../widgets/item_shimmers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  final ScrollController controller = ScrollController();
  bool _showAnalyzeCard = true;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.pixels >= controller.position.maxScrollExtent - 200) {
        ref.read(productsProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
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
                padding: const EdgeInsets.only(left: 18, right: 18, bottom: 8),
                child: ref
                    .watch(profileFutureProvider)
                    .when(
                      data: (profile) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage:
                              profile.avatar != null && profile.avatar!.isNotEmpty
                                  ? NetworkImage(profile.avatar!)
                                  : null,
                              child:
                              profile.avatar == null || profile.avatar!.isEmpty
                                  ? const Icon(
                                Icons.person,
                                size: 28,
                                color: Colors.grey,
                              ) : null,
                            ),
                             ref.watch(notificationProvider).when(
                               data: (notifResponse) {
                                 final unreadCount = notifResponse.notifications.where((n) => !n.isRead).length;
                                 return Badge(
                                   label: Text(unreadCount.toString()),
                                   isLabelVisible: unreadCount > 0,
                                   backgroundColor: Colors.red,
                                   child: Container(
                                     height: 45,
                                     width: 45,
                                     decoration: BoxDecoration(
                                       color: Colors.white,
                                       shape: BoxShape.circle,
                                       boxShadow: [
                                         BoxShadow(
                                           color: AppColors.Black.withValues(
                                             alpha: .15,
                                           ),
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
                                 );
                               },
                               loading: () => Container(
                                 height: 45,
                                 width: 45,
                                 decoration: BoxDecoration(
                                   color: Colors.white,
                                   shape: BoxShape.circle,
                                   boxShadow: [
                                     BoxShadow(
                                       color: AppColors.Black.withValues(
                                         alpha: .15,
                                       ),
                                       blurRadius: 2,
                                       offset: const Offset(0, 3),
                                     ),
                                   ],
                                 ),
                                 child: const Center(
                                   child: SizedBox(
                                     width: 20,
                                     height: 20,
                                     child: CircularProgressIndicator(strokeWidth: 2),
                                   ),
                                 ),
                               ),
                               error: (_, __) => Container(
                                 height: 45,
                                 width: 45,
                                 decoration: BoxDecoration(
                                   color: Colors.white,
                                   shape: BoxShape.circle,
                                   boxShadow: [
                                     BoxShadow(
                                       color: AppColors.Black.withValues(
                                         alpha: .15,
                                       ),
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
                             ),
                           ],
                         );
                       },
                      loading: () {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE5E7EB),
                                shape: BoxShape.circle,
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
                                    color: AppColors.Black.withValues(
                                      alpha: .15,
                                    ),
                                    blurRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  Assets.notification,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      error: (_, __) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CircleAvatar(
                              radius: 24,
                              child: Icon(Icons.person)
                            ),
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.Black.withValues(
                                      alpha: .15,
                                    ),
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
                        );
                      },
                    ),
                 ),

              const SizedBox(height: 14),
              // Scrollable Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAnalyzeTrustCard(),
                      const SizedBox(height: 16),

                      ref.watch(profileFutureProvider)
                          .when(
                            data: (profile) =>
                                Column(children: [_buildCapacityCard(profile)]),
                            loading: () => Column(
                              children: [_buildSkeletonCapacityCard()],
                            ),
                            error: (err, stack) => Column(
                              children: [_buildSkeletonCapacityCard()],
                            ),
                          ),
                      //_buildCapacityCard(),
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

                      ref.watch(productsProvider).when(
                        data: (response) {
                          final products = response.products;

                          if (products.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24.0),
                              child: Center(
                                child: Text(
                                  'No recently scanned products found.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            );
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            controller: controller,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 55),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: products.length,
                            itemBuilder: (_, index) {
                              final item = products[index];
                              return ProductCard(
                                imageUrl: item.imageUrls.isNotEmpty
                                    ? item.imageUrls.first
                                    : "",
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
                          );
                        },
                        loading: () => Center(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 2, // Number of shimmer items
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
                        ),
                        error: (err, stack) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Center(
                            child: Text(
                              'Failed to load products: $err',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
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

  Widget _buildSkeletonCapacityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Capacity",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE2E8F0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildCapacityStatusBox(
                  title: "Scans Today",
                  fractionText: "-/-",
                  highlightColor: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCapacityStatusBox(
                  title: "Saved Products",
                  fractionText: "-/-",
                  highlightColor: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
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
            color: AppColors.Black.withValues(alpha: 0.15),
            blurRadius: 2,
            offset: Offset(0, 3),
          ),
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
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                          if (clipboardData != null && clipboardData.text != null) {
                            _urlController.text = clipboardData.text!;
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            "assets/icons/clipboard-text.svg",
                          ),
                        ),
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
                  onPressed: ()async {
                    final picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    if(image !=null && mounted){
                      context.push(
                        AppPaths.search_product,
                        extra: {
                          'imagePath' : image.path
                        },
                      );

                      print("imagePath: $image");


                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Scan Button
          GestureDetector(
            onTap: () {
              final url = _urlController.text.trim();
              if (url.isNotEmpty) {
                _urlController.clear();
              }
              if(url.isEmpty){
                return;
              }

              context.push(
                AppPaths.search_product,
                extra: url.isNotEmpty ? url : null,
              );
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
  Widget _buildCapacityCard(ProfileModel profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: AppColors.Black.withValues(alpha: 0.15),
            blurRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Capacity",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //   decoration: BoxDecoration(
              //     color: AppColors.successGreen.withValues(alpha: 0.1),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: Text(
              //     profile.activePlanName,
              //     style: const TextStyle(
              //       fontSize: 12,
              //       fontWeight: FontWeight.bold,
              //       color: AppColors.successGreen,
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildCapacityStatusBox(
                  title: "Scans Today",
                  fractionText: "${profile.scansToday}/${profile.scansLimit}",
                  highlightColor: const Color(0xFF2563EB), // Blue
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCapacityStatusBox(
                  title: "Saved Products",
                  fractionText:
                      "${profile.savesToday}/${profile.savedProductsLimit}",
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
            color: AppColors.Black.withValues(alpha: 0.15),
            blurRadius: 2,
            offset: Offset(0, 3),
          ),
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
