import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/core/services/navigation_service.dart';
import 'package:marketplace/core/providers/providers.dart';

/// Состояние экрана успешной верификации
class SuccessState {
  final String name;
  final bool isRegistration;
  final int countdown;

  const SuccessState({
    this.name = '',
    this.isRegistration = false,
    this.countdown = 3,
  });

  SuccessState copyWith({
    String? name,
    bool? isRegistration,
    int? countdown,
  }) {
    return SuccessState(
      name: name ?? this.name,
      isRegistration: isRegistration ?? this.isRegistration,
      countdown: countdown ?? this.countdown,
    );
  }
}

/// ViewModel для экрана успешной верификации
///
/// Для стажеров:
/// 1. ViewModel содержит бизнес-логику экрана
/// 2. Наследуется от StateNotifier для управления состоянием
/// 3. Использует NavigationService для навигации
/// 4. Добавление новой логики:
///    - Добавьте новые методы для обработки пользовательских действий
///    - Обновляйте состояние через state = newState
///    - Не забывайте обрабатывать ошибки
class SuccessViewModel extends StateNotifier<SuccessState> {
  final NavigationService navigationService;
  Timer? _countdownTimer;

  SuccessViewModel(this.navigationService) : super(const SuccessState());

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  /// Инициализация из параметров URL
  void initializeFromParams(GoRouterState routerState) {
    final params = routerState.uri.queryParameters;
    
    state = state.copyWith(
      name: params['name'] ?? '',
      isRegistration: params['isRegistration'] == 'true',
    );

    // Запускаем таймер автоматического перехода
    _startCountdownTimer();
  }

  /// Запуск таймера автоматического перехода
  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdown > 0) {
        state = state.copyWith(countdown: state.countdown - 1);
      } else {
        timer.cancel();
        navigateToHome();
      }
    });
  }

  /// Переход в главный экран
  void navigateToHome() {
    _countdownTimer?.cancel();
    navigationService.navigateToHome(isGuest: false);
  }
}

final successViewModelProvider = StateNotifierProvider.autoDispose<SuccessViewModel, SuccessState>(
  (ref) => SuccessViewModel(
    ref.read(navigationServiceProvider),
  ),
);
