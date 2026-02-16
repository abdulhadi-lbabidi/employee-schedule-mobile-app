import 'package:dartz/dartz.dart';

import '../../../../core/unified_api/failures.dart';
import '../../data/ model/dues-report.dart';

abstract class PaymenysRepository {
  Future<Either<Failure, DuesReportModel>> getDuesReport();
}

