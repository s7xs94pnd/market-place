import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace/core/services/navigation_service.dart';
import 'package:marketplace/domain/repositories/local_storage_repository.dart';
import 'package:marketplace/core/providers/providers.dart';

class OnboardingState {
  final int currentPageIndex;
  final int totalPages;
  const OnboardingState({required this.currentPageIndex, required this.totalPages});

  OnboardingState copyWith({int? currentPageIndex, int? totalPages}) => OnboardingState(
    currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    totalPages: totalPages ?? this.totalPages,
  );
}

class OnboardingViewModel extends StateNotifier<OnboardingState> {
  final LocalStorageRepository repository;
  final NavigationService navigationService;

  OnboardingViewModel(this.repository, this.navigationService)
      : super(const OnboardingState(currentPageIndex: 0, totalPages: 3));

  void onPageChanged(int index) {
    state = state.copyWith(currentPageIndex: index);
  }

  bool get isLastPage => state.currentPageIndex == state.totalPages - 1;

  // Пропуск теперь не завершает онбординг и не навигирует — только UI переводит на последнюю страницу
  void onSkip() {}

  Future<void> onStart() async {
    await repository.setBoardingCompleted(true);
    final token = await repository.getToken();
    if (token != null && token.isNotEmpty) {
      navigationService.navigateToHome(isGuest: false);
    } else {
      navigationService.navigateToAuth();
    }
  }
}

final onboardingViewModelProvider = StateNotifierProvider.autoDispose<OnboardingViewModel, OnboardingState>(
  (ref) => OnboardingViewModel(
    ref.read(localStorageRepositoryProvider),
    ref.read(navigationServiceProvider),
  ),
);


