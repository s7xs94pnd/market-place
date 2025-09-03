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
  static const String registration = '/registration';
  static const String login = '/login';
  static const String verification = '/verification';
  static const String success = '/success';
  static const String home = '/home';
  static const String search = '/search';
  static const String product = '/product';
  static const String category = '/category';
  static const String brand = '/brand';
  static const String seeAll = '/see_all';

  // Пример динамического пути:
  // static const String userProfile = '/user/:userId';
}
