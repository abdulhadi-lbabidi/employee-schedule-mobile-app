import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import '../../../../core/unified_api/failures.dart';
import '../../data/models/get_all_rewards.dart';
import '../entities/reward_entity.dart';

abstract class RewardRepository {
  Future<Either<Failure, List<RewardEntity>>> getEmployeeRewards(int employeeId);
  Future<Either<Failure, List<Rewards>>> getAdminRewards();
  Future<Either<Failure, void>> issueReward({
    required int employeeId,
    required int adminId,
    required double amount,
    required String reason,
    required String  date,
  });
}
