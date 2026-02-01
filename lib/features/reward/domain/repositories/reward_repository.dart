import 'package:untitled8/features/reward/domain/entities/reward_entity.dart';

abstract class RewardRepository {
  Future<List<RewardEntity>> getAdminRewards();
  Future<List<RewardEntity>> getEmployeeRewards(String employeeId);
  Future<void> issueReward({
    required String employeeId,
    required String employeeName,
    required String adminId,
    required String adminName,
    required double amount,
    required String reason,
  });
}
