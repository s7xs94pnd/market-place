// lib/features/splash/presentation/views/splash_screen.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:kazan/features/splash/splash_viewmodel.dart';
import 'package:lottie/lottie.dart';

/// Экран загрузки приложения
///
/// Для стажеров:
/// 1. Экран наследует от ConsumerStatefulWidget для работы с Riverpod
/// 2. В initState запускается процесс определения следующего экрана
/// 3. В build отображается UI и слушаются изменения состояния
/// 4. Добавление новой UI-логики:
///    - Измените build метод для отображения новых элементов
///    - Используйте ref.watch для подписки на состояние
///    - Используйте ref.read для единоразового чтения значений
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Запускаем проверку при инициализации
    ref.read(splashViewModelProvider.notifier).checkDestination();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(splashViewModelProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/splash1.json',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              repeat: true,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
            const SizedBox(height: 20),
            // Показать состояние загрузки или ошибки
            state.maybeWhen(
              loading: () => const Text(
                'Загрузка...',
                style: TextStyle(color: Colors.grey),
              ),
              error: (error, stack) => Text(
                'Произошла ошибка: $error',
                style: const TextStyle(color: Colors.red),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
