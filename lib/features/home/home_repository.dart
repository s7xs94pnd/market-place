import 'dart:async';
import 'models.dart';

abstract class HomeRepository {
  Future<List<HomeBanner>> fetchBanners();
  Future<List<CategoryItem>> fetchCategories();
  Future<List<ProductItem>> fetchPopularProducts({int page = 1});
  Future<List<ProductItem>> fetchRecommendedProducts({int page = 1});
  Future<List<ProductItem>> fetchSaleProducts({int page = 1});
  Future<List<BrandItem>> fetchBrands();
  Future<List<ReviewItem>> fetchReviews();
}

class MockHomeRepository implements HomeRepository {
  Duration get _delay => const Duration(milliseconds: 600);

  @override
  Future<List<HomeBanner>> fetchBanners() async {
    await Future.delayed(_delay);
    return List.generate(5, (i) => HomeBanner(
      id: 'b$i',
      imageUrl: 'https://picsum.photos/seed/banner$i/800/300',
      linkUrl: null,
    ));
  }

  @override
  Future<List<CategoryItem>> fetchCategories() async {
    await Future.delayed(_delay);
    return [
      CategoryItem(id: 'c1', name: 'Одежда', iconUrl: 'https://picsum.photos/seed/c1/100/100'),
      CategoryItem(id: 'c2', name: 'Обувь', iconUrl: 'https://picsum.photos/seed/c2/100/100'),
      CategoryItem(id: 'c3', name: 'Электроника', iconUrl: 'https://picsum.photos/seed/c3/100/100'),
      CategoryItem(id: 'c4', name: 'Дом', iconUrl: 'https://picsum.photos/seed/c4/100/100'),
      CategoryItem(id: 'c5', name: 'Спорт', iconUrl: 'https://picsum.photos/seed/c5/100/100'),
    ];
  }

  @override
  Future<List<ProductItem>> fetchPopularProducts({int page = 1}) async {
    await Future.delayed(_delay);
    return List.generate(10, (i) => ProductItem(
      id: 'p_pop_${page}_$i',
      name: 'Популярный товар ${page*10+i}',
      price: 999 + i.toDouble(),
      rating: 4 + (i % 10) / 10,
      imageUrl: 'https://picsum.photos/seed/pop${page}_$i/400/400',
    ));
  }

  @override
  Future<List<ProductItem>> fetchRecommendedProducts({int page = 1}) async {
    await Future.delayed(_delay);
    return List.generate(10, (i) => ProductItem(
      id: 'p_rec_${page}_$i',
      name: 'Товар для вас ${page*10+i}',
      price: 799 + i.toDouble(),
      rating: 4.5,
      imageUrl: 'https://picsum.photos/seed/rec${page}_$i/400/400',
    ));
  }

  @override
  Future<List<ProductItem>> fetchSaleProducts({int page = 1}) async {
    await Future.delayed(_delay);
    return List.generate(10, (i) => ProductItem(
      id: 'p_sale_${page}_$i',
      name: 'Скидка ${page*10+i}',
      price: 499 + i.toDouble(),
      oldPrice: 899 + i.toDouble(),
      rating: 4.2,
      imageUrl: 'https://picsum.photos/seed/sale${page}_$i/400/400',
    ));
  }

  @override
  Future<List<BrandItem>> fetchBrands() async {
    await Future.delayed(_delay);
    return List.generate(12, (i) => BrandItem(
      id: 'b$i',
      name: 'Бренд $i',
      logoUrl: 'https://picsum.photos/seed/brand$i/160/80',
    ));
  }

  @override
  Future<List<ReviewItem>> fetchReviews() async {
    await Future.delayed(_delay);
    return List.generate(8, (i) => ReviewItem(
      id: 'r$i',
      userName: 'Покупатель $i',
      avatarUrl: 'https://picsum.photos/seed/rev$i/100/100',
      rating: 3.5 + (i % 3),
      text: 'Очень понравился товар, рекомендую! #$i',
    ));
  }
}
