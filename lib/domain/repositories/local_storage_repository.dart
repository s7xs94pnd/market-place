// lib/domain/repositories/local_storage_repository.dart
/// Абстракция репозитория для работы с локальным хранилищем
///
/// Для стажеров:
/// 1. Интерфейс определяет контракт для работы с локальным хранилищем
/// 2. Реализация находится в LocalStorageRepositoryImpl
/// 3. Принцип инверсии зависимостей (Dependency Inversion):
///    - Модули высокого уровня не должны зависеть от модулей низкого уровня
///    - Оба должны зависеть от абстракций
abstract class LocalStorageRepository {
  /// Флаг завершения онбординга (SharedPreferences)
  Future<bool> getBoardingCompleted();

  /// Токен доступа (FlutterSecureStorage)
  Future<String?> getToken();

  /// Установить флаг онбординга
  Future<void> setBoardingCompleted(bool completed);

  /// Сохранить или удалить токен (если null или пусто — удалить)
  Future<void> setToken(String? token);
}
