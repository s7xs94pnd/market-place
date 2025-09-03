class HomeBanner {
  final String id;
  final String imageUrl;
  final String? linkUrl;
  const HomeBanner({required this.id, required this.imageUrl, this.linkUrl});
}

class CategoryItem {
  final String id;
  final String name;
  final String iconUrl;
  const CategoryItem({required this.id, required this.name, required this.iconUrl});
}

class ProductItem {
  final String id;
  final String name;
  final double price;
  final double? oldPrice;
  final double? rating;
  final String imageUrl;
  const ProductItem({
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice,
    this.rating,
    required this.imageUrl,
  });
}

class BrandItem {
  final String id;
  final String name;
  final String logoUrl;
  const BrandItem({required this.id, required this.name, required this.logoUrl});
}

class ReviewItem {
  final String id;
  final String userName;
  final String avatarUrl;
  final double rating;
  final String text;
  const ReviewItem({
    required this.id,
    required this.userName,
    required this.avatarUrl,
    required this.rating,
    required this.text,
  });
}
