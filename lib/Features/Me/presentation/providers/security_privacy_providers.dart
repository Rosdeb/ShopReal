import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences has not been initialized. Initialize it in main.dart first.');
});

class TwoFactorNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;
  static const _key = 'security_two_factor_enabled';

  TwoFactorNotifier(this._prefs) : super(_prefs.getBool(_key) ?? false);

  Future<void> toggle(bool value) async {
    state = value;
    await _prefs.setBool(_key, value);
  }
}

class BiometricNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;
  static const _key = 'security_biometric_enabled';

  BiometricNotifier(this._prefs) : super(_prefs.getBool(_key) ?? true);

  Future<void> toggle(bool value) async {
    state = value;
    await _prefs.setBool(_key, value);
  }
}

final twoFactorProvider = StateNotifierProvider<TwoFactorNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return TwoFactorNotifier(prefs);
});

final biometricProvider = StateNotifierProvider<BiometricNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return BiometricNotifier(prefs);
});