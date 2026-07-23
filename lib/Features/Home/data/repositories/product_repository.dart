import '../../../../core/services/api_client.dart';
import '../../../../core/services/api_endpoints.dart';
import '../../../ProductDetails/data/models/product_Analysis_models.dart';
import '../../../ProductDetails/data/models/product_model.dart';
import 'package:dio/dio.dart';
class ProductRepository {
  ProductRepository(this.apiClient);

  final ApiClient apiClient;

  Future<ProductsApiResponse> getProducts({
    required int page,
    int limit = 20,
    String? query,
  }) async {
    String url = ApiEndpoints.product;
    if (query != null && query.isNotEmpty) {
      url += "?q=$query&page=$page&limit=$limit";
    } else {
      url += "?page=$page&limit=$limit";
    }
    final result = await apiClient.get(
      url,
      parser: (json) => ProductsApiResponse.fromJson(json),
    );

    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }

  Future<List<PriceHistoryItem>> getPriceHistory(String id) async {
    final result = await apiClient.get(
      "/product/$id/price-history",
      parser: (json) {
        final responseData = json['response'] as Map<String, dynamic>? ?? {};
        final list = responseData['data'] as List? ?? [];
        return list.map((e) => PriceHistoryItem.fromJson(Map<String, dynamic>.from(e))).toList();
      },
    );

    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }


  Future<AnalysisStartResponse> Analysis(String url) async {
    final result = await apiClient.post(
      ApiEndpoints.analysis,
      data: {'url': url},
      parser: (json) => AnalysisStartResponse.fromJson(json as Map<String, dynamic>),
    );

    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }

  Future<AnalysisStartResponse> AnalyzeImage(String imagePath) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      ),
    });

    final result = await apiClient.upload<AnalysisStartResponse>(
      ApiEndpoints.analysis,
      formData: formData,
      parser: (json) => AnalysisStartResponse.fromJson(json as Map<String, dynamic>),
    );

    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }

  Future<AnalysisJobResponse> getAnalysisJobStatus(String jobId) async {
    final result = await apiClient.get(
      "/analyze/jobs/$jobId",
      parser: (json) => AnalysisJobResponse.fromJson(json as Map<String, dynamic>),
    );

    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }

  Future<ScannedProduct> getAnalysisJobResult(String jobId) async {
    final result = await apiClient.get(
      "/analyze/jobs/$jobId/result",
      parser: (json) {
        final data = (json['response']?['data'] ?? json['data'] ?? json) as Map<String, dynamic>;
        final productJson = Map<String, dynamic>.from(data['product'] as Map? ?? {});
        if (data['domainReport'] != null && data['domainReport'] is Map) {
          productJson['domain'] = data['domainReport'];
        }
        return ScannedProduct.fromJson(productJson);
      },
    );

    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }

  Future<ProductsApiResponse> getSaveProducts({
    required int page,
    int limit = 20,
    String? query,
  }) async {
    String url = ApiEndpoints.product;
    if (query != null && query.isNotEmpty) {
      url += "?q=$query&page=$page&limit=$limit";
    } else {
      url += "?page=$page&limit=$limit";
    }
    final result = await apiClient.get(
      url,
      parser: (json) => ProductsApiResponse.fromJson(json),
    );

    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }

  Future<AnalysisStartResponse> analyzeProductImage (String imagePath)async{

    final fromData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imagePath,filename: imagePath.split('/').last,
      )
    });
    final result = await apiClient.post(
      ApiEndpoints.analysis,
      data: fromData,
      parser: (json) => AnalysisStartResponse.fromJson(json as Map<String, dynamic>),
    );
    
    return result.when(
      success: (startResponse) => startResponse,
      failure: (e) => throw e,
    );
  }

}
