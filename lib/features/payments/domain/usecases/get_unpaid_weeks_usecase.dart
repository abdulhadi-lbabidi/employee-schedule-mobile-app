import 'package:dartz/dartz.dart';

import '../../../../core/unified_api/failures.dart';
import '../../../../core/unified_api/use_case.dart';
import '../../data/ model/get_unpaid_weeks.dart';
import '../payments_repository/paymenys_repository.dart';
import 'get_unpaid_weeks_params.dart';

class GetUnpaidWeeksUseCase
    implements UseCase<UnpaidWeeks, GetUnpaidWeeksParams> {
  final PaymenysRepository repository;

  GetUnpaidWeeksUseCase(this.repository);

  @override
  Future<Either<Failure, UnpaidWeeks>> call(GetUnpaidWeeksParams params) {
    return repository.getUnpaidWeeks(params.employeeId);
  }
}
