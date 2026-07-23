import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  TokenService._();

  static final TokenService instance = TokenService._();

  static late SharedPreferences _prefs;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'save_user_email';
  static const String _userNameKey = 'user_name';
  static const String _userAvatarKey = 'user_avatar';

  /// Initialize once in main()
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save
  Future<void> saveToken(String token) async {
    await _prefs.setString(_accessTokenKey, token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_refreshTokenKey, token);
  }

  Future<void> saveUserId(String id) async {
    await _prefs.setString(_userIdKey, id);
  }

  Future<void> saveUserEmail(String email) async {
    await _prefs.setString(_userEmailKey, email);
  }

  Future<void> saveUserName(String name) async {
    await _prefs.setString(_userNameKey, name);
  }

  Future<void> saveUserAvatar(String? avatarUrl) async {
    if (avatarUrl != null) {
      await _prefs.setString(_userAvatarKey, avatarUrl);
    } else {
      await _prefs.remove(_userAvatarKey);
    }
  }

  // Get
  String? get accessToken => _prefs.getString(_accessTokenKey);

  String? get refreshToken => _prefs.getString(_refreshTokenKey);

  String? get userId => _prefs.getString(_userIdKey);

  String? get userEmail => _prefs.getString(_userEmailKey);

  String? get userName => _prefs.getString(_userNameKey);

  String? get userAvatar => _prefs.getString(_userAvatarKey);

  // Clear
  Future<void> clearTokens() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userEmailKey);
    await _prefs.remove(_userNameKey);
    await _prefs.remove(_userAvatarKey);
  }
}