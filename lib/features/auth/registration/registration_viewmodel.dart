import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/core/services/navigation_service.dart';
import 'package:marketplace/core/providers/providers.dart';
import 'package:marketplace/features/auth/auth_state_provider.dart';

/// Состояние экрана регистрации
class RegistrationState {
  final File? selectedImage;
  final String name;
  final String phone;
  final bool isLoading;
  final String? error;

  const RegistrationState({
    this.selectedImage,
    this.name = '',
    this.phone = '',
    this.isLoading = false,
    this.error,
  });

  RegistrationState copyWith({
    File? selectedImage,
    String? name,
    String? phone,
    bool? isLoading,
    String? error,
  }) {
    return RegistrationState(
      selectedImage: selectedImage ?? this.selectedImage,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// ViewModel для экрана регистрации
///
/// Для стажеров:
/// 1. ViewModel содержит бизнес-логику экрана
/// 2. Наследуется от StateNotifier для управления состоянием
/// 3. Использует NavigationService для навигации
/// 4. Добавление новой логики:
///    - Добавьте новые методы для обработки пользовательских действий
///    - Обновляйте состояние через state = newState
///    - Не забывайте обрабатывать ошибки
class RegistrationViewModel extends StateNotifier<RegistrationState> {
  final NavigationService navigationService;
  final GlobalAuthStateNotifier globalAuthState;
  final ImagePicker _imagePicker = ImagePicker();

  RegistrationViewModel(this.navigationService, this.globalAuthState) : super(const RegistrationState()) {
    // Загружаем сохраненные данные при инициализации
    _loadSavedData();
  }

  /// Загрузка сохраненных данных
  void _loadSavedData() {
    final savedState = globalAuthState.state;
    if (savedState.isRegistration) {
      state = state.copyWith(
        name: savedState.name,
        phone: savedState.phone,
        selectedImage: savedState.image,
      );
    }
  }

  /// Выбор изображения
  Future<void> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        final file = File(image.path);
        state = state.copyWith(
          selectedImage: file,
          error: null,
        );
        globalAuthState.updateImage(file);
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Ошибка при выборе изображения: $e',
      );
    }
  }

  /// Обновление имени
  void updateName(String name) {
    state = state.copyWith(name: name, error: null);
    globalAuthState.updateName(name);
  }

  /// Обновление номера телефона
  void updatePhone(String phone) {
    state = state.copyWith(phone: phone, error: null);
    globalAuthState.updatePhone(phone);
  }

  /// Валидация формы
  bool _validateForm() {
    if (state.name.trim().isEmpty) {
      state = state.copyWith(error: 'Введите ваше имя');
      return false;
    }

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
    if (!_validateForm()) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Устанавливаем режим регистрации в глобальном состоянии
      globalAuthState.setRegistrationMode(true);

      // Имитация отправки кода
      await Future.delayed(const Duration(seconds: 2));

      // Переход к экрану ввода кода
      navigationService.navigateToVerification(
        phone: state.phone,
        name: state.name,
        image: state.selectedImage,
        isRegistration: true,
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

final registrationViewModelProvider = StateNotifierProvider.autoDispose<RegistrationViewModel, RegistrationState>(
  (ref) => RegistrationViewModel(
    ref.read(navigationServiceProvider),
    ref.read(globalAuthStateProvider.notifier),
  ),
);
