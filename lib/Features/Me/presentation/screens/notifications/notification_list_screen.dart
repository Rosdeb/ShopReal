import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Home/presentation/providers/notification_providers.dart';
import '../../widgets/notification_shimmer.dart';
import '../../widgets/notification_tile.dart';

class NotificationListScreen extends ConsumerWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationAsync = ref.watch(notificationProvider);

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
      body: notificationAsync.when(
        loading: () =>NotificationShimmerList(),
        error: (e, st) => Center(
          child: Text(e.toString()),
        ),
        data: (response) {
          final notifications = response.notifications;
          if (notifications.isEmpty) {
            return const Center(
              child: Text("No notifications found"),
            );
          }
          if (notificationAsync.isRefreshing) {
            return const NotificationShimmerList();
          }
          return RefreshIndicator(
            onRefresh: ()async{
              await ref.read(notificationProvider.notifier).refresh();
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: notifications.length,
              itemBuilder: (_, index) {
                final item = notifications[index];
                return NotificationListTile(
                  notification: item,
                  onTap: ()async{
                    await ref.read(markNotificationReadProvider.notifier)
                        .markAsRead(item.id.toString());
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}


class NotificationShimmerList extends StatelessWidget {
  const NotificationShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      itemBuilder: (_, __) => const NotificationTileShimmer(),
    );
  }
}
