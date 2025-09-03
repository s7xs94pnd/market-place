import 'package:marketplace/features/home/models.dart';

class SeeAllState {
  final List<ProductItem> items;
  final bool isLoading;
  final bool hasMore;
  final String? error;

  const SeeAllState({
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
  });

  SeeAllState copyWith({
    List<ProductItem>? items,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    return SeeAllState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
}
