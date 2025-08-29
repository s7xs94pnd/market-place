import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kazan/features/onboarding/onboarding_viewmodel.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  List<_OnboardingPageData> _pages(BuildContext context) => [
    _OnboardingPageData(
      imageAsset: 'assets/images/logo.svg',
      title: 'Добро пожаловать',
      description: 'Краткое описание преимуществ приложения и как начать.',
    ),
    _OnboardingPageData(
      imageAsset: 'assets/images/logo.svg',
      title: 'Будьте в курсе',
      description: 'Получайте актуальные обновления и уведомления своевременно.',
    ),
    _OnboardingPageData(
      imageAsset: 'assets/images/logo.svg',
      title: 'Готовы стартовать?',
      description: 'Завершите онбординг и начните пользоваться приложением.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingViewModelProvider);
    final vm = ref.read(onboardingViewModelProvider.notifier);

    return PopScope(
      canPop: state.currentPageIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && state.currentPageIndex > 0) {
          final prev = state.currentPageIndex - 1;
          _pageController.animateToPage(
            prev,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      },
      child: Scaffold(
      body: Stack(
        children: [
          // Фон (не меняется)
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: 0.06,
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Контент
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 26),
              child: Column(
                children: [
                  // Верхняя полоса фиксированной высоты: «Пропустить» или прозрачный заполнитель
                  SizedBox(
                    height: 40,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: state.currentPageIndex != _pages(context).length - 1
                          ? TextButton(
                              onPressed: () {
                                final lastIndex = _pages(context).length - 1;
                                _pageController.animateToPage(
                                  lastIndex,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              },
                              child: const Text('Пропустить'),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Карточка онбординга (вся карточка — свайпабельный PageView)
                  Expanded(
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Прокручиваемая часть: картинка + тексты
                            Expanded(
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: _pages(context).length,
                                onPageChanged: vm.onPageChanged,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final page = _pages(context)[index];
                                  return Column(
                                    children: [
                                      // Картинка (верх ~50%)
                                      Expanded(
                                        flex: 5,
                                        child: Center(
                                          child: SvgPicture.asset(
                                            page.imageAsset,
                                            height: double.infinity,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      // Тексты (низ ~50%)
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              page.title,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              page.description,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    color: Colors.grey[700],
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Индикаторы страниц (фиксированы)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _pages(context).length,
                                (dotIndex) => Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: dotIndex == state.currentPageIndex
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Кнопка Next / Let's Start (фиксирована)
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final isLast = state.currentPageIndex == _pages(context).length - 1;
                                  if (isLast) {
                                    await vm.onStart();
                                  } else {
                                    final next = state.currentPageIndex + 1;
                                    _pageController.animateToPage(
                                      next,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                    );
                                  }
                                },
                                child: Text(
                                  state.currentPageIndex == _pages(context).length - 1
                                      ? "Let's Start"
                                      : 'Далее',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Вспомогательный пустой блок (ранее был невидимый PageView) больше не нужен
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class _OnboardingPageData {
  final String imageAsset;
  final String title;
  final String description;
  const _OnboardingPageData({
    required this.imageAsset,
    required this.title,
    required this.description,
  });
}

