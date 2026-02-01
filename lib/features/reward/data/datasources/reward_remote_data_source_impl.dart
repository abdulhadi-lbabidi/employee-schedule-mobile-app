import 'package:dio/dio.dart';
import '../../../../core/unified_api/api_variables.dart';
import 'reward_remote_data_source.dart';
import '../models/reward_model.dart';

class RewardRemoteDataSourceImpl implements RewardRemoteDataSource {
  final Dio dio;
  final ApiVariables apiVariables = ApiVariables();

  RewardRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<RewardModel>> getAdminRewards() async {
    try {
      final response = await dio.getUri(apiVariables.adminRewards());
      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((json) => RewardModel.fromJson(json))
            .toList();
      } else {
        throw Exception('فشل جلب المكافآت');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  @override
  Future<List<RewardModel>> getEmployeeRewards(String employeeId) async {
    try {
      final response = await dio.getUri(apiVariables.employeeRewards(employeeId));
      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((json) => RewardModel.fromJson(json))
            .toList();
      } else {
        throw Exception('فشل جلب مكافآت الموظف');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  @override
  Future<void> issueReward({
    required String employeeId,
    required String employeeName,
    required String adminId,
    required String adminName,
    required double amount,
    required String reason,
  }) async {
    try {
      final response = await dio.postUri(apiVariables.issueReward(), data: {
        'employee_id': employeeId,
        'employee_name': employeeName,
        'admin_id': adminId,
        'admin_name': adminName,
        'amount': amount,
        'reason': reason,
        'date_issued': DateTime.now().toIso8601String(),
      });

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('فشل عملية صرف المكافأة');
      }
    } catch (e) {
      throw Exception('خطأ في إرسال البيانات: $e');
    }
  }
}
