import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:messageapp/core/services/api_exceptions.dart';
import 'package:messageapp/core/services/token_service.dart';

import '../../../auth/presentation/providers/login_providers.dart';
import '../../data/models/profile_model.dart';
import '../../data/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(apiClientProvider));
});

/// Riverpod provider for fetching user profile using ApiClient
final profileFutureProvider = FutureProvider<ProfileModel>((ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getProfile();
});

// --- Update profile state ---

sealed class ProfileUpdateState {
  const ProfileUpdateState();
}

class ProfileUpdateInitial extends ProfileUpdateState {
  const ProfileUpdateInitial();
}

class ProfileUpdateLoading extends ProfileUpdateState {
  const ProfileUpdateLoading();
}

class ProfileUpdateSuccess extends ProfileUpdateState {
  final ProfileModel profile;
  const ProfileUpdateSuccess(this.profile);
}

class ProfileUpdateFailure extends ProfileUpdateState {
  final AppException error;
  const ProfileUpdateFailure(this.error);
}

final profileUpdateControllerProvider = StateNotifierProvider.autoDispose<
    ProfileUpdateController, ProfileUpdateState>((ref) {
  return ProfileUpdateController(
    ref.watch(profileRepositoryProvider),
    ref.watch(tokenServiceProvider),
    ref,
  );
});

class ProfileUpdateController extends StateNotifier<ProfileUpdateState> {
  final ProfileRepository _repository;
  final TokenService _tokenService;
  final Ref _ref;

  ProfileUpdateController(this._repository, this._tokenService, this._ref)
      : super(const ProfileUpdateInitial());

  Future<void> updateProfile({
    required String name,
    String? avatarPath,
  }) async {
    state = const ProfileUpdateLoading();

    try {
      final updated = await _repository.updateProfile(
        name: name.trim(),
        avatarPath: avatarPath,
      );

      await _tokenService.saveUserName(updated.name);
      await _tokenService.saveUserAvatar(updated.avatar);

      // Refresh Me / Home profile consumers
      _ref.invalidate(profileFutureProvider);

      state = ProfileUpdateSuccess(updated);
    } on AppException catch (e) {
      state = ProfileUpdateFailure(e);
    } catch (e) {
      state = ProfileUpdateFailure(
        UnknownException(e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  void reset() => state = const ProfileUpdateInitial();
}
