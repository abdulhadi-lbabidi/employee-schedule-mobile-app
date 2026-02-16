import 'package:injectable/injectable.dart';
import 'package:untitled8/core/unified_api/handling_api_manager.dart';

import '../ model/dues-report.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../../../../core/unified_api/base_api.dart';

@lazySingleton
class PaymentsDataSourcesImpl with HandlingApiManager {
  final BaseApi _baseApi;

  PaymentsDataSourcesImpl({required BaseApi baseApi}) : _baseApi = baseApi;

  Future<DuesReportModel> getDuesReport() async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.get(ApiVariables.getDuesReport()),
      jsonConvert: (json) => DuesReportModel.fromJson(json),
    );
  }
}
