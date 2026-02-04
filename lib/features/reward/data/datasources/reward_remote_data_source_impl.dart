import 'package:dio/dio.dart';
import '../../../../core/unified_api/api_variables.dart';
import 'reward_remote_data_source.dart';
import '../models/reward_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RewardRemoteDataSourceImpl {
  final Dio dio;

  RewardRemoteDataSourceImpl({required this.dio});

  Future<List<RewardModel>> getAdminRewards() async {
    try {
      final response = await dio.getUri(ApiVariables.adminRewards());
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

  Future<List<RewardModel>> getEmployeeRewards(String employeeId) async {
    try {
      final response = await dio.getUri(ApiVariables.employeeRewards(employeeId));
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

  Future<void> issueReward({
    required String employeeId,
    required String employeeName,
    required String adminId,
    required String adminName,
    required double amount,
    required String reason,
  })
  async {
    try {
      final response = await dio.postUri(ApiVariables.issueReward(), data: {
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
