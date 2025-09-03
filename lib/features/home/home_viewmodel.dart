import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'home_repository.dart';

class HomeState {
  final bool isLoading;
  final String? error;
  final List<HomeBanner> banners;
  final List<CategoryItem> categories;
  final List<ProductItem> popular;
  final List<ProductItem> recommendations;
  final List<ProductItem> sales;
  final List<BrandItem> brands;
  final List<ReviewItem> reviews;
  final int cartCount;
  final Set<String> favorites;
  final String currentFilter; // all | sale | popular | recommended | new
  final int popularPage;
  final int recommendationsPage;
  final int salesPage;
  final bool isLoadingMorePopular;
  final bool isLoadingMoreRecommendations;
  final bool isLoadingMoreSales;

  const HomeState({
    this.isLoading = false,
    this.error,
    this.banners = const [],
    this.categories = const [],
    this.popular = const [],
    this.recommendations = const [],
    this.sales = const [],
    this.brands = const [],
    this.reviews = const [],
    this.cartCount = 0,
    this.favorites = const {},
    this.currentFilter = 'all',
    this.popularPage = 1,
    this.recommendationsPage = 1,
    this.salesPage = 1,
    this.isLoadingMorePopular = false,
    this.isLoadingMoreRecommendations = false,
    this.isLoadingMoreSales = false,
  });

  HomeState copyWith({
    bool? isLoading,
    String? error,
    List<HomeBanner>? banners,
    List<CategoryItem>? categories,
    List<ProductItem>? popular,
    List<ProductItem>? recommendations,
    List<ProductItem>? sales,
    List<BrandItem>? brands,
    List<ReviewItem>? reviews,
    int? cartCount,
    Set<String>? favorites,
    String? currentFilter,
    int? popularPage,
    int? recommendationsPage,
    int? salesPage,
    bool? isLoadingMorePopular,
    bool? isLoadingMoreRecommendations,
    bool? isLoadingMoreSales,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      banners: banners ?? this.banners,
      categories: categories ?? this.categories,
      popular: popular ?? this.popular,
      recommendations: recommendations ?? this.recommendations,
      sales: sales ?? this.sales,
      brands: brands ?? this.brands,
      reviews: reviews ?? this.reviews,
      cartCount: cartCount ?? this.cartCount,
      favorites: favorites ?? this.favorites,
      currentFilter: currentFilter ?? this.currentFilter,
      popularPage: popularPage ?? this.popularPage,
      recommendationsPage: recommendationsPage ?? this.recommendationsPage,
      salesPage: salesPage ?? this.salesPage,
      isLoadingMorePopular: isLoadingMorePopular ?? this.isLoadingMorePopular,
      isLoadingMoreRecommendations: isLoadingMoreRecommendations ?? this.isLoadingMoreRecommendations,
      isLoadingMoreSales: isLoadingMoreSales ?? this.isLoadingMoreSales,
    );
  }
}

class HomeViewModel extends StateNotifier<HomeState> {
  final HomeRepository repository;
  HomeViewModel(this.repository) : super(const HomeState());

  Future<void> loadAll() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
        popularPage: 1,
        recommendationsPage: 1,
        salesPage: 1,
      );
      final results = await Future.wait([
        repository.fetchBanners(),
        repository.fetchCategories(),
        repository.fetchPopularProducts(),
        repository.fetchRecommendedProducts(),
        repository.fetchSaleProducts(),
        repository.fetchBrands(),
        repository.fetchReviews(),
      ]);
      state = state.copyWith(
        isLoading: false,
        banners: results[0] as List<HomeBanner>,
        categories: results[1] as List<CategoryItem>,
        popular: results[2] as List<ProductItem>,
        recommendations: results[3] as List<ProductItem>,
        sales: results[4] as List<ProductItem>,
        brands: results[5] as List<BrandItem>,
        reviews: results[6] as List<ReviewItem>,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setFilter(String filterKey) {
    state = state.copyWith(currentFilter: filterKey);
  }

  void toggleFavorite(String productId) {
    final favs = Set<String>.from(state.favorites);
    if (favs.contains(productId)) {
      favs.remove(productId);
    } else {
      favs.add(productId);
    }
    state = state.copyWith(favorites: favs);
  }

  void addToCart(String productId) {
    state = state.copyWith(cartCount: state.cartCount + 1);
  }

  Future<void> loadMorePopular() async {
    if (state.isLoadingMorePopular) return;
    state = state.copyWith(isLoadingMorePopular: true);
    try {
      final next = state.popularPage + 1;
      final more = await repository.fetchPopularProducts(page: next);
      state = state.copyWith(
        isLoadingMorePopular: false,
        popularPage: next,
        popular: [...state.popular, ...more],
      );
    } catch (_) {
      state = state.copyWith(isLoadingMorePopular: false);
    }
  }

  Future<void> loadMoreRecommendations() async {
    if (state.isLoadingMoreRecommendations) return;
    state = state.copyWith(isLoadingMoreRecommendations: true);
    try {
      final next = state.recommendationsPage + 1;
      final more = await repository.fetchRecommendedProducts(page: next);
      state = state.copyWith(
        isLoadingMoreRecommendations: false,
        recommendationsPage: next,
        recommendations: [...state.recommendations, ...more],
      );
    } catch (_) {
      state = state.copyWith(isLoadingMoreRecommendations: false);
    }
  }

  Future<void> loadMoreSales() async {
    if (state.isLoadingMoreSales) return;
    state = state.copyWith(isLoadingMoreSales: true);
    try {
      final next = state.salesPage + 1;
      final more = await repository.fetchSaleProducts(page: next);
      state = state.copyWith(
        isLoadingMoreSales: false,
        salesPage: next,
        sales: [...state.sales, ...more],
      );
    } catch (_) {
      state = state.copyWith(isLoadingMoreSales: false);
    }
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) => MockHomeRepository());
final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((ref) => HomeViewModel(ref.read(homeRepositoryProvider)));
