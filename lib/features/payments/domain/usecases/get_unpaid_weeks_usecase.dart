import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/unified_api/failures.dart';
import '../../../../core/unified_api/use_case.dart';
import '../../data/ model/get_unpaid_weeks.dart';
import '../payments_repository/paymenys_repository.dart';
import 'get_unpaid_weeks_params.dart';
@lazySingleton
class GetUnpaidWeeksUseCase
    implements UseCase<List<UnpaidWeeks>, GetUnpaidWeeksParams> {
  final PaymenysRepository repository;

  GetUnpaidWeeksUseCase(this.repository);

  @override
  Future<Either<Failure, List<UnpaidWeeks>>> call(GetUnpaidWeeksParams params) {
    return repository.getUnpaidWeeks(params.employeeId);
  }
}
