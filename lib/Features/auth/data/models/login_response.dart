class LoginResponse {
  final bool success;
  final int status;
  final String message;
  final LoginDataResponse response;

  LoginResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.response,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      response: LoginDataResponse.fromJson(
        json['response'] as Map<String, dynamic>,
      ),
    );
  }
}

class LoginDataResponse {
  final UserData data;
  final LoginTokens tokens;

  LoginDataResponse({required this.data, required this.tokens});

  factory LoginDataResponse.fromJson(Map<String, dynamic> json) {
    return LoginDataResponse(
      data: UserData.fromJson(json['data']),
      tokens: LoginTokens.fromJson(json['tokens']),
    );
  }
}

class UserData {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatar;
  final bool isEmailVerified;
  final String? phoneNumber;
  final String? countryCode;
  final bool isRestricted;
  final String? restrictionReason;
  final String? bio;
  final bool isOnline;
  final String? lastSeen;
  final String? lastLoginAt;
  final Subscription subscription;
  final UserCount count;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
    required this.isEmailVerified,
    this.phoneNumber,
    this.countryCode,
    required this.isRestricted,
    this.restrictionReason,
    this.bio,
    required this.isOnline,
    this.lastSeen,
    this.lastLoginAt,
    required this.subscription,
    required this.count,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      avatar: json['avatar'],
      isEmailVerified: json['isEmailVerified'] ?? false,
      phoneNumber: json['phoneNumber'],
      countryCode: json['countryCode'],
      isRestricted: json['isRestricted'] ?? false,
      restrictionReason: json['restrictionReason'],
      bio: json['bio'],
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'],
      lastLoginAt: json['lastLoginAt'],
      subscription: Subscription.fromJson(json['subscription']),
      count: UserCount.fromJson(json['_count']),
    );
  }
}

class LoginTokens {
  final Token access;
  final Token refresh;

  LoginTokens({required this.access, required this.refresh});

  factory LoginTokens.fromJson(Map<String, dynamic> json) {
    return LoginTokens(
      access: Token.fromJson(json['access']),
      refresh: Token.fromJson(json['refresh']),
    );
  }
}

class Token {
  final String token;
  final String expiresAt;

  Token({required this.token, required this.expiresAt});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token'] ?? '',
      expiresAt: json['expiresAt'] ?? '',
    );
  }
}

class Subscription {
  final String id;
  final String planId;
  final String userId;
  final String status;
  final bool autoRenew;
  final String? expiresAt;
  final Plan plan;

  Subscription({
    required this.id,
    required this.planId,
    required this.userId,
    required this.status,
    required this.autoRenew,
    this.expiresAt,
    required this.plan,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] ?? '',
      planId: json['planId'] ?? '',
      userId: json['userId'] ?? '',
      status: json['status'] ?? '',
      autoRenew: json['autoRenew'] ?? false,
      expiresAt: json['expiresAt'],
      plan: Plan.fromJson(json['plan']),
    );
  }
}

class Plan {
  final String id;
  final String name;
  final String description;
  final String type;
  final int price;
  final int scansPerPeriod;
  final int savedProducts;

  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.price,
    required this.scansPerPeriod,
    required this.savedProducts,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      price: json['price'] ?? 0,
      scansPerPeriod: json['scansPerPeriod'] ?? 0,
      savedProducts: json['savedProducts'] ?? 0,
    );
  }
}

class UserCount {
  final int analyzeToday;
  final int savesToday;

  UserCount({required this.analyzeToday, required this.savesToday});

  factory UserCount.fromJson(Map<String, dynamic> json) {
    return UserCount(
      analyzeToday: json['analyzeToday'] ?? 0,
      savesToday: json['savesToday'] ?? 0,
    );
  }
}
