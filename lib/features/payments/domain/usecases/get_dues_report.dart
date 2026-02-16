import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/unified_api/failures.dart';
import '../../data/ model/dues-report.dart';
import '../payments_repository/paymenys_repository.dart';

@lazySingleton
class GetDuesReport {
  final PaymenysRepository repository;

  GetDuesReport(this.repository);

  Future<Either<Failure, DuesReportModel>> call() async {
    return await repository.getDuesReport();
  }
}
