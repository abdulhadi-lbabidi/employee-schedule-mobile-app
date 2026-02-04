import 'package:injectable/injectable.dart';

import '../repositories/admin_repository.dart';

@lazySingleton
class ConfirmPaymentUseCase {
  final AdminRepository repository;

  ConfirmPaymentUseCase(this.repository);

  Future<void> call({required String employeeId, required int weekNumber}) async {
    return repository.confirmPayment(
      employeeId: employeeId,
      weekNumber: weekNumber,
    );
  }
}
