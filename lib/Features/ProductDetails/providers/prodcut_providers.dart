import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../Home/data/repositories/product_repository.dart';
import '../../Home/presentation/providers/product_state.dart';
import '../../auth/presentation/providers/login_providers.dart';
import '../data/models/product_model.dart';





final productsProvider =
AsyncNotifierProvider<ProductNotifier, ProductState>(
  ProductNotifier.new,
);


class ProductNotifier extends AsyncNotifier<ProductState> {

  late ProductRepository repository;

  @override
  Future<ProductState> build() async {

    repository = ProductRepository(ref.read(apiClientProvider));

    return loadFirstPage();
  }

  Future<ProductState> loadFirstPage() async {

    final response = await repository.getProducts(page: 1);

    return ProductState(
      products: response.response.data,
      page: 1,
      hasMore: response.response.pagination.hasNextPage,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;

    if (current == null) return;

    if (!current.hasMore) return;

    state = AsyncData(
      current.copyWith(
        loadingMore: true,
      ),
    );

    final nextPage = current.page + 1;

    final response = await repository.getProducts(
      page: nextPage,
    );

    state = AsyncData(
      current.copyWith(
        products: [
          ...current.products,
          ...response.response.data,
        ],
        page: nextPage,
        hasMore: response.response.pagination.hasNextPage,
        loadingMore: false,
      ),
    );
  }

  Future<void> refresh() async {

    state = const AsyncLoading();

    state = AsyncData(await loadFirstPage());
  }
}

/// Provider to hold the search query for the history screen
final historySearchQueryProvider = StateProvider<String>((ref) => '');

/// Dedicated provider for Paginated scan history with search querying
final historyProductsProvider = StateNotifierProvider<HistoryProductsNotifier, AsyncValue<ProductState>>((ref) {
  // Watch the search query so changing it automatically rebuilds this provider with the new query
  ref.watch(historySearchQueryProvider);
  final repository = ProductRepository(ref.read(apiClientProvider));
  return HistoryProductsNotifier(ref, repository);
});

class HistoryProductsNotifier extends StateNotifier<AsyncValue<ProductState>> {
  final Ref _ref;
  final ProductRepository _repository;
  ProviderSubscription<String>? _querySubscription;

  HistoryProductsNotifier(this._ref, this._repository) : super(const AsyncLoading()) {
    // Listen to query changes to update results smoothly without destroying the StateNotifier instance
    _querySubscription = _ref.listen<String>(historySearchQueryProvider, (previous, next) {
      if (previous != next) {
        fetchFirstPage(next);
      }
    });

    final query = _ref.read(historySearchQueryProvider);
    fetchFirstPage(query);
  }

  Future<void> fetchFirstPage(String query) async {
    // Only show full screen shimmers on initial load when there is no data
    if (state is! AsyncData) {
      state = const AsyncLoading();
    }
    
    try {
      final response = await _repository.getProducts(page: 1, query: query);
      state = AsyncData(ProductState(
        products: response.response.data,
        page: 1,
        hasMore: response.response.pagination.hasNextPage,
      ));
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;

    state = AsyncData(current.copyWith(loadingMore: true));

    final nextPage = current.page + 1;
    final query = _ref.read(historySearchQueryProvider);

    try {
      final response = await _repository.getProducts(page: nextPage, query: query);

      state = AsyncData(
        current.copyWith(
          products: [...current.products, ...response.response.data],
          page: nextPage,
          hasMore: response.response.pagination.hasNextPage,
          loadingMore: false,
        ),
      );
    } catch (e) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }

  Future<void> refresh() async {
    final query = _ref.read(historySearchQueryProvider);
    await fetchFirstPage(query);
  }

  @override
  void dispose() {
    _querySubscription?.close();
    super.dispose();
  }
}

/// Provider to fetch product price history dynamically
final priceHistoryProvider = FutureProvider.family<List<PriceHistoryItem>, String>((ref, id) async {
  final repository = ProductRepository(ref.read(apiClientProvider));
  return repository.getPriceHistory(id);
});


