import 'package:injectable/injectable.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../../../../core/unified_api/base_api.dart';
import '../../../../core/unified_api/handling_api_manager.dart';
import '../models/penalty_model.dart';

@lazySingleton
class PenaltyRemoteDataSource with HandlingApiManager {
  final BaseApi _baseApi;

  PenaltyRemoteDataSource(this._baseApi);

  Future<PenaltyResponse> getAllPenalties() async {
    return wrapHandlingApi<PenaltyResponse>(
      tryCall: () async => _baseApi.get(ApiVariables.adminPenalties()),
      jsonConvert: (json) => PenaltyResponse.fromJson(json),
    );
  }

  Future<PenaltyResponse> getEmployeePenalties(int employeeId) async {
    return wrapHandlingApi<PenaltyResponse>(
      tryCall: () async => _baseApi.get(ApiVariables.employeePenalties(employeeId)),
      jsonConvert: (json) => PenaltyResponse.fromJson(json),
    );
  }

  Future<void> issuePenalty(Map<String, dynamic> params) async {
    return wrapHandlingApi<void>(
      tryCall: () async => _baseApi.post(ApiVariables.issuePenalty(), data: params),
      jsonConvert: (json) => null,
    );
  }
}
