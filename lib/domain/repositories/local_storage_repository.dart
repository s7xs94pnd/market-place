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
  Future<bool> getIsFirstLaunch();

  Future<String?> getAuthToken();

  Future<bool> getIsGuest();

  // Пример добавления нового метода:
  // Future<void> saveUserProfile(UserProfile profile);
}
