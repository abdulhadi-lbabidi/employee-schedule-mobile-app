import 'package:dartz/dartz.dart';
import 'package:untitled8/features/payments/domain/usecases/post_payrecords_params.dart';

import '../../../../core/unified_api/failures.dart';
import '../../../../core/unified_api/use_case.dart';
import '../../data/ model/dues-report.dart';
import '../payments_repository/paymenys_repository.dart';

class PostPayRecordsUseCase
    implements UseCase<void, PostPayRecordsParams> {
  final PaymenysRepository repository;

  PostPayRecordsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(
      PostPayRecordsParams params) async {
    return repository.potsPayRecords(params);
  }
}
