// lib/domain/usecases/check_start_destination_usecase.dart
import '../../core/enums/start_destination.dart';
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
    final boardingCompleted = await repository.getBoardingCompleted();
    if (!boardingCompleted) {
      return StartDestination.onboarding;
    }

    final token = await repository.getToken();
    if (token != null && token.isNotEmpty) {
      return StartDestination.homeUser;
    }

    return StartDestination.auth;
  }
}
