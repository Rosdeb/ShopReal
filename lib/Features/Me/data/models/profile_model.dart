class ProfileModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? avatar;
  final String role;
  final bool isEmailVerified;
  final String? phoneNumber;
  final String? bio;
  final bool notificationEnabled;
  final bool analysisUpdate;
  final bool productUpdate;
  final bool tipsOffers;
  final String activePlanName;
  final int scansLimit;
  final int savedProductsLimit;
  final int scansToday;
  final int savesToday;

  ProfileModel({
    required this.id,
    required this.name,
    this.username = '',
    required this.email,
    this.avatar,
    required this.role,
    required this.isEmailVerified,
    this.phoneNumber,
    this.bio,
    required this.notificationEnabled,
    required this.analysisUpdate,
    required this.productUpdate,
    required this.tipsOffers,
    required this.activePlanName,
    required this.scansLimit,
    required this.savedProductsLimit,
    required this.scansToday,
    required this.savesToday,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // API returns response: { response: { data: { ... } } }
    final responseObj = json['response'] ?? json;
    final data = responseObj['data'] ?? responseObj;

    // Parse notification metadata settings safely
    final metadata = data['metadata'] as Map<String, dynamic>?;
    final notification =
        metadata != null ? metadata['notification'] as Map<String, dynamic>? : null;

    // Parse active subscription and active plan details safely
    final subscriptions = data['subscriptions'] as List<dynamic>?;
    String planName = 'Free';
    int scansLimitVal = 10;
    int savesLimitVal = 20;

    if (subscriptions != null && subscriptions.isNotEmpty) {
      final activeSub = subscriptions.firstWhere(
        (sub) => sub['status'] == 'active',
        orElse: () => subscriptions.first,
      );
      if (activeSub != null && activeSub['plan'] != null) {
        final plan = activeSub['plan'] as Map<String, dynamic>;
        planName = plan['name'] ?? 'Free';
        scansLimitVal = plan['scansPerPeriod'] ?? 10;
        savesLimitVal = plan['savedProducts'] ?? 20;
      }
    }

    final counts = data['_count'] as Map<String, dynamic>?;
    final name = (data['name'] ?? data['fullName'] ?? '') as String;
    final username = (data['username'] ?? '') as String;

    return ProfileModel(
      id: data['id'] ?? '',
      name: name,
      username: username,
      email: data['email'] ?? '',
      avatar: data['avatar'],
      role: data['role'] ?? 'user',
      isEmailVerified: data['isEmailVerified'] ?? false,
      phoneNumber: data['phoneNumber'],
      bio: data['bio'],
      notificationEnabled: notification?['enable'] ?? true,
      analysisUpdate: notification?['analysis_update'] ?? true,
      productUpdate: notification?['product_update'] ?? true,
      tipsOffers: notification?['tips_offers'] ?? true,
      activePlanName: planName,
      scansLimit: scansLimitVal,
      savedProductsLimit: savesLimitVal,
      scansToday: counts?['analyzeToday'] ?? 0,
      savesToday: counts?['savesToday'] ?? 0,
    );
  }

  ProfileModel copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? avatar,
    String? role,
    bool? isEmailVerified,
    String? phoneNumber,
    String? bio,
    bool? notificationEnabled,
    bool? analysisUpdate,
    bool? productUpdate,
    bool? tipsOffers,
    String? activePlanName,
    int? scansLimit,
    int? savedProductsLimit,
    int? scansToday,
    int? savesToday,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      analysisUpdate: analysisUpdate ?? this.analysisUpdate,
      productUpdate: productUpdate ?? this.productUpdate,
      tipsOffers: tipsOffers ?? this.tipsOffers,
      activePlanName: activePlanName ?? this.activePlanName,
      scansLimit: scansLimit ?? this.scansLimit,
      savedProductsLimit: savedProductsLimit ?? this.savedProductsLimit,
      scansToday: scansToday ?? this.scansToday,
      savesToday: savesToday ?? this.savesToday,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'avatar': avatar,
      'role': role,
      'isEmailVerified': isEmailVerified,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'metadata': {
        'notification': {
          'enable': notificationEnabled,
          'analysis_update': analysisUpdate,
          'product_update': productUpdate,
          'tips_offers': tipsOffers,
        }
      },
      'activePlanName': activePlanName,
      'scansLimit': scansLimit,
      'savedProductsLimit': savedProductsLimit,
      'scansToday': scansToday,
      'savesToday': savesToday,
    };
  }
}
