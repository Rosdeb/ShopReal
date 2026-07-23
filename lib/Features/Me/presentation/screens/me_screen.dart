import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:messageapp/components/AppText/appText.dart';
import 'package:messageapp/core/constants/app_constants.dart';
import 'package:messageapp/core/utils/app_colour.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../auth/presentation/providers/login_providers.dart';
import '../../data/models/profile_model.dart';
import '../providers/setting_providers.dart';
import '../providers/profile_provider.dart';

class MeScreen extends ConsumerWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the states from Riverpod
    final isPushEnabled = ref.watch(pushNotificationsProvider);
    final isDarkModeEnabled = ref.watch(darkModeProvider);

    // Light gray background typical for iOS settings
    final backgroundColor = const Color(0xFFF2F2F7);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FFF9), Color(0xFFF0FDF4)],
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
                      "Profile",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          children: [
                              // --- PROFILE & CAPACITY CARD ---
                              ref.watch(profileFutureProvider).when(
                                data: (profile) => Column(
                                  children: [
                                    _buildSectionCard([
                                      ListTile(
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        leading: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: profile.avatar != null && profile.avatar!.isNotEmpty
                                              ? NetworkImage(profile.avatar!)
                                              : const NetworkImage(
                                                  'https://cdn.motor1.com/images/mgl/bglVnv/s3/best-new-cars-coming-out-in-2025.webp',
                                                ),
                                        ),
                                        title: AppText(
                                          profile.name.isNotEmpty ? profile.name : 'Unknown User',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        subtitle: AppText(
                                          profile.email,
                                          style: const TextStyle(
                                            color: AppColors.textLight,
                                            fontSize: 14,
                                          ),
                                        ),
                                        onTap: () {},
                                      ),
                                    ]),
                                    const SizedBox(height: 16),
                                    _buildCapacityCard(profile),
                                  ],
                                ),
                                loading: () => Column(
                                  children: [
                                    _buildSectionCard([
                                      ListTile(
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        leading: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFE5E7EB),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        title: Container(
                                          height: 16,
                                          width: 140,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE5E7EB),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Container(
                                            height: 14,
                                            width: 180,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE5E7EB),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                    const SizedBox(height: 16),
                                    _buildSkeletonCapacityCard(),
                                  ],
                                ),
                                error: (err, stack) => Column(
                                  children: [
                                    _buildSectionCard([
                                      ListTile(
                                        leading: const CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Color(0xFFFEE2E2),
                                          child: Icon(Icons.error_outline, color: Colors.red),
                                        ),
                                        title: const AppText(
                                          'Failed to load profile',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: const AppText('Forbidden (403) or Session Expired'),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.refresh, color: AppColors.successGreen),
                                          onPressed: () => ref.refresh(profileFutureProvider),
                                        ),
                                      ),
                                    ]),
                                    const SizedBox(height: 16),
                                    _buildSkeletonCapacityCard(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // --- SETTINGS CARDS (ALWAYS RENDERED UNCONDITIONALLY) ---
                              _buildSectionCard([
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0,
                                    vertical: 5,
                                  ),
                                  child: AppText(
                                    'Account Settings',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                _buildListTile(
                                  icon: Icons.person_outline,
                                  iconColor: AppColors.successGreen,
                                  title: 'Personal Information',
                                  onTap: () {
                                    // context.push(AppPaths.edit_profile);
                                  },
                                ),
                                _buildDivider(),
                                _buildListTile(
                                  icon: Icons.mail_outline,
                                  iconColor: AppColors.successGreen,
                                  title: 'Password & Security',
                                  onTap: () {
                                    //context.push(AppPaths.email_setting);
                                  },
                                ),
                                _buildDivider(),
                                _buildListTile(
                                  icon: Icons.credit_card,
                                  iconColor: AppColors.successGreen,
                                  title: 'Subscription',
                                  onTap: () {
                                    //context.push(AppPaths.email_setting);
                                  },
                                ),
                              ]),
                              const SizedBox(height: 16),
                              _buildSectionCard([
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0,
                                    vertical: 5,
                                  ),
                                  child: AppText(
                                    'Preferences',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                _buildListTile(
                                  icon: Icons.person_outline,
                                  iconColor: AppColors.successGreen,
                                  title: 'Notifications',
                                  onTap: () {
                                    context.push(AppPaths.notification_setting);
                                  },
                                ),
                                _buildDivider(),
                                _buildListTile(
                                  icon: Icons.mail_outline,
                                  iconColor: AppColors.successGreen,
                                  title: 'Help & Support',
                                  onTap: () {
                                    //context.push(AppPaths.email_setting);
                                  },
                                ),
                                _buildDivider(),
                                _buildListTile(
                                  icon: Icons.credit_card,
                                  iconColor: AppColors.successGreen,
                                  title: 'Privacy Policy',
                                  onTap: () {
                                    //context.push(AppPaths.email_setting);
                                  },
                                ),
                              ]),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEF4444),
                                    foregroundColor: AppColors.destructiveRed,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Log Out'),
                                        content: const Text('Are you sure you want to log out?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text(
                                              'Log Out',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await ref.read(tokenServiceProvider).clearTokens();
                                      ref.read(loginControllerProvider.notifier).reset();
                                      if (context.mounted) {
                                        context.go(AppPaths.login);
                                      }
                                    }
                                  },
                                  child: const AppText(
                                    'Log Out',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Center(
                                child: Column(
                                  children: [
                                    AppText(
                                      'Terms of Service • Privacy Policy',
                                      style: TextStyle(
                                        color: AppColors.textLight,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    AppText(
                                      '©2026 Pilach Home Inc.',
                                      style: TextStyle(
                                        color: AppColors.textLight,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 80),

                          ],
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
                  fractionText: "${profile.savesToday}/${profile.savedProductsLimit}",
                  highlightColor: const Color(0xFF2563EB), // Blue
                ),
              ),
            ],
          ),
        ],
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

  // Helper widget to construct iOS style header labels
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: AppText(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Helper container that mimics iOS grouped list appearance
  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: Offset(1, 3),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  // Helper custom tile line separator
  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 56.0),
      child: Divider(height: 1, thickness: 0.5, color: Color(0xFFE5E5EA)),
    );
  }

  // Standard Action Row Helper
  Widget _buildListTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? trailingText,
    bool showArrow = true,
    VoidCallback? onTap,
  }) {
    return ListTile(
      dense: true,
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          if (trailingText != null && showArrow) const SizedBox(width: 8),
          if (showArrow)
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }

  // Toggle Switch Row Helper
  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final switchController = ValueNotifier<bool>(value);
    // Hook up a listener to catch toggle events from AdvancedSwitch and forward them safely to your parent tree callback.
    switchController.addListener(() {
      onChanged(switchController.value);
    });
    return ListTile(
      dense: true,
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      trailing: Transform.scale(
        scaleX: 0.75,
        scaleY: 0.80,
        child: AdvancedSwitch(
          controller: switchController,
          width: 45,
          height: 24,
          activeColor: const Color(0xFF34C759),
          inactiveColor: Colors.grey.shade300,
          // borderRadius: const BorderRadius.all(
          //   Radius.circular(20),
          // ),
        ),
      ),
    );
  }
}
