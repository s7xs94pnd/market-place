import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/features/auth/verification/verification_viewmodel.dart';

/// Экран верификации
///
/// 1. Экран наследует от ConsumerStatefulWidget для работы с Riverpod
/// 2. В build отображается UI и слушаются изменения состояния
/// 3. Добавление новой UI-логики:
///    - Измените build метод для отображения новых элементов
///    - Используйте ref.watch для подписки на состояние
///    - Используйте ref.read для единоразового чтения значений
class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Инициализация ViewModel с параметрами из URL
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = GoRouterState.of(context);
      final vm = ref.read(verificationViewModelProvider.notifier);
      vm.initializeFromParams(state);
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(verificationViewModelProvider);
    final vm = ref.read(verificationViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Подтверждение'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Приветствие
              if (state.name.isNotEmpty)
                Text(
                  'Здравствуй, ${state.name}!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              
              const SizedBox(height: 8),
              
              // Описание
              Text(
                'Введите код подтверждения, отправленный на номер ${state.phone}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Поле ввода кода
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Код подтверждения',
                  hintText: '1234',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.security),
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                onChanged: (value) => vm.updateCode(value),
              ),
              
              const SizedBox(height: 32),
              
              // Кнопка подтверждения
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () => vm.verifyCode(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: state.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Подтвердить',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Кнопка "Вернуться назад"
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => vm.navigateBack(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Вернуться назад',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Кнопка повторной отправки кода
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Не получили код? ',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  if (state.canResend)
                    GestureDetector(
                      onTap: () => vm.resendCode(),
                      child: Text(
                        'Получить код повторно',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    Text(
                      'Повторно через ${state.resendTimer}с',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              
              const Spacer(),
              
              // Ошибки
              if (state.error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Text(
                    state.error!,
                    style: TextStyle(color: Colors.red[700]),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
