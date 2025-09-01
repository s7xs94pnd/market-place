import 'dart:io';
import 'package:riverpod/riverpod.dart';

/// Глобальное состояние аутентификации для сохранения данных между экранами
class GlobalAuthState {
  final String name;
  final String phone;
  final File? image;
  final bool isRegistration;

  const GlobalAuthState({
    this.name = '',
    this.phone = '',
    this.image,
    this.isRegistration = false,
  });

  GlobalAuthState copyWith({
    String? name,
    String? phone,
    File? image,
    bool? isRegistration,
  }) {
    return GlobalAuthState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      isRegistration: isRegistration ?? this.isRegistration,
    );
  }

  /// Очистка всех данных (вызывается после успешной авторизации)
  GlobalAuthState clear() {
    return const GlobalAuthState();
  }
}

/// Провайдер для глобального состояния аутентификации
final globalAuthStateProvider = StateNotifierProvider<GlobalAuthStateNotifier, GlobalAuthState>(
  (ref) => GlobalAuthStateNotifier(),
);

/// Notifier для управления глобальным состоянием аутентификации
class GlobalAuthStateNotifier extends StateNotifier<GlobalAuthState> {
  GlobalAuthStateNotifier() : super(const GlobalAuthState());

  /// Обновление имени
  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  /// Обновление номера телефона
  void updatePhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  /// Обновление изображения
  void updateImage(File? image) {
    state = state.copyWith(image: image);
  }

  /// Установка режима регистрации
  void setRegistrationMode(bool isRegistration) {
    state = state.copyWith(isRegistration: isRegistration);
  }

  /// Очистка всех данных (после успешной авторизации)
  void clearData() {
    state = state.clear();
  }
}
