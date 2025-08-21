// lib/main.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:kazan/app/router.dart';
import 'package:kazan/core/providers/providers.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigatorKey = ref.read(navigatorKeyProvider);
    final _router = createRouter(navigatorKey);

    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true),
      debugShowCheckedModeBanner: false,
    );
  }
}
