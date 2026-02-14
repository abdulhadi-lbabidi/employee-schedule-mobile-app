import 'package:untitled8/core/unified_api/base_api.dart';
import 'package:untitled8/core/unified_api/handling_api_manager.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../models/reward_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RewardRemoteDataSource with HandlingApiManager {
  final BaseApi _baseApi;

  RewardRemoteDataSource(this._baseApi);

  Future<RewardResponse> getEmployeeRewards(int employeeId) async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.get(ApiVariables.getemPloyeeRewards(employeeId)),
      jsonConvert: (json) => RewardResponse.fromJson(json),
    );
  }

  Future<RewardResponse> getAdminRewards() async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.get(ApiVariables.adminRewards()),
      jsonConvert: (json) => RewardResponse.fromJson(json),
    );
  }

  Future<void> issueReward({
    required int employeeId,
    required double amount,
    required String reason,
  }) async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.post(
        ApiVariables.postRewards(),
        data: {
          'employee_id': employeeId,
          'amount': amount,
          'reason': reason,
        },
      ),
      jsonConvert: (_) {},
    );
  }
}
