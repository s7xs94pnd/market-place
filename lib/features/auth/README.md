# Authentication Feature

Папка содержит всю функциональность аутентификации приложения.

## Структура

```
auth/
├── auth_screen.dart              # Главный экран аутентификации
├── auth_viewmodel.dart           # ViewModel главного экрана
├── auth_state_provider.dart      # Глобальное состояние аутентификации
├── login/                        # Функциональность входа
│   ├── login_screen.dart
│   ├── login_viewmodel.dart
│   └── README.md
├── registration/                 # Функциональность регистрации
│   ├── registration_screen.dart
│   ├── registration_viewmodel.dart
│   └── README.md
├── verification/                 # Функциональность верификации
│   ├── verification_screen.dart
│   ├── verification_viewmodel.dart
│   └── README.md
├── success/                      # Функциональность экрана успеха
│   ├── success_screen.dart
│   ├── success_viewmodel.dart
│   └── README.md
└── README.md                     # Этот файл
```

## Общая функциональность

### Поток аутентификации:
1. **Auth Screen** - выбор между регистрацией и входом
2. **Registration/Login** - ввод данных пользователя
3. **Verification** - подтверждение кода
4. **Success** - приветственное сообщение
5. **Home** - переход в приложение

### Особенности:
- **Персонализированные сообщения** для регистрации и входа
- **Автоматический переход** через 3 секунды на экране успеха
- **Таймер повторной отправки** кода верификации
- **Валидация данных** на каждом этапе
- **Обработка ошибок** с пользовательскими сообщениями

## Архитектура

- **MVVM** паттерн для каждого экрана
- **Riverpod** для управления состоянием
- **GoRouter** для навигации
- **Clean Architecture** с разделением на слои
- **Dependency Injection** через провайдеры

## Навигация

Все переходы осуществляются через `NavigationService`:
- `navigateToRegistration()` - переход к регистрации
- `navigateToLogin()` - переход к входу
- `navigateToVerification()` - переход к верификации
- `navigateToSuccess()` - переход к экрану успеха
- `navigateToHome()` - переход в приложение
