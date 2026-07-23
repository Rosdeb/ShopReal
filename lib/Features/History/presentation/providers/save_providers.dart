import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/login_providers.dart';
import '../../data/repositories/save_repositories.dart';
import '../../../ProductDetails/data/models/product_model.dart';

final saveRepositoryProvider = Provider<SaveRepositories>((ref) {
  return SaveRepositories(ref.read(apiClientProvider));
});

class BookmarkState {
  final List<BookmarkItem> bookmarks;
  final bool loadingMore;
  final bool hasMore;
  final int page;

  const BookmarkState({
    this.bookmarks = const [],
    this.loadingMore = false,
    this.hasMore = true,
    this.page = 1,
  });

  BookmarkState copyWith({
    List<BookmarkItem>? bookmarks,
    bool? loadingMore,
    bool? hasMore,
    int? page,
  }) {
    return BookmarkState(
      bookmarks: bookmarks ?? this.bookmarks,
      loadingMore: loadingMore ?? this.loadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}

final savedProductsProvider = AsyncNotifierProvider<SavedProductsNotifier, BookmarkState>(
  SavedProductsNotifier.new,
);

class SavedProductsNotifier extends AsyncNotifier<BookmarkState> {
  late SaveRepositories _repository;

  @override
  Future<BookmarkState> build() async {
    _repository = ref.read(saveRepositoryProvider);
    return loadFirstPage();
  }

  Future<BookmarkState> loadFirstPage() async {
    final response = await _repository.getBookmarks(page: 1);
    return BookmarkState(
      bookmarks: response.response.data,
      page: 1,
      hasMore: response.response.pagination.hasNextPage,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;

    state = AsyncData(current.copyWith(loadingMore: true));
    final nextPage = current.page + 1;

    try {
      final response = await _repository.getBookmarks(page: nextPage);
      state = AsyncData(
        current.copyWith(
          bookmarks: [...current.bookmarks, ...response.response.data],
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
    state = const AsyncLoading();
    state = AsyncData(await loadFirstPage());
  }

  Future<void> toggleSave(ScannedProduct product) async {
    final current = state.value;
    if (current == null) return;

    final existingIndex = current.bookmarks.indexWhere((b) => b.productId == product.id);
    final previousState = current;

    if (existingIndex != -1) {
      // Optimistic delete: remove from list instantly
      final bookmarkId = current.bookmarks[existingIndex].id;
      final newList = List<BookmarkItem>.from(current.bookmarks)..removeAt(existingIndex);
      state = AsyncData(current.copyWith(bookmarks: newList));

      try {
        await _repository.deleteBookmark(bookmarkId);
      } catch (e) {
        // Revert on error
        state = AsyncData(previousState);
      }
    } else {
      // Optimistic add: create temporary bookmark item instantly
      final tempBookmark = BookmarkItem(
        id: 'temp-${product.id}',
        userId: '',
        productId: product.id,
        isFavorite: false,
        product: product,
      );
      final newList = List<BookmarkItem>.from(current.bookmarks)..insert(0, tempBookmark);
      state = AsyncData(current.copyWith(bookmarks: newList));

      try {
        final newBookmark = await _repository.addBookmark(product.id);
        // Replace temp bookmark with the real one to get the actual ID
        if (state.value != null) {
          final updatedList = state.value!.bookmarks.map((b) {
            return b.productId == product.id ? newBookmark : b;
          }).toList();
          state = AsyncData(state.value!.copyWith(bookmarks: updatedList));
        }
      } catch (e) {
        // Revert on error
        state = AsyncData(previousState);
      }
    }
  }
}
