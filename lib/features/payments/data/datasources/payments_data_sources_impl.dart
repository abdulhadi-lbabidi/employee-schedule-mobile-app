import 'package:injectable/injectable.dart';
import 'package:untitled8/core/unified_api/handling_api_manager.dart';

import '../ model/dues-report.dart';
import '../ model/get_all_payments.dart';
import '../ model/get_unpaid_weeks.dart';
import '../ model/put_update_payments.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../../../../core/unified_api/base_api.dart';
import '../../domain/payments_repository/paymenys_repository.dart';
import '../../domain/usecases/post_payrecords_params.dart';
import '../../domain/usecases/update_payment_params.dart';

@lazySingleton
class PaymentsDataSourcesImpl with HandlingApiManager{

  final BaseApi _baseApi;

  PaymentsDataSourcesImpl({required BaseApi baseApi}) : _baseApi = baseApi;

  Future<DuesReportModel> getDuesReport() async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.get(ApiVariables.getDuesReport()),
      jsonConvert: (json) => DuesReportModel.fromJson(json),

    );
  }
  Future<GetAllPayments> getallpayments() async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.get(ApiVariables.getPayments()),
      jsonConvert: (json) {
        if (json is List) {
          return GetAllPayments.fromJson({"data": json});
        }
        return GetAllPayments.fromJson(json);
      },
    );
  }

  Future<UnpaidWeeksResponse> getUnpaidWeeks(String id) async { // 🔹 تحديث نوع المرتجع هنا
    return wrapHandlingApi(
      tryCall: () => _baseApi.get(ApiVariables.getUnpaidWeeks(id)),
      jsonConvert: (json) => UnpaidWeeksResponse.fromJson(json), // 🔹 استخدام الاستجابة الكاملة
    );
  }
  Future<void> postPayRecords(
      PostPayRecordsParams params,
      ) async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.post(
        ApiVariables.postPayRecords(),
        data: params.toJson(),
      ),
      jsonConvert: (_) {},
    );
  }
  Future<UpdatePayments> putUpdatePayments(
      String id,
      UpdatePaymentParams params,
      ) async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.put(
        ApiVariables.putUpdatePayments(id),
        data: params.toJson(),
      ),
      jsonConvert: (json) => UpdatePayments.fromJson(json),
    );
  }
}
