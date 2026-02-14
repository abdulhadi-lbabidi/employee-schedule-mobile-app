import 'package:untitled8/common/helper/src/typedef.dart';

import '../repositories/admin_repository.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class UpdateOvertimeRateUseCase {
  final AdminRepository repository;

  UpdateOvertimeRateUseCase(this.repository);

  DataResponse<void> call({required String employeeId, required double newRate}) async {
    return repository.updateOvertimeRate(
      employeeId: employeeId,
      newRate: newRate,
    );
  }
}
