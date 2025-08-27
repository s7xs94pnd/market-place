// lib/core/services/navigation_service.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kazan/core/constants/route_paths.dart';
import 'package:kazan/core/enums/start_destination.dart';

/// Сервис навигации для инкапсуляции логики переходов между экранами
///
/// Для стажеров:
/// 1. Все переходы между экранами должны осуществляться через этот сервис
/// 2. Добавление нового перехода:
///    - Добавьте метод navigateTo[ScreenName]()
///    - Используйте context.go() для навигации
/// 3. Не используйте Navigator.push() напрямую в UI компонентах
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigationService(this.navigatorKey);

  BuildContext get context => navigatorKey.currentContext!;

  void navigateToSplash() => context.go(RoutePaths.splash);

  void navigateToOnboarding() => context.go(RoutePaths.onboarding);

  void navigateToAuth() => context.go(RoutePaths.auth);

  void navigateToHome({bool isGuest = false}) {
    final path = isGuest ? '${RoutePaths.home}?guest=true' : RoutePaths.home;
    context.go(path);
  }

  /// Определяет следующий экран после Splash на основе сохраненных данных
  void navigateFromSplash(StartDestination destination) {
    switch (destination) {
      case StartDestination.onboarding:
        navigateToOnboarding();
        break;
      case StartDestination.auth:
        navigateToAuth();
        break;
      case StartDestination.homeUser:
        navigateToHome(isGuest: false);
        break;
      case StartDestination.homeGuest:
        navigateToHome(isGuest: true);
        break;
    }
  }

  /// Вспомогательный метод для извлечения query параметров
  static bool isGuestMode(GoRouterState state) {
    return state.uri.queryParameters['guest'] == 'true';
  }
}


