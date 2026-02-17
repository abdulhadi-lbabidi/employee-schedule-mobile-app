import '../ model/dues-report.dart';
import '../ model/get_unpaid_weeks.dart';
import '../ model/put_update_payments.dart';
import '../../domain/usecases/post_payrecords_params.dart';
import '../../domain/usecases/update_payment_params.dart';

abstract class PaymentsRemoteDataSource {
  Future<DuesReportModel> getDuesReport();

  Future<DuesReportModel> postPayRecords(
      PostPayRecordsParams params,
      );

  Future<UnpaidWeeks> getUnpaidWeeks(String id);

  Future<UpdatePayments> putUpdatePayments(
      String id,
      UpdatePaymentParams params,
      );
}
