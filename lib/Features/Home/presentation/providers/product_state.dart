import '../../../ProductDetails/data/models/product_model.dart';

class ProductState {
  final List<ScannedProduct> products;
  final bool loadingMore;
  final bool hasMore;
  final int page;

  const ProductState({
    this.products = const [],
    this.loadingMore = false,
    this.hasMore = true,
    this.page = 1,
  });

  ProductState copyWith({
    List<ScannedProduct>? products,
    bool? loadingMore,
    bool? hasMore,
    int? page,
  }) {
    return ProductState(
      products: products ?? this.products,
      loadingMore: loadingMore ?? this.loadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}