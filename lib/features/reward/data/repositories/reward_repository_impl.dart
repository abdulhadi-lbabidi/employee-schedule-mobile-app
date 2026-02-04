import 'package:injectable/injectable.dart';
import 'package:untitled8/features/reward/data/datasources/reward_remote_data_source_impl.dart';

import '../../domain/repositories/reward_repository.dart';
import '../datasources/reward_remote_data_source.dart';
import '../../domain/entities/reward_entity.dart';

@LazySingleton(as:RewardRepository )
class RewardRepositoryImpl implements RewardRepository {
  final RewardRemoteDataSourceImpl remoteDataSource;

  RewardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<RewardEntity>> getAdminRewards() async {
    return await remoteDataSource.getAdminRewards();
  }

  @override
  Future<List<RewardEntity>> getEmployeeRewards(String employeeId) async {
    return await remoteDataSource.getEmployeeRewards(employeeId);
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
    return await remoteDataSource.issueReward(
      employeeId: employeeId,
      employeeName: employeeName,
      adminId: adminId,
      adminName: adminName,
      amount: amount,
      reason: reason,
    );
  }
}
