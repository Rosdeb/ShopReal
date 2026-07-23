import 'package:flutter/material.dart';
import 'package:messageapp/components/CustomButton/custom_button.dart';

class SubscriptionBottomSheet extends StatefulWidget {
  const SubscriptionBottomSheet({super.key});

  @override
  State<SubscriptionBottomSheet> createState() =>
      _SubscriptionBottomSheetState();
}

class _SubscriptionBottomSheetState extends State<SubscriptionBottomSheet> {
  bool isYearly = false;

  // Change this according to the user's current subscription.
  final bool currentPlanIsMonthly = true;

  bool get isCurrentPlan => currentPlanIsMonthly ? !isYearly : isYearly;

  @override
  Widget build(BuildContext context) {
    final title = isYearly ? 'Yearly' : 'Monthly';
    final price = isYearly ? '\$254.15' : '\$25.00';
    final duration = isYearly ? '/year' : '/mo';

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isYearly
                        ? const Color(0xFFFFE89A)
                        : const Color(0xFFCFF9DF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.workspace_premium_rounded,
                    size: 40,
                    color: isYearly
                        ? const Color(0xFFE5A900)
                        : const Color(0xFF12B866),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF171C2B),
                  ),
                ),
                if (isYearly) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9FBE7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '15% OFF',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF12B866),
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      size: 22,
                      color: Color(0xFF151A27),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Price
            Align(
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: price,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF171C2B),
                      ),
                    ),
                    TextSpan(
                      text: ' $duration',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5E6472),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            _BenefitItem(
              icon: Icons.circle,
              iconColor: const Color(0xFF5147F5),
              backgroundColor: const Color(0xFFD8D7FF),
              title: isYearly ? 'Unlimited Scan' : '300 Scans',
              subtitle: 'Per day',
            ),

            const SizedBox(height: 12),

            _BenefitItem(
              icon: Icons.layers_rounded,
              iconColor: const Color(0xFF079D91),
              backgroundColor: const Color(0xFFB9F6EE),
              title: isYearly ? 'Unlimited Saved Products' : '400 Save Product',
              subtitle: isYearly ? 'No storage limit' : 'Up to 400 products',
            ),

            const SizedBox(height: 24),

            // Monthly and yearly selector
            Row(
              children: [
                Expanded(
                  child: _PlanTab(
                    title: 'Monthly',
                    isSelected: !isYearly,
                    onTap: () {
                      setState(() {
                        isYearly = false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _PlanTab(
                    title: 'Yearly',
                    isSelected: isYearly,
                    onTap: () {
                      setState(() {
                        isYearly = true;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Divider(height: 1, color: Color(0xFFE9E9ED)),

            const SizedBox(height: 16),

            CustomButton(
              text: isCurrentPlan ? 'Current Plan' : 'Subscribe now',
              onTap: isCurrentPlan
                  ? null
                  : () {
                _subscribe(context);
              },
              backgroundColor: isCurrentPlan ? Colors.white38 :  const Color(0xFF12C765),
              suffix: Icon(Icons.add,color: Colors.white,),
            ),
            // Action button
          ],
        ),
      ),
    );
  }

  void _subscribe(BuildContext context) {
    final selectedPlan = isYearly ? 'yearly' : 'monthly';

    debugPrint('Selected plan: $selectedPlan');

    // Add RevenueCat, in-app purchase, or API call here.
    // Example:
    // context.read<SubscriptionCubit>().subscribe(selectedPlan);

    Navigator.of(context).pop();
  }
}

class _BenefitItem extends StatelessWidget {
  const _BenefitItem({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 17, color: iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF262B38),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 10, color: Color(0xFF757A86)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanTab extends StatelessWidget {
  const _PlanTab({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Material(
        color: isSelected ? const Color(0xFF12C765) : Colors.white,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(7),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF12C765)
                    : const Color(0xFFE2E3E7),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF171C2B),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
