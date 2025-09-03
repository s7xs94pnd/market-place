import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/features/auth/success/success_viewmodel.dart';

/// Экран успешной верификации
///
/// 1. Экран наследует от ConsumerStatefulWidget для работы с Riverpod
/// 2. В build отображается UI и слушаются изменения состояния
/// 3. Добавление новой UI-логики:
///    - Измените build метод для отображения новых элементов
///    - Используйте ref.watch для подписки на состояние
///    - Используйте ref.read для единоразового чтения значений
class SuccessScreen extends ConsumerStatefulWidget {
  const SuccessScreen({super.key});

  @override
  ConsumerState<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends ConsumerState<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    // Инициализация ViewModel с параметрами из URL
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = GoRouterState.of(context);
      final vm = ref.read(successViewModelProvider.notifier);
      vm.initializeFromParams(state);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(successViewModelProvider);
    final vm = ref.read(successViewModelProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Иконка успеха
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green[50],
                  border: Border.all(
                    color: Colors.green,
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.check,
                  size: 60,
                  color: Colors.green,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Заголовок
              Text(
                'Добро пожаловать!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Приветственное сообщение
              Text(
                state.isRegistration 
                    ? 'Вы успешно зарегистрированы в приложении!'
                    : 'Вы успешно вошли в аккаунт!',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              if (state.name.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Рады видеть вас, ${state.name}!',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              
              const SizedBox(height: 48),
              
              // Кнопка перехода в приложение
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => vm.navigateToHome(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Перейти в приложение',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Автоматический переход через 3 секунды
              Text(
                'Автоматический переход через ${state.countdown}с',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
