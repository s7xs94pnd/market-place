import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/core/constants/route_paths.dart';
import 'package:marketplace/features/splash/splash_screen.dart';
import 'package:marketplace/features/onboarding/onboarding_screen.dart';
import 'package:marketplace/features/auth/auth_screen.dart';
import 'package:marketplace/features/auth/login/login_screen.dart';
import 'package:marketplace/features/auth/registration/registration_screen.dart';
import 'package:marketplace/features/auth/verification/verification_screen.dart';
import 'package:marketplace/features/auth/success/success_screen.dart';
import 'package:marketplace/features/home/home_screen.dart';
import 'package:marketplace/features/search/search_screen.dart';
import 'package:marketplace/features/home/placeholders.dart';
import 'package:marketplace/features/see_all/see_all_screen.dart';

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
          const MaterialPage(child: AuthScreen()),
      ),
      GoRoute(
        path: RoutePaths.registration,
        pageBuilder: (context, state) =>
          const MaterialPage(child: RegistrationScreen()),
      ),
      GoRoute(
        path: RoutePaths.login,
        pageBuilder: (context, state) =>
          const MaterialPage(child: LoginScreen()),
      ),
      GoRoute(
        path: RoutePaths.verification,
        pageBuilder: (context, state) =>
          const MaterialPage(child: VerificationScreen()),
      ),
      GoRoute(
        path: RoutePaths.success,
        pageBuilder: (context, state) =>
          const MaterialPage(child: SuccessScreen()),
      ),
      GoRoute(
        path: RoutePaths.home,
        pageBuilder: (context, state) =>
          const MaterialPage(child: HomeScreen()),
      ),
      GoRoute(
        path: RoutePaths.search,
        pageBuilder: (context, state) =>
          const MaterialPage(child: SearchScreen()),
      ),
      GoRoute(
        path: RoutePaths.product,
        pageBuilder: (context, state) {
          final id = state.uri.queryParameters['id'] ?? '';
          return MaterialPage(child: ProductScreen(id: id));
        },
      ),
      GoRoute(
        path: RoutePaths.category,
        pageBuilder: (context, state) {
          final id = state.uri.queryParameters['id'] ?? '';
          return MaterialPage(child: CategoryScreen(id: id));
        },
      ),
      GoRoute(
        path: RoutePaths.brand,
        pageBuilder: (context, state) {
          final id = state.uri.queryParameters['id'] ?? '';
          return MaterialPage(child: BrandScreen(id: id));
        },
      ),
      GoRoute(
        path: RoutePaths.seeAll,
        pageBuilder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? '';
          String title = 'Товары';
          
          switch (type) {
            case 'popular':
              title = 'Популярные товары';
              break;
            case 'recommended':
              title = 'Рекомендуем вам';
              break;
            case 'sale':
              title = 'Скидки';
              break;
          }
          
          return MaterialPage(
            child: SeeAllScreen(
              type: type,
              title: title,
            ),
          );
        },
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
