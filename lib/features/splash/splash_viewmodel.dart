// lib/features/splash/presentation/viewmodels/splash_viewmodel.dart
import 'package:riverpod/riverpod.dart';
import 'package:kazan/domain/usecases/check_start_destination_usecase.dart';
import '../../core/navigation/navigation_service.dart';
import '../../core/navigation/start_destination.dart';
import '../../core/providers/providers.dart';

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

  SplashViewModel(this.useCase, this.navigationService)
    : super(const AsyncLoading()) {
    checkDestination();
  }

  Future<void> checkDestination() async {
    try {
      // Минимальная задержка для показа анимации (8 секунд)
      await Future.delayed(const Duration(seconds: 8));

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
}

final splashViewModelProvider =
    StateNotifierProvider.autoDispose<
      SplashViewModel,
      AsyncValue<StartDestination>
    >(
      (ref) => SplashViewModel(
        ref.read(checkStartDestinationUseCaseProvider),
        ref.read(navigationServiceProvider),
      ),
    );
