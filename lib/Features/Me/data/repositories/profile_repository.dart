import 'package:dio/dio.dart';
import 'package:messageapp/core/services/api_client.dart';
import 'package:messageapp/core/services/api_endpoints.dart';

import '../models/profile_model.dart';

class ProfileRepository {
  final ApiClient apiClient;

  ProfileRepository(this.apiClient);

  Future<ProfileModel> getProfile() async {
    final result = await apiClient.get<ProfileModel>(
      ApiEndpoints.profile,
      parser: (json) => ProfileModel.fromJson(json as Map<String, dynamic>),
    );

    return result.when(
      success: (profile) => profile,
      failure: (e) => throw e,
    );
  }

  /// PATCH /user/self/update as multipart/form-data.
  /// [avatarPath] is only attached when it is a local file path (not http/https).
  Future<ProfileModel> updateProfile({
    required String name,
    String? avatarPath,
  }) async {
    final map = <String, dynamic>{
      'name': name,
    };

    if (avatarPath != null &&
        avatarPath.isNotEmpty &&
        !_isNetworkUrl(avatarPath)) {
      map['avatar'] = await MultipartFile.fromFile(
        avatarPath,
        filename: avatarPath.split(RegExp(r'[\\/]')).last,
      );
    }

    final formData = FormData.fromMap(map);

    final result = await apiClient.uploadPatch<ProfileModel>(
      ApiEndpoints.updateProfile,
      formData: formData,
      parser: (json) => ProfileModel.fromJson(json as Map<String, dynamic>),
    );

    return result.when(
      success: (profile) => profile,
      failure: (e) => throw e,
    );
  }

  bool _isNetworkUrl(String value) {
    final lower = value.toLowerCase();
    return lower.startsWith('http://') || lower.startsWith('https://');
  }
}
