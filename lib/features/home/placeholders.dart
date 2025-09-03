import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final String id;
  const ProductScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Товар')), body: Center(child: Text('Товар: $id')));
}

class CategoryScreen extends StatelessWidget {
  final String id;
  const CategoryScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Категория')), body: Center(child: Text('Категория: $id')));
}

class BrandScreen extends StatelessWidget {
  final String id;
  const BrandScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Бренд')), body: Center(child: Text('Бренд: $id')));
}
