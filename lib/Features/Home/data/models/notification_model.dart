class NotificationResponse {
  final List<AppNotification> notifications;
  final NotificationPagination pagination;

  NotificationResponse({
    required this.notifications,
    required this.pagination,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    final response = json['response'] as Map<String, dynamic>;

    return NotificationResponse(
      notifications: (response['data'] as List)
          .map((e) => AppNotification.fromJson(e))
          .toList(),
      pagination: NotificationPagination.fromJson(response['pagination']),
    );
  }
}

class AppNotification {
  final String id;
  final String userId;
  final String type;
  final String status;
  final String title;
  final String message;
  final String scope;
  final NotificationData data;
  final String? imageUrl;
  final String? actionUrl;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final NotificationUser user;

  AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.title,
    required this.message,
    required this.scope,
    required this.data,
    this.imageUrl,
    this.actionUrl,
    required this.isRead,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      status: json['status'],
      title: json['title'],
      message: json['message'],
      scope: json['scope'],
      data: NotificationData.fromJson(json['data']),
      imageUrl: json['imageUrl'],
      actionUrl: json['actionUrl'],
      isRead: json['isRead'],
      readAt:
      json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: NotificationUser.fromJson(json['user']),
    );
  }
}

class NotificationData {
  final String productId;
  final String scanResult;

  NotificationData({
    required this.productId,
    required this.scanResult,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      productId: json['productId'],
      scanResult: json['scanResult'],
    );
  }
}

class NotificationUser {
  final String id;
  final String name;
  final String email;

  NotificationUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory NotificationUser.fromJson(Map<String, dynamic> json) {
    return NotificationUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

class NotificationPagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  NotificationPagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory NotificationPagination.fromJson(Map<String, dynamic> json) {
    return NotificationPagination(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
      hasNextPage: json['hasNextPage'],
      hasPrevPage: json['hasPrevPage'],
    );
  }
}