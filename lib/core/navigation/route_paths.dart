// lib/core/constants/route_paths.dart
/// Константы путей маршрутов приложения
///
/// Для стажеров:
/// 1. Все пути должны быть объявлены здесь
/// 2. Используйте константы вместо строковых литералов в коде
/// 3. Формат путей:
///    - Статические: '/home'
///    - Динамические: '/user/:id'
///    - С query параметрами: '/home?tab=profile'
abstract class RoutePaths {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String home = '/home';

  // Пример динамического пути:
  // static const String userProfile = '/user/:userId';
}
