import 'package:untitled8/features/reward/domain/repositories/reward_repository.dart';

class IssueRewardUseCase {
  final RewardRepository repository;

  IssueRewardUseCase(this.repository);

  Future<void> call({
    required String employeeId,
    required String employeeName,
    required String adminId,
    required String adminName,
    required double amount,
    required String reason,
  }) async {
    await repository.issueReward(
      employeeId: employeeId,
      employeeName: employeeName,
      adminId: adminId,
      adminName: adminName,
      amount: amount,
      reason: reason,
    );
  }
}
