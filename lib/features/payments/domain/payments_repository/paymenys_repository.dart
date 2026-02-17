import 'package:dartz/dartz.dart';

import '../../../../core/unified_api/failures.dart';
import '../../data/ model/dues-report.dart';
import '../../data/ model/get_unpaid_weeks.dart';
import '../../data/ model/put_update_payments.dart';
import '../usecases/post_payrecords_params.dart';
import '../usecases/update_payment_params.dart';

abstract class PaymenysRepository {
  Future<Either<Failure, DuesReportModel>> getDuesReport();
  Future<Either<Failure, DuesReportModel>> potsPayRecords(
      PostPayRecordsParams params,
      );
  Future<Either<Failure, UnpaidWeeks>> getUnpaidWeeks(String id);
  Future<Either<Failure, UpdatePayments>> putUpdatePayments(String id,
      UpdatePaymentParams params,);
}

