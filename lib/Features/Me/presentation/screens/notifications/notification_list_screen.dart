import 'package:flutter/material.dart';
import '../../../data/models/notification_model.dart';
import '../../widgets/notification_tile.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  // Sample Data matching the image provided
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'Almost Gone',
      body: 'Limited-time offer! Enjoy up to 40% off on selected furniture. Don\'t miss out! Shop now before it\'s too late!',
      timeAgo: '2h ago',

    ),
    NotificationModel(
      id: '2',
      title: 'Limited Offer! Claim \$50.00 Voucher',
      body: 'Sign up now and enjoy a \$50.00 voucher on your first purchase! Don\'t miss out',
      timeAgo: '2h ago',
    ),
    NotificationModel(
      id: '3',
      title: 'Unlock Your Exclusive Gift',
      body: 'Sign up now and enjoy a \$50.00 voucher on your first purchase! Don\'t miss out',
      timeAgo: '2h ago',
    ),
    NotificationModel(
      id: '4',
      title: 'Order Confirmed',
      body: 'We\'re preparing your order and will notify you once it\'s shipped. Track your order status anytime through the app.',
      timeAgo: '2h ago',
    ),
    NotificationModel(
      id: '5',
      title: 'Order Shipped',
      body: 'Great news! Your order has been shipped and is on its way to you. Expected delivery by 3 days. You can track your shipment.',
      timeAgo: '2h ago',
    ),
    NotificationModel(
      id: '6',
      title: 'Payment Received',
      body: 'Great news! The payment for your recent sale has been successfully processed. You can now check your balance.',
      timeAgo: '2h ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new,size: 21,),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: Container(
        child: ListView.separated(
          itemCount: _notifications.length,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          separatorBuilder: (context, index) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            final item = _notifications[index];
            return NotificationListTile(
              notification: item,
              onTap: () {
                // Handle click/navigation logic
              },
            );
          },
        ),
      ),
    );
  }
}