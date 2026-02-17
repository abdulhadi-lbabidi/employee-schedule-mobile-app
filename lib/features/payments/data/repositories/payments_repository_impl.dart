import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../ model/dues-report.dart';
import '../ model/get_unpaid_weeks.dart';
import '../ model/put_update_payments.dart';
import '../../../../core/unified_api/error_handler.dart';
import '../../../../core/unified_api/failures.dart';
import '../../domain/payments_repository/paymenys_repository.dart';
import '../../domain/usecases/post_payrecords_params.dart';
import '../../domain/usecases/update_payment_params.dart';
import '../datasources/payments_data_sources_impl.dart';

@LazySingleton(as: PaymenysRepository)
class PaymentsRepositoryImpl
    with HandlingException
    implements PaymenysRepository {

  final PaymentsDataSourcesImpl remote;

  PaymentsRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, DuesReportModel>> getDuesReport() async {
    return wrapHandlingException(
      tryCall: () => remote.getDuesReport(),
    );
  }

  @override
  Future<Either<Failure, DuesReportModel>> potsPayRecords(
      PostPayRecordsParams params,
      ) async {
    return wrapHandlingException(
      tryCall: () => remote.postPayRecords(params),
    );
  }

  @override
  Future<Either<Failure, UnpaidWeeks>> getUnpaidWeeks(String id) async {
    return wrapHandlingException(
      tryCall: () => remote.getUnpaidWeeks(id),
    );
  }

  @override
  Future<Either<Failure, UpdatePayments>> putUpdatePayments(
      String id,
      UpdatePaymentParams params,
      ) async {
    return wrapHandlingException(
      tryCall: () => remote.putUpdatePayments(id, params),
    );
  }

}
