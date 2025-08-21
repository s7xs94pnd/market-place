// lib/domain/usecases/check_start_destination_usecase.dart
import '../../core/navigation/start_destination.dart';
import '../repositories/local_storage_repository.dart';

/// UseCase для определения стартового экрана после Splash
///
/// Для стажеров:
/// 1. UseCase инкапсулирует бизнес-логику приложения
/// 2. Не должен содержать код, связанный с UI или платформой
/// 3. Добавление новой логики:
///    - Измените метод call() согласно новой бизнес-логике
///    - Верните соответствующий StartDestination
class CheckStartDestinationUseCase {
  final LocalStorageRepository repository;

  CheckStartDestinationUseCase(this.repository);

  Future<StartDestination> call() async {
    final isFirstLaunch = await repository.getIsFirstLaunch();
    if (isFirstLaunch) return StartDestination.onboarding;

    final token = await repository.getAuthToken();
    if (token != null) return StartDestination.homeUser;

    final isGuest = await repository.getIsGuest();
    if (isGuest) return StartDestination.homeGuest;

    return StartDestination.auth;
  }
}
