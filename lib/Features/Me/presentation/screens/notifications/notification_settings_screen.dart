import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../components/AppText/appText.dart';
import '../../../../../core/utils/app_colour.dart';
import '../../widgets/notification_widgets.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // Toggle States
  bool pushAlerts = true;
  bool emailReports = true;
  bool emergencySms = true;

  // Custom Green Color matching the screenshot
  static const Color activeGreen = Color(0xFF34D399);
  static const Color titleColor = Color(0xFF0F1738);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
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
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                "assets/images/Ellipse 86.png",
                errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        _buildRoundBackButton(
                          onTap: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.topCenter,
                          child: AppText(
                            "Notifications Setting",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),

                        const Spacer(),
                        const SizedBox(width: 50),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header Title
                          const Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                            child: Text(
                              'Notifications',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: titleColor,
                              ),
                            ),
                          ),

                          const Divider(height: 1, color: Color(0xFFF1F5F9)),

                          // 1. Push Alerts
                          NotificationRow(
                            title: 'Push Alerts',
                            value: pushAlerts,
                            onChanged: (val) =>
                                setState(() => pushAlerts = val),
                          ),

                          const Divider(height: 1, color: Color(0xFFF1F5F9)),

                          // 2. Email Reports
                          NotificationRow(
                            title: 'Email Reports',
                            value: emailReports,
                            onChanged: (val) =>
                                setState(() => emailReports = val),
                          ),

                          const Divider(height: 1, color: Color(0xFFF1F5F9)),

                          // 3. Emergency SMS
                          NotificationRow(
                            title: 'Emergency SMS',
                            value: emergencySms,
                            onChanged: (val) =>
                                setState(() => emergencySms = val),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundBackButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.Black.withValues(alpha: 0.15),
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Color(0xFF1E293B),
          size: 18,
        ),
      ),
    );
  }


}
