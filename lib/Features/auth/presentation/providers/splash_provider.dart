import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/utils/jwt_utils.dart';
import 'login_providers.dart'; // To access tokenServiceProvider

final splashProvider = StateNotifierProvider.autoDispose<SplashNotifier, Color>((ref) => SplashNotifier(ref));

class SplashNotifier extends StateNotifier<Color> {
  final Ref _ref;
  SplashNotifier(this._ref) : super(Colors.yellow);

  final List<Color> colors = [Colors.yellow, Colors.blue, Colors.green];
  int index = 0;
  Timer? _timer;

  /// Starts the splash color animation timer and decides routing after 2 seconds.
  void startAnimation(BuildContext context) {
    if (_timer?.isActive ?? false) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      index = (index + 1) % colors.length;
      state = colors[index];

      // After 2 ticks (2 seconds), check authentication and navigate
      if (timer.tick >= 2) {
        timer.cancel();

        if (context.mounted) {
          await _handleNavigation(context);
        }
      }
    });
  }

  /// Determines if the user has a valid, non-expired session token.
  /// Routes to the main menu on success, or the login screen on failure/expiry.
  Future<void> _handleNavigation(BuildContext context) async {
    final tokenService = _ref.read(tokenServiceProvider);
    final token = tokenService.accessToken;

    if (token != null && token.isNotEmpty) {
      final isExpired = JwtUtils.isTokenExpired(token);
      if (!isExpired) {
        // Session is valid, go to home menu
        context.go(AppPaths.bottom_manu);
        return;
      }
    }

    // No valid token exists or the token has expired, go to login
    context.go(AppPaths.login);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
