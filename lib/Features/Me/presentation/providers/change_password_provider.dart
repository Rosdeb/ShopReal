import 'package:flutter_riverpod/legacy.dart';
import 'package:messageapp/core/services/api_exceptions.dart';
import 'package:messageapp/core/services/auth_api_service.dart';
import 'package:messageapp/Features/auth/presentation/providers/login_providers.dart';

sealed class ChangePasswordState {
  const ChangePasswordState();
}

class ChangePasswordInitial extends ChangePasswordState {
  const ChangePasswordInitial();
}

class ChangePasswordLoading extends ChangePasswordState {
  const ChangePasswordLoading();
}

class ChangePasswordSuccess extends ChangePasswordState {
  const ChangePasswordSuccess();
}

class ChangePasswordFailure extends ChangePasswordState {
  final AppException error;
  const ChangePasswordFailure(this.error);
}

final changePasswordControllerProvider = StateNotifierProvider.autoDispose<
    ChangePasswordController, ChangePasswordState>((ref) {
  return ChangePasswordController(ref.watch(authApiServiceProvider));
});

class ChangePasswordController extends StateNotifier<ChangePasswordState> {
  final AuthApiService _authApiService;

  ChangePasswordController(this._authApiService)
      : super(const ChangePasswordInitial());

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    state = const ChangePasswordLoading();

    final result = await _authApiService.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );

    result.when(
      success: (_) {
        state = const ChangePasswordSuccess();
      },
      failure: (error) {
        state = ChangePasswordFailure(error);
      },
    );
  }

  void reset() => state = const ChangePasswordInitial();
}
