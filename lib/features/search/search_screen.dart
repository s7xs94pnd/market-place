import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Поиск')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Искать товары...',
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (_) => setState(() {}),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Center(
              child: Text(
                _controller.text.isEmpty ? 'Введите запрос' : 'Нет результатов',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
