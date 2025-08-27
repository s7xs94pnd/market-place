// lib/data/repositories/local_storage_repository_impl.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/local_storage_repository.dart';

/// Реализация локального хранилища
/// - Онбординг хранится в SharedPreferences
/// - Токен хранится во FlutterSecureStorage
class LocalStorageRepositoryImpl implements LocalStorageRepository {
  static const String _kBoardingCompleted = 'boarding_completed';
  static const String _kAccessToken = 'access_token';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<bool> getBoardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kBoardingCompleted) ?? false;
  }

  @override
  Future<String?> getToken() async {
    // Псевдо-логика: если пусто, можно вернуть null или dummy
    final token = await _secureStorage.read(key: _kAccessToken);
    return token;
  }

  @override
  Future<void> setBoardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBoardingCompleted, completed);
  }

  @override
  Future<void> setToken(String? token) async {
    if (token == null || token.isEmpty) {
      await _secureStorage.delete(key: _kAccessToken);
    } else {
      await _secureStorage.write(key: _kAccessToken, value: token);
    }
  }
}
