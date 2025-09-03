import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/core/services/navigation_service.dart';
import 'package:marketplace/core/providers/providers.dart';
import 'package:marketplace/features/auth/auth_state_provider.dart';

/// Состояние экрана верификации
class VerificationState {
  final String phone;
  final String name;
  final File? image;
  final bool isRegistration;
  final String code;
  final bool isLoading;
  final String? error;
  final bool canResend;
  final int resendTimer;

  const VerificationState({
    this.phone = '',
    this.name = '',
    this.image,
    this.isRegistration = false,
    this.code = '',
    this.isLoading = false,
    this.error,
    this.canResend = false,
    this.resendTimer = 0,
  });

  VerificationState copyWith({
    String? phone,
    String? name,
    File? image,
    bool? isRegistration,
    String? code,
    bool? isLoading,
    String? error,
    bool? canResend,
    int? resendTimer,
  }) {
    return VerificationState(
      phone: phone ?? this.phone,
      name: name ?? this.name,
      image: image ?? this.image,
      isRegistration: isRegistration ?? this.isRegistration,
      code: code ?? this.code,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      canResend: canResend ?? this.canResend,
      resendTimer: resendTimer ?? this.resendTimer,
    );
  }
}

/// ViewModel для экрана верификации
///
/// Для стажеров:
/// 1. ViewModel содержит бизнес-логику экрана
/// 2. Наследуется от StateNotifier для управления состоянием
/// 3. Использует NavigationService для навигации
/// 4. Добавление новой логики:
///    - Добавьте новые методы для обработки пользовательских действий
///    - Обновляйте состояние через state = newState
///    - Не забывайте обрабатывать ошибки
class VerificationViewModel extends StateNotifier<VerificationState> {
  final NavigationService navigationService;
  final GlobalAuthStateNotifier globalAuthState;
  Timer? _resendTimer;

  VerificationViewModel(this.navigationService, this.globalAuthState) : super(const VerificationState());

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  /// Инициализация из параметров URL
  void initializeFromParams(GoRouterState routerState) {
    final params = routerState.uri.queryParameters;
    
    state = state.copyWith(
      phone: params['phone'] ?? '',
      name: params['name'] ?? '',
      image: params['imagePath'] != null ? File(params['imagePath']!) : null,
      isRegistration: params['isRegistration'] == 'true',
      error: null,
    );

    // Запускаем таймер для повторной отправки
    _startResendTimer();
  }

  /// Обновление кода
  void updateCode(String code) {
    state = state.copyWith(code: code, error: null);
  }

  /// Проверка кода
  Future<void> verifyCode() async {
    if (state.code.length != 4) {
      state = state.copyWith(error: 'Введите 4-значный код');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Имитация проверки кода
      await Future.delayed(const Duration(seconds: 1));

      // Проверяем код (1234 - правильный код)
      if (state.code == '1234') {
        // Успешная верификация - очищаем все данные
        globalAuthState.clearData();
        
        // Переходим на экран успеха
        navigationService.navigateToSuccess(
          name: state.name,
          isRegistration: state.isRegistration,
        );
      } else {
        // Неправильный код
        state = state.copyWith(
          isLoading: false,
          error: 'Код неверен. Попробуйте еще раз.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Ошибка при проверке кода: $e',
      );
    }
  }

  /// Повторная отправка кода
  Future<void> resendCode() async {
    if (!state.canResend) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Имитация отправки кода
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(isLoading: false);
      _startResendTimer();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Ошибка при отправке кода: $e',
      );
    }
  }

  /// Запуск таймера для повторной отправки
  void _startResendTimer() {
    _resendTimer?.cancel();
    
    state = state.copyWith(canResend: false, resendTimer: 10);
    
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendTimer > 0) {
        state = state.copyWith(resendTimer: state.resendTimer - 1);
      } else {
        state = state.copyWith(canResend: true);
        timer.cancel();
      }
    });
  }

  /// Навигация назад
  void navigateBack() {
    if (state.isRegistration) {
      // Возвращаемся к регистрации с сохраненными данными
      navigationService.navigateToRegistration();
    } else {
      // Возвращаемся к входу с сохраненными данными
      navigationService.navigateToLogin();
    }
  }
}

final verificationViewModelProvider = StateNotifierProvider.autoDispose<VerificationViewModel, VerificationState>(
  (ref) => VerificationViewModel(
    ref.read(navigationServiceProvider),
    ref.read(globalAuthStateProvider.notifier),
  ),
);
