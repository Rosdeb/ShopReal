import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messageapp/Features/Home/data/models/notification_model.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/api_endpoints.dart';
import '../../../auth/presentation/providers/login_providers.dart';

final notificationProvider =
AsyncNotifierProvider<NotificationNotifier, NotificationResponse>(
  NotificationNotifier.new,
);

class NotificationNotifier extends AsyncNotifier<NotificationResponse> {
  @override
  Future<NotificationResponse> build() async {
    return _fetchNotifications();
  }

  Future<NotificationResponse> _fetchNotifications() async {
    final apiClient = ref.read(apiClientProvider);

    final result = await apiClient.get<NotificationResponse>(
      ApiEndpoints.notification,
      parser: (json) => NotificationResponse.fromJson(json),
    );

    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }


  Future<void> refresh() async {
    final oldData = state.value;

    final result = await AsyncValue.guard(() async {
      return await _fetchNotifications();
    });

    result.whenData((newData) {
      state = AsyncData(newData);
    });

    if (result.hasError && oldData != null) {
      state = AsyncData(oldData);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final apiClient = ref.read(apiClientProvider);

    final result = await apiClient.patch<void>(
      '${ApiEndpoints.notification}/$notificationId/mark-read',
      parser: (_) {},
    );

    result.when(
      success: (_) async {
        await refresh();
      },
      failure: (e) {
        state = AsyncError(e, StackTrace.current);
      },
    );
  }
}


final markNotificationReadProvider =
AsyncNotifierProvider<MarkNotificationReadNotifier, void>(
  MarkNotificationReadNotifier.new,
);

class MarkNotificationReadNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> markAsRead(String notificationId) async {
    state = const AsyncLoading();

    final apiClient = ref.read(apiClientProvider);

    final result = await apiClient.patch<void>(
      '${ApiEndpoints.notification}/$notificationId/mark-read',
      parser: (_) {},
    );

    result.when(
      success: (_) {
        state = const AsyncData(null);
        ref.invalidate(notificationProvider);
      },
      failure: (e) {
        state = AsyncError(e, StackTrace.current);
      },
    );
  }
}