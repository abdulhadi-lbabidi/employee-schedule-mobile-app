import '../repositories/admin_repository.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class UpdateHourlyRateUseCase {
  final AdminRepository repository;

  UpdateHourlyRateUseCase(this.repository);

  Future<void> call({
    required String employeeId,
    required double newRate,
  }) {
    return repository.updateHourlyRate(
      employeeId: employeeId,
      newRate: newRate,
    );
  }
}
