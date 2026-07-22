import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bottom_nav_provider.dart';
import 'nav_item.dart';

class CustomBottomNav extends ConsumerWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.black12.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                icon: currentIndex == 0
                    ? CupertinoIcons.house_fill
                    : CupertinoIcons.home,
                label: 'Home',
                index: 0,
                isSelected: currentIndex == 0,
              ),
              NavItem(
                icon: currentIndex == 1
                    ? CupertinoIcons.clock_fill
                    : CupertinoIcons.clock,
                label: 'History',
                index: 1,
                isSelected: currentIndex == 1,
              ),
              NavItem(
                icon: currentIndex == 2
                    ? CupertinoIcons.bookmark_fill
                    : CupertinoIcons.bookmark,
                label: 'Save',
                index: 2,
                isSelected: currentIndex == 2,
              ),
              NavItem(
                icon: currentIndex == 3
                    ? CupertinoIcons.gear_alt_fill
                    : CupertinoIcons.gear_alt,
                label: 'Setting',
                index: 3,
                isSelected: currentIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
