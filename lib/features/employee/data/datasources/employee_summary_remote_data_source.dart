  import 'package:untitled8/core/unified_api/base_api.dart';
import 'package:untitled8/core/unified_api/handling_api_manager.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../models/employee_summary_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class EmployeeSummaryRemoteDataSource with HandlingApiManager {
  final BaseApi _baseApi;

  EmployeeSummaryRemoteDataSource(this._baseApi);

  Future<EmployeeSummaryModel> getEmployeeSummary(String empId) async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.get(ApiVariables.getEmployeesHoursAndPaySummary(empId)),
      jsonConvert: (json) => EmployeeSummaryModel.fromJson(json),
    );
  }
}
