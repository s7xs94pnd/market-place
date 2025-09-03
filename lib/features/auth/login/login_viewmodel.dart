import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace/core/services/navigation_service.dart';
import 'package:marketplace/core/providers/providers.dart';
import 'package:marketplace/features/auth/auth_state_provider.dart';

/// Состояние экрана входа
class LoginState {
  final String phone;
  final bool isLoading;
  final String? error;

  const LoginState({
    this.phone = '',
    this.isLoading = false,
    this.error,
  });

  LoginState copyWith({
    String? phone,
    bool? isLoading,
    String? error,
  }) {
    return LoginState(
      phone: phone ?? this.phone,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// ViewModel для экрана входа
///
/// 1. ViewModel содержит бизнес-логику экрана
/// 2. Наследуется от StateNotifier для управления состоянием
/// 3. Использует NavigationService для навигации
/// 4. Добавление новой логики:
///    - Добавьте новые методы для обработки пользовательских действий
///    - Обновляйте состояние через state = newState
///    - Не забывайте обрабатывать ошибки
class LoginViewModel extends StateNotifier<LoginState> {
  final NavigationService navigationService;
  final GlobalAuthStateNotifier globalAuthState;

  LoginViewModel(this.navigationService, this.globalAuthState) : super(const LoginState()) {
    // Загружаем сохраненные данные при инициализации
    _loadSavedData();
  }

  /// Загрузка сохраненных данных
  void _loadSavedData() {
    final savedState = globalAuthState.state;
    if (!savedState.isRegistration && savedState.phone.isNotEmpty) {
      state = state.copyWith(phone: savedState.phone);
    }
  }

  /// Обновление номера телефона
  void updatePhone(String phone) {
    state = state.copyWith(phone: phone, error: null);
    globalAuthState.updatePhone(phone);
  }

  /// Валидация номера телефона
  bool _validatePhone() {
    if (state.phone.trim().isEmpty) {
      state = state.copyWith(error: 'Введите номер телефона');
      return false;
    }

    // Простая валидация номера телефона
    final phoneRegex = RegExp(r'^\+?[0-9\s\-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(state.phone.trim())) {
      state = state.copyWith(error: 'Введите корректный номер телефона');
      return false;
    }

    return true;
  }

  /// Получение кода подтверждения
  Future<void> getVerificationCode() async {
    if (!_validatePhone()) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Устанавливаем режим входа в глобальном состоянии
      globalAuthState.setRegistrationMode(false);

      // Имитация отправки кода
      await Future.delayed(const Duration(seconds: 2));

      // Переход к экрану ввода кода
      navigationService.navigateToVerification(
        phone: state.phone,
        name: '', // Для входа имя не нужно
        image: null,
        isRegistration: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Ошибка при отправке кода: $e',
      );
    }
  }

  /// Навигация назад
  void navigateBack() {
    // Возвращаемся на экран авторизации, но сохраняем данные
    navigationService.navigateToAuth();
  }
}

final loginViewModelProvider = StateNotifierProvider.autoDispose<LoginViewModel, LoginState>(
  (ref) => LoginViewModel(
    ref.read(navigationServiceProvider),
    ref.read(globalAuthStateProvider.notifier),
  ),
);
