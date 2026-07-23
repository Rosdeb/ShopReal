import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_endpoints.dart';
import '../../auth/presentation/providers/login_providers.dart';
import '../data/models/product_model.dart';

// FutureProvider to fetch list of scanned products from backend
final productsListProvider = FutureProvider<ProductsApiResponse>((ref) async {
  final apiClient = ref.watch(apiClientProvider);

  final result = await apiClient.get<ProductsApiResponse>(
    ApiEndpoints.product,
    parser: (json) => ProductsApiResponse.fromJson(json),
  );

  return result.when(
    success: (response) => response,
    failure: (exception) => throw exception,
  );
});

// FutureProvider to fetch single product by id
final singleProductProvider = FutureProvider.family<ScannedProduct, String>((ref, id) async {
  final apiClient = ref.watch(apiClientProvider);

  // Replace ID parameter in endpoint path
  final path = ApiEndpoints.get_product.replaceAll('{id}', id);

  final result = await apiClient.get<ScannedProduct>(
    path,
    parser: (json) {
      final responseObj = json['response'] ?? json;
      final data = responseObj['data'] ?? responseObj;
      return ScannedProduct.fromJson(data);
    },
  );

  return result.when(
    success: (product) => product,
    failure: (exception) => throw exception,
  );
});
