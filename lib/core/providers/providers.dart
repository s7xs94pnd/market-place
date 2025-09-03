// lib/core/providers/providers.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/app/router.dart';
import 'package:marketplace/core/services/navigation_service.dart';
import 'package:marketplace/data/repositories/local_storage_repository_impl.dart';
import 'package:marketplace/domain/repositories/local_storage_repository.dart';
import 'package:marketplace/domain/usecases/check_start_destination_usecase.dart';

/// Провайдеры зависимостей приложения
///
/// Для стажеров:
/// 1. Riverpod используется для dependency injection
/// 2. Все зависимости регистрируются здесь
/// 3. Типы провайдеров:
///    - Provider: для статических зависимостей
///    - StateProvider: для простого состояния
///    - StateNotifierProvider: для сложного состояния с бизнес-логикой
///    - FutureProvider/StreamProvider: для асинхронных данных
///
/// 4. Добавление нового провайдера:
///    - Определите провайдер с помощью соответствующего конструктора
///    - Зарегистрируйте его здесь
///    - Используйте ref.read(provider) для доступа к зависимости

// Репозитории
final localStorageRepositoryProvider = Provider<LocalStorageRepository>(
  (ref) => LocalStorageRepositoryImpl(),
);

// Use Cases
final checkStartDestinationUseCaseProvider =
    Provider<CheckStartDestinationUseCase>(
      (ref) => CheckStartDestinationUseCase(
        ref.read(localStorageRepositoryProvider),
      ),
    );

// Навигация
final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>(
  (ref) => GlobalKey<NavigatorState>(),
);

final navigationServiceProvider = Provider<NavigationService>(
  (ref) => NavigationService(ref.read(navigatorKeyProvider)),
);

// Роутер (единый инстанс через провайдер)
final routerProvider = Provider<GoRouter>((ref) {
  final navigatorKey = ref.read(navigatorKeyProvider);
  return createRouter(navigatorKey);
});