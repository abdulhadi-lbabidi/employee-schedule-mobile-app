import 'package:intl/intl.dart';
import 'package:untitled8/core/unified_api/base_api.dart';
import 'package:untitled8/core/unified_api/handling_api_manager.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../models/get_all_rewards.dart';
import '../models/reward_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RewardRemoteDataSource with HandlingApiManager {
  final BaseApi _baseApi;

  RewardRemoteDataSource(this._baseApi);

  Future<RewardResponse> getEmployeeRewards(int employeeId) async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.get(ApiVariables.employeeRewards(employeeId)),
      jsonConvert: (json) => RewardResponse.fromJson(json),
    );
  }

  Future<GetAllRewards> getAdminRewards() async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.get(ApiVariables.adminRewards()),
      jsonConvert: (json) => GetAllRewards.fromJson(json),
    );
  }

  Future<void> issueReward({
    required int employeeId,
    required int adminId,
    required double amount,
    required String reason,
    required String  dateissued,
  }) async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.post(
        ApiVariables.issueReward(),
        data: {
          'employee_id': employeeId,
          'admin_id': adminId,
          'amount': amount,
          'reason': reason,
          'date_issued': dateissued,
        },
      ),
      jsonConvert: (_) {},
    );
  }
}
