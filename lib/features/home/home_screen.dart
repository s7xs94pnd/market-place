import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/core/constants/route_paths.dart';
import 'models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _offline = false;
  Future<void> _updateConnectivityStatus() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (mounted) {
        setState(() {
          _offline = _isOffline(connectivityResult);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _offline = true;
        });
      }
    }
  }
  
  bool _isOffline(dynamic connectivityResult) {
    if (connectivityResult is List<ConnectivityResult>) {
      return connectivityResult.contains(ConnectivityResult.none);
    } else if (connectivityResult is ConnectivityResult) {
      return connectivityResult == ConnectivityResult.none;
    }
    return true; // Default to offline if unknown type
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeViewModelProvider.notifier).loadAll();
    });
    
    // Check initial connectivity status
    _updateConnectivityStatus();
    
    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (mounted) {
        setState(() {
          _offline = _isOffline(connectivityResult);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);
    final vm = ref.read(homeViewModelProvider.notifier);

    if (state.isLoading) {
      return _HomeSkeleton();
    }

    if (state.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Ошибка: ${state.error}'),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: vm.loadAll, child: const Text('Повторить')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async { await ref.read(homeViewModelProvider.notifier).loadAll(); },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: _Header(),
            ),
            if (_offline)
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: Colors.orange.shade100,
                  child: Row(
                    children: [
                      const Icon(Icons.wifi_off, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(child: Text('Нет подключения к интернету', style: TextStyle(color: Colors.orange.shade800))),
                    ],
                  ),
                ),
              ),
            SliverToBoxAdapter(child: _BannerSlider(banners: state.banners)),
            SliverToBoxAdapter(child: _QuickFilters(current: state.currentFilter)),
            SliverToBoxAdapter(child: _SectionSpacing()),
            SliverToBoxAdapter(child: _CategoriesRow(items: state.categories)),
            SliverToBoxAdapter(child: _SectionSpacing()),
            SliverToBoxAdapter(child: _PopularRow(items: state.popular)),
            SliverToBoxAdapter(child: _SectionSpacing()),
            SliverToBoxAdapter(child: _RecommendationsGrid(items: state.recommendations)),
            SliverToBoxAdapter(child: _SectionSpacing()),
            SliverToBoxAdapter(child: _FlashSaleRow(items: state.sales)),
            SliverToBoxAdapter(child: _SectionSpacing()),
            SliverToBoxAdapter(child: _BrandsRow(items: state.brands)),
            SliverToBoxAdapter(child: _SectionSpacing()),
            SliverToBoxAdapter(child: _ReviewsRow(items: state.reviews)),
            SliverToBoxAdapter(child: const SizedBox(height: 24)),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 18, backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), child: Icon(Icons.store, color: Theme.of(context).colorScheme.primary)),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: (){ GoRouter.of(context).go(RoutePaths.search); },
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Искать товары...', style: TextStyle(color: Colors.black54))),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Stack(
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.shopping_bag_outlined, color: Theme.of(context).colorScheme.primary)),
            Positioned(right: 6, top: 6, child: Consumer(
              builder: (_, ref, __) => _Badge(count: ref.watch(homeViewModelProvider).cartCount),
            )),
          ],
        ),
        Stack(
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.notifications_none, color: Theme.of(context).colorScheme.primary)),
            Positioned(right: 6, top: 6, child: _Badge(count: 1)),
          ],
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});
  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(999)),
      child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10)),
    );
  }
}

class _BannerSlider extends StatefulWidget {
  final List<HomeBanner> banners;
  const _BannerSlider({required this.banners});
  @override
  State<_BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<_BannerSlider> {
  late final PageController _controller;
  int _index = 0;
  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.9);
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted || widget.banners.isEmpty) return false;
      _index = (_index + 1) % widget.banners.length;
      _controller.animateToPage(_index, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      return true;
    });
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length,
            itemBuilder: (_, i) {
              final b = widget.banners[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: () {
                      if (b.linkUrl != null && b.linkUrl!.isNotEmpty) {
                        GoRouter.of(context).go(b.linkUrl!);
                      }
                    },
                    child: CachedNetworkImage(
                      imageUrl: b.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (_, __) => Container(color: Colors.grey.shade200),
                      errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.banners.length, (i) => Container(
            width: 6, height: 6, margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: i == _index ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          )),
        ),
      ],
    );
  }
}

class _CategoriesRow extends StatelessWidget {
  final List<CategoryItem> items;
  const _CategoriesRow({required this.items});
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _EmptySection(text: 'Нет данных по категориям');
    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final c = items[i];
          return InkWell(
            onTap: () => GoRouter.of(context).go('${RoutePaths.category}?id=${c.id}'),
            child: Column(
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    imageUrl: c.iconUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.grey.shade200),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(width: 72, child: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center)),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: items.length,
      ),
    );
  }
}

class _PopularRow extends ConsumerWidget {
  final List<ProductItem> items;
  const _PopularRow({required this.items});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const _EmptySection(text: 'Нет данных раздела «Популярное»');
    return Column(
      children: [
        _SectionHeader(title: 'Популярное', onSeeAll: () => GoRouter.of(context).go('${RoutePaths.seeAll}?type=popular')),
        SizedBox(
          height: 250,
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
                // Загрузить следующую страницу
                final vm = ref.read(homeViewModelProvider.notifier);
                vm.loadMorePopular();
              }
              return false;
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) => i == items.length - 1 && ref.read(homeViewModelProvider).isLoadingMorePopular
                  ? const _LoadingTail()
                  : _ProductCard(item: items[i]),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: items.length + (ref.read(homeViewModelProvider).isLoadingMorePopular ? 1 : 0),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecommendationsGrid extends ConsumerWidget {
  final List<ProductItem> items;
  const _RecommendationsGrid({required this.items});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const _EmptySection(text: 'Пока нет рекомендаций');
    final vm = ref.read(homeViewModelProvider.notifier);
    final isLoadingMore = ref.watch(homeViewModelProvider).isLoadingMoreRecommendations;
    return Column(
      children: [
        _SectionHeader(title: 'Рекомендации для вас', onSeeAll: () => GoRouter.of(context).go('${RoutePaths.seeAll}?type=recommended')),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: LayoutBuilder(
            builder: (context, c) {
              final width = c.maxWidth;
              final itemWidth = (width - 12) / 2;
              return NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n.metrics.pixels >= n.metrics.maxScrollExtent - 100 && !isLoadingMore) {
                    vm.loadMoreRecommendations();
                  }
                  return false;
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: items.map((p) => SizedBox(width: itemWidth, child: _ProductCard(item: p))).toList(),
                    ),
                    const SizedBox(height: 12),
                    if (isLoadingMore)
                      const Center(child: Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))))
                    else
                      Center(
                        child: TextButton(
                          onPressed: vm.loadMoreRecommendations,
                          child: const Text('Загрузить ещё'),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FlashSaleRow extends ConsumerStatefulWidget {
  final List<ProductItem> items;
  const _FlashSaleRow({required this.items});
  @override
  ConsumerState<_FlashSaleRow> createState() => _FlashSaleRowState();
}

class _FlashSaleRowState extends ConsumerState<_FlashSaleRow> {
  late Duration _left;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _left = const Duration(hours: 2, minutes: 15, seconds: 34);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_left.inSeconds > 0) {
          _left -= const Duration(seconds: 1);
        }
      });
    });
  }
  @override
  void dispose() { _timer?.cancel(); super.dispose(); }
  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2,'0');
    return '${two(d.inHours)}:${two(d.inMinutes%60)}:${two(d.inSeconds%60)}';
  }
  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const _EmptySection(text: 'Нет активных скидок');
    return Column(
      children: [
        _SectionHeader(
          title: 'Скидки',
          trailing: Text('До конца: ${_fmt(_left)}', style: TextStyle(color: Colors.red.shade400)),
          onSeeAll: () => GoRouter.of(context).go('${RoutePaths.category}?id=sale'),
        ),
        SizedBox(
          height: 260,
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
                final vm = ref.read(homeViewModelProvider.notifier);
                vm.loadMoreSales();
              }
              return false;
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) => i == widget.items.length - 1 && ref.read(homeViewModelProvider).isLoadingMoreSales
                  ? const _LoadingTail()
                  : _ProductCard(item: widget.items[i], showDiscount: true),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: widget.items.length + (ref.read(homeViewModelProvider).isLoadingMoreSales ? 1 : 0),
            ),
          ),
        ),
      ],
    );
  }
}

class _BrandsRow extends StatelessWidget {
  final List<BrandItem> items;
  const _BrandsRow({required this.items});
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _EmptySection(text: 'Нет брендов для отображения');
    return Column(
      children: [
        _SectionHeader(
          title: 'Бренды',
          onSeeAll: () => GoRouter.of(context).go('${RoutePaths.brand}?id=all-brands'),
        ),
        SizedBox(
          height: 80,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) => InkWell(
              onTap: () => GoRouter.of(context).go('${RoutePaths.brand}?id=${items[i].id}'),
              child: Container(
              width: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: items[i].logoUrl,
                  height: 40,
                  fit: BoxFit.contain,
                  placeholder: (_, __) => Container(color: Colors.grey.shade200, height: 40),
                  errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
            )),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: items.length,
          ),
        ),
      ],
    );
  }
}

class _ReviewsRow extends StatelessWidget {
  final List<ReviewItem> items;
  const _ReviewsRow({required this.items});
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _EmptySection(text: 'Пока нет отзывов');
    return Column(
      children: [
        const _SectionHeader(title: 'Отзывы покупателей'),
        SizedBox(
          height: 150,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) {
              final r = items[i];
              return Container(
                width: 240,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(r.avatarUrl)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(r.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text(r.text, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    )),
                    const SizedBox(width: 8),
                    Row(children: [const Icon(Icons.star, color: Colors.amber, size: 16), Text(r.rating.toStringAsFixed(1))]),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: items.length,
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductItem item;
  final bool showDiscount;
  const _ProductCard({required this.item, this.showDiscount = false});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => GoRouter.of(context).go('${RoutePaths.product}?id=${item.id}'),
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    Positioned.fill(child: CachedNetworkImage(imageUrl: item.imageUrl, fit: BoxFit.cover, placeholder: (_, __) => Container(color: Colors.grey.shade200))),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Consumer(
                        builder: (_, ref, __) {
                          final isFav = ref.watch(homeViewModelProvider).favorites.contains(item.id);
                          return GestureDetector(
                            onTap: () => ref.read(homeViewModelProvider.notifier).toggleFavorite(item.id),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), shape: BoxShape.circle),
                              padding: const EdgeInsets.all(6),
                              child: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.grey.shade600, size: 18),
                            ),
                          );
                        },
                      ),
                    ),
                    if (showDiscount && item.oldPrice != null)
                      Positioned(
                        left: 8, top: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                          child: Text('-${(((item.oldPrice! - item.price) / item.oldPrice!) * 100).round()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('${item.price.toStringAsFixed(0)} ₽', style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Consumer(builder: (_, ref, __) => GestureDetector(
                  onTap: () => ref.read(homeViewModelProvider.notifier).addToCart(item.id),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onSeeAll;
  const _SectionHeader({required this.title, this.trailing, this.onSeeAll});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const Spacer(),
          if (trailing != null) trailing!,
          if (onSeeAll != null) TextButton(onPressed: onSeeAll, child: const Text('Смотреть все')),
        ],
      ),
    );
  }
}

class _SectionSpacing extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SizedBox(height: 12);
}

class _EmptySection extends StatelessWidget {
  final String text;
  const _EmptySection({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _LoadingTail extends StatelessWidget {
  const _LoadingTail();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class _QuickFilters extends ConsumerWidget {
  final String current;
  const _QuickFilters({required this.current});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = const [
      ['all', 'Все'],
      ['sale', 'Скидки'],
      ['popular', 'Популярное'],
      ['recommended', 'Рекомендовано'],
      ['new', 'Новинки'],
    ];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final key = items[i][0];
          final label = items[i][1];
          final selected = current == key;
          return ChoiceChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) => ref.read(homeViewModelProvider.notifier).setFilter(key),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: items.length,
      ),
    );
  }
}

class _BottomNav extends StatefulWidget {
  @override
  State<_BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<_BottomNav> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (i) => setState(() => index = i),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Главная'),
        NavigationDestination(icon: Icon(Icons.category_outlined), selectedIcon: Icon(Icons.category), label: 'Категории'),
        NavigationDestination(icon: Icon(Icons.qr_code_scanner), selectedIcon: Icon(Icons.qr_code_2), label: 'Поиск'),
        NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), selectedIcon: Icon(Icons.shopping_bag), label: 'Корзина'),
        NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Профиль'),
      ],
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget box({double h = 16, double w = double.infinity, double r = 12}) => _ShimmerBox(height: h, width: w, radius: r);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [box(h: 36, w: 36, r: 18), const SizedBox(width: 12), Expanded(child: box(h: 44, r: 16)), const SizedBox(width: 12), box(h: 36, w: 36, r: 18), const SizedBox(width: 8), box(h: 36, w: 36, r: 18)]),
          const SizedBox(height: 16),
          SizedBox(height: 160, child: box(h: 160, r: 16)),
          const SizedBox(height: 12),
          SizedBox(height: 100, child: ListView.separated(scrollDirection: Axis.horizontal, itemBuilder: (_, __) => box(h: 80, w: 80, r: 40), separatorBuilder: (_, __) => const SizedBox(width: 12), itemCount: 6)),
          const SizedBox(height: 12),
          SizedBox(height: 240, child: ListView.separated(scrollDirection: Axis.horizontal, itemBuilder: (_, __) => box(h: 220, w: 160, r: 16), separatorBuilder: (_, __) => const SizedBox(width: 12), itemCount: 6)),
          const SizedBox(height: 12),
          Wrap(spacing: 12, runSpacing: 12, children: List.generate(6, (i) => box(h: 220, w: (MediaQuery.of(context).size.width - 56) / 2, r: 16))),
        ],
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  final double height;
  final double width;
  final double radius;
  const _ShimmerBox({required this.height, required this.width, required this.radius});
  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final base = Colors.grey.shade300;
        final highlight = Colors.grey.shade100;
        return Container(
          height: widget.height,
          width: widget.width,
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _c.value, 0),
              end: Alignment(1.0 + 2.0 * _c.value, 0),
              colors: [base, highlight, base],
              stops: const [0.25, 0.5, 0.75],
            ),
          ),
        );
      },
    );
  }
}


