import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace/core/services/navigation_service.dart';
import 'package:marketplace/core/providers/providers.dart';

/// Состояние экрана авторизации
class AuthState {
  const AuthState();
}

/// ViewModel для экрана авторизации
///
/// 1. ViewModel содержит бизнес-логику экрана
/// 2. Наследуется от StateNotifier для управления состоянием
/// 3. Использует NavigationService для навигации
/// 4. Добавление новой логики:
///    - Добавьте новые методы для обработки пользовательских действий
///    - Обновляйте состояние через state = newState
///    - Не забывайте обрабатывать ошибки
class AuthViewModel extends StateNotifier<AuthState> {
  final NavigationService navigationService;

  AuthViewModel(this.navigationService) : super(const AuthState());

    /// Навигация к экрану регистрации
  void navigateToRegistration() {
    navigationService.navigateToRegistration();
  }

  /// Навигация к экрану входа
  void navigateToLogin() {
    navigationService.navigateToLogin();
  }
}

final authViewModelProvider = StateNotifierProvider.autoDispose<AuthViewModel, AuthState>(
  (ref) => AuthViewModel(
    ref.read(navigationServiceProvider),
  ),
);
