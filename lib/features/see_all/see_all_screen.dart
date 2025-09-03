import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace/features/home/widgets/product_card.dart';
import 'package:marketplace/features/see_all/see_all_state.dart';
import 'package:marketplace/features/see_all/see_all_viewmodel.dart';

class SeeAllScreen extends ConsumerStatefulWidget {
  final String type;
  final String title;

  const SeeAllScreen({
    super.key,
    required this.type,
    required this.title,
  });

  @override
  ConsumerState<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends ConsumerState<SeeAllScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      _loadMore();
    }
  }

  void _loadMore() {
    final vm = ref.read(seeAllViewModelProvider(widget.type).notifier);
    vm.loadItems();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(seeAllViewModelProvider(widget.type));
    final vm = ref.read(seeAllViewModelProvider(widget.type).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: vm.refresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: vm.refresh,
        child: _buildBody(state, context),
      ),
    );
  }

  Widget _buildBody(SeeAllState state, BuildContext context) {
    if (state.items.isEmpty && state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(seeAllViewModelProvider(widget.type)),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: state.items.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.items.length) {
          return state.hasMore
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink();
        }
        return ProductCard(item: state.items[index]);
      },
    );
  }
}
