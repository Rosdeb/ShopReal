import '../../../../core/services/api_client.dart';
import '../../../ProductDetails/data/models/product_model.dart';

class SaveRepositories {
  SaveRepositories(this.apiClient);
  final ApiClient apiClient;

  Future<BookmarksApiResponse> getBookmarks({required int page, int limit = 20}) async {
    final result = await apiClient.get(
      "/bookmark?page=$page&limit=$limit",
      parser: (json) => BookmarksApiResponse.fromJson(json as Map<String, dynamic>),
    );

    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }

  Future<BookmarkItem> addBookmark(String productId) async {
    final result = await apiClient.post(
      "/bookmark/$productId",
      parser: (json) {
        final data = (json['response']?['data'] ?? json['data'] ?? json) as Map<String, dynamic>;
        return BookmarkItem.fromJson(data);
      },
    );

    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }

  Future<BookmarkItem> toggleFavorite(String bookmarkId) async {
    final result = await apiClient.patch(
      "/bookmark/favorite/$bookmarkId",
      parser: (json) {
        final data = (json['response']?['data'] ?? json['data'] ?? json) as Map<String, dynamic>;
        return BookmarkItem.fromJson(data);
      },
    );

    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }

  Future<bool> deleteBookmark(String bookmarkId) async {
    final result = await apiClient.delete(
      "/bookmark/delete/$bookmarkId",
      parser: (json) {
        return json['success'] as bool? ?? false;
      },
    );

    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }
}

class BookmarkItem {
  final String id;
  final String userId;
  final String productId;
  final bool isFavorite;
  final ScannedProduct? product;

  BookmarkItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.isFavorite,
    this.product,
  });

  factory BookmarkItem.fromJson(Map<String, dynamic> json) {
    return BookmarkItem(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      product: json['product'] != null ? ScannedProduct.fromJson(Map<String, dynamic>.from(json['product'])) : null,
    );
  }
}

class BookmarksApiResponse {
  final bool success;
  final int status;
  final String message;
  final BookmarksPayload response;

  BookmarksApiResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.response,
  });

  factory BookmarksApiResponse.fromJson(Map<String, dynamic> json) {
    final responseData = json['response'] as Map<String, dynamic>? ?? {};
    return BookmarksApiResponse(
      success: json['success'] as bool? ?? false,
      status: (json['status'] as num?)?.toInt() ?? 0,
      message: json['message']?.toString() ?? '',
      response: BookmarksPayload.fromJson(responseData),
    );
  }
}

class BookmarksPayload {
  final List<BookmarkItem> data;
  final Pagination pagination;

  BookmarksPayload({required this.data, required this.pagination});

  factory BookmarksPayload.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List? ?? [];
    return BookmarksPayload(
      data: list.map((e) => BookmarkItem.fromJson(Map<String, dynamic>.from(e))).toList(),
      pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>? ?? const {}),
    );
  }
}