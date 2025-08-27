// lib/core/enums/start_destination.dart
/// Возможные направления навигации после экрана Splash
///
/// Для стажеров:
/// 1. Enum используется для типобезопасности
/// 2. Добавление нового направления:
///    - Добавьте вариант в enum
///    - Обновите логику в CheckStartDestinationUseCase
///    - Обновите NavigationService.navigateFromSplash
enum StartDestination {
  onboarding, // Показать онбординг
  auth, // Перейти к аутентификации
  homeUser, // Перейти к главному экрану как авторизованный пользователь
  homeGuest, // Перейти к главному экрану как гость
}
