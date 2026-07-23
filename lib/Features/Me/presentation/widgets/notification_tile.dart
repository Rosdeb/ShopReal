import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Home/data/models/notification_model.dart';

class NotificationListTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;

  const NotificationListTile({
    Key? key,
    required this.notification,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryOrange = Color(0xFFFF6B2C);
    const Color softOrangeBg = Color(0xFFFFF3ED);

    return InkWell(
      onTap: onTap,
      child: Container(
        color: notification.isRead ? Colors.transparent : softOrangeBg.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular Orange Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: softOrangeBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications,
                color: primaryOrange,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Content Column (Title, Description, Time)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Timestamp Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w800,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Text(
                            _formatTimeAgo(notification.createdAt.toString()),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (!notification.isRead) ...[
                            const SizedBox(width: 6),
                            const CircleAvatar(
                              radius: 4,
                              backgroundColor: primaryOrange,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Subtitle / Description Body
                  Text(
                    notification.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: notification.isRead ? Colors.grey.shade600 : Colors.black87,
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

  String _formatTimeAgo(String date) {
    final DateTime time = DateTime.parse(date).toLocal();
    final Duration difference = DateTime.now().difference(time);

    if (difference.inSeconds < 60) {
      return "Just now";
    }

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    }

    if (difference.inHours < 24) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    }

    if (difference.inDays == 1) {
      return "Yesterday";
    }

    if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    }

    return DateFormat("MMM d, yyyy").format(time);
  }

}