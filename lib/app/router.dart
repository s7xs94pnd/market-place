import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kazan/core/constants/route_paths.dart';
import 'package:kazan/features/splash/splash_screen.dart';
import 'package:kazan/features/onboarding/onboarding_screen.dart';
import 'package:kazan/features/auth/login_screen.dart';
import 'package:kazan/features/home/main_screen.dart';

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
      GoRoute(
        path: RoutePaths.onboarding,
        pageBuilder: (context, state) =>
          const MaterialPage(child: OnboardingScreen()),
      ),
      GoRoute(
        path: RoutePaths.auth,
        pageBuilder: (context, state) =>
          const MaterialPage(child: LoginScreen()),
      ),
      GoRoute(
        path: RoutePaths.home,
        pageBuilder: (context, state) =>
          const MaterialPage(child: MainScreen()),
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
