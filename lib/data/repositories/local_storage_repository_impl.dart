// lib/data/repositories/local_storage_repository_impl.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/local_storage_repository.dart';

/// Реализация репозитория для работы с локальным хранилищем
///
/// Для стажеров:
/// 1. Этот класс реализует абстракцию LocalStorageRepository
/// 2. Использует SharedPreferences для хранения ключ-значение данных
/// 3. Добавление нового метода:
///    - Добавьте метод в интерфейс LocalStorageRepository
///    - Реализуйте его здесь
///    - Используйте await SharedPreferences.getInstance() для доступа к хранилищу
class LocalStorageRepositoryImpl implements LocalStorageRepository {
  @override
  Future<bool> getIsFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstLaunch') ?? true;
  }

  @override
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  @override
  Future<bool> getIsGuest() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isGuest') ?? false;
  }

  // Пример добавления нового метода:
  // @override
  // Future<void> saveUserProfile(UserProfile profile) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('userProfile', jsonEncode(profile.toJson()));
  // }
}
