// lib/core/services/navigation_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/core/constants/route_paths.dart';
import 'package:marketplace/core/enums/start_destination.dart';

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
  
  void navigateToRegistration() => context.go(RoutePaths.registration);
  
  void navigateToLogin() => context.go(RoutePaths.login);
  
  void navigateToVerification({
    required String phone,
    required String name,
    File? image,
    required bool isRegistration,
  }) {
    final queryParams = {
      'phone': phone,
      'name': name,
      'isRegistration': isRegistration.toString(),
    };
    if (image != null) {
      queryParams['imagePath'] = image.path;
    }
    
    final uri = Uri(path: RoutePaths.verification, queryParameters: queryParams);
    context.go(uri.toString());
  }

  void navigateToSuccess({
    required String name,
    required bool isRegistration,
  }) {
    final queryParams = {
      'name': name,
      'isRegistration': isRegistration.toString(),
    };
    
    final uri = Uri(path: RoutePaths.success, queryParameters: queryParams);
    context.go(uri.toString());
  }

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


