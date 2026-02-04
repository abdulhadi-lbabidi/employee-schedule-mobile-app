import 'package:untitled8/features/reward/data/models/reward_model.dart';
import 'package:uuid/uuid.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RewardRemoteDataSourceMock {
  final List<RewardModel> _mockRewards = [];
  final Uuid _uuid = const Uuid();

  Future<List<RewardModel>> getAdminRewards() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    return _mockRewards.toList();
  }

  Future<List<RewardModel>> getEmployeeRewards(String employeeId) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    return _mockRewards
        .where((reward) => reward.employeeId == employeeId)
        .toList();
  }

  Future<void> issueReward({
    required String employeeId,
    required String employeeName,
    required String adminId,
    required String adminName,
    required double amount,
    required String reason,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    final newReward = RewardModel(
      id: _uuid.v4(),
      employeeId: employeeId,
      employeeName: employeeName,
      adminId: adminId,
      adminName: adminName,
      amount: amount,
      reason: reason,
      dateIssued: DateTime.now(),
    );
    _mockRewards.add(newReward);
  }
}
