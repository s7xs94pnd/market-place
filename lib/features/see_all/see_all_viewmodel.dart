import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace/features/home/home_repository.dart';
import 'package:marketplace/features/home/home_viewmodel.dart';
import 'package:marketplace/features/home/models.dart';
import 'package:marketplace/features/see_all/see_all_state.dart';

class SeeAllViewModel extends StateNotifier<SeeAllState> {
  final HomeRepository _repository;
  final String type;
  int _page = 1;
  static const int _perPage = 20;

  SeeAllViewModel(this._repository, this.type) : super(SeeAllState()) {
    loadItems();
  }

  Future<void> loadItems() async {
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final items = await _fetchItems();
      state = state.copyWith(
        items: [...state.items, ...items],
        isLoading: false,
        hasMore: items.length == _perPage,
      );
      _page++;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Не удалось загрузить товары',
      );
    }
  }

  Future<List<ProductItem>> _fetchItems() async {
    switch (type) {
      case 'popular':
        return await _repository.fetchPopularProducts(page: _page);
      case 'sale':
        return await _repository.fetchSaleProducts(page: _page);
      case 'recommended':
        return await _repository.fetchRecommendedProducts(page: _page);
      default:
        return [];
    }
  }

  Future<void> refresh() async {
    _page = 1;
    state = state.copyWith(items: [], hasMore: true);
    await loadItems();
  }
}

final seeAllViewModelProvider = StateNotifierProvider.family<SeeAllViewModel, SeeAllState, String>(
  (ref, type) {
    final repository = ref.read(homeRepositoryProvider);
    return SeeAllViewModel(repository, type);
  },
);
