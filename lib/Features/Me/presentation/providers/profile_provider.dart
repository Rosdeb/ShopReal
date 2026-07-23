import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/api_endpoints.dart';
import '../../../../core/services/api_result.dart';
import '../../../auth/presentation/providers/login_providers.dart';
import '../../data/models/profile_model.dart';

// Riverpod provider for fetching user profile using ApiClient
final profileFutureProvider = FutureProvider<ProfileModel>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  
  final result = await apiClient.get<ProfileModel>(
    ApiEndpoints.profile,
    parser: (json) => ProfileModel.fromJson(json),
  );

  return result.when(
    success: (profile) => profile,
    failure: (exception) => throw exception,
  );
});
