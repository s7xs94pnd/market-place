import 'package:riverpod/riverpod.dart';
import 'package:kazan/domain/usecases/check_start_destination_usecase.dart';
import 'package:kazan/core/services/navigation_service.dart';
import 'package:kazan/core/enums/start_destination.dart';
import 'package:kazan/core/providers/providers.dart';
import 'package:kazan/domain/repositories/local_storage_repository.dart';

/// ViewModel для экрана Splash
///
/// Для стажеров:
/// 1. ViewModel содержит бизнес-логику экрана
/// 2. Наследуется от StateNotifier для управления состоянием
/// 3. Использует UseCase для выполнения бизнес-логики
/// 4. Использует NavigationService для навигации
/// 5. Добавление новой логики:
///    - Добавьте новые методы для обработки пользовательских действий
///    - Обновляйте состояние через state = newState
///    - Не забывайте обрабатывать ошибки
class SplashViewModel extends StateNotifier<AsyncValue<StartDestination>> {
  final CheckStartDestinationUseCase useCase;
  final NavigationService navigationService;
  final LocalStorageRepository repository;

  SplashViewModel(this.useCase, this.navigationService, this.repository)
    : super(const AsyncLoading()) {
    checkDestination();
  }

  Future<void> checkDestination() async {
    try {
      // Минимальная задержка для показа анимации (2 секунды)
      await Future.delayed(const Duration(seconds: 4));

      // Псевдо-инициализация хранилища: запишем тестовые значения при первом запуске
      // Это поможет протестировать навигацию
      await _seedDummyDataIfNeeded();

      // Определяем направление после задержки
      final destination = await useCase();
      state = AsyncData(destination);

      // Навигация после успешного определения
      navigationService.navigateFromSplash(destination);
    } catch (e, st) {
      state = AsyncError(e, st);
      // В случае ошибки перенаправляем на экран аутентификации
      navigationService.navigateToAuth();
    }
  }

  Future<void> _seedDummyDataIfNeeded() async {
    // Ничего не перезаписываем, если уже есть какой-либо токен или флаг онбординга выставлен
    final boarding = await repository.getBoardingCompleted();
    await repository.getToken();

    // Пример: если онбординг ещё не отмечен, можно выставить false (не пройден)
    // и не ставить токен — тогда попадём на Onboarding/Auth по вашей логике.
    // Для теста можно менять эти строки локально.
/*
    if (!boarding) {
      await repository.setBoardingCompleted(false);
    }
*/

    // Для демонстрации можно раскомментировать для авторизованного сценария:
    await repository.setBoardingCompleted(true);
    await repository.setToken('dummy_token');
  }
}

final splashViewModelProvider =
    StateNotifierProvider.autoDispose<
      SplashViewModel,
      AsyncValue<StartDestination>
    >(
      (ref) => SplashViewModel(
        ref.read(checkStartDestinationUseCaseProvider),
        ref.read(navigationServiceProvider),
        ref.read(localStorageRepositoryProvider),
      ),
    );
