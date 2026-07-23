import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'security_privacy_providers.dart'; // import sharedPreferencesProvider

// StateNotifier to manage Push Notifications state with persistent storage
class PushNotificationsNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;
  static const _key = 'settings_push_notifications';

  PushNotificationsNotifier(this._prefs) : super(_prefs.getBool(_key) ?? true);

  Future<void> toggle(bool value) async {
    state = value;
    await _prefs.setBool(_key, value);
  }
}

// StateNotifier to manage Dark Mode state with persistent storage
class DarkModeNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;
  static const _key = 'settings_dark_mode';

  DarkModeNotifier(this._prefs) : super(_prefs.getBool(_key) ?? false);

  Future<void> toggle(bool value) async {
    state = value;
    await _prefs.setBool(_key, value);
  }
}

// Providers exposing notifier states
final pushNotificationsProvider = StateNotifierProvider<PushNotificationsNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PushNotificationsNotifier(prefs);
});

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return DarkModeNotifier(prefs);
});



