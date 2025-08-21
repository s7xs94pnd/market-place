// lib/app/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/navigation/route_paths.dart';
import '../features/splash/splash_screen.dart';

/// Конфигурация маршрутизации приложения
///
/// Используется GoRouter для навигации между экранами.
///
/// Для стажеров:
/// 1. Добавление нового маршрута:
///    - Добавьте путь в RoutePaths
///    - Создайте GoRoute с соответствующим path
///    - В pageBuilder верните MaterialPage с вашим экраном
///
/// 2. Передача параметров:
///    - Используйте state.params для path параметров (/user/:id)
///    - Используйте state.uri.queryParameters для query параметров (/home?tab=profile)
GoRouter createRouter(GlobalKey<NavigatorState> navigatorKey) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RoutePaths.splash,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        pageBuilder: (context, state) =>
            const MaterialPage(child: SplashScreen()),
      ),
      // Добавьте остальные маршруты здесь
      // Пример:
      // GoRoute(
      //   path: RoutePaths.home,
      //   pageBuilder: (context, state) => MaterialPage(
      //     child: HomeScreen(
      //       isGuest: NavigationService.isGuestMode(state),
      //     ),
      //   ),
      // ),
    ],
    errorPageBuilder: (context, state) => const MaterialPage(
      child: Scaffold(body: Center(child: Text('Страница не найдена'))),
    ),
  );
}
