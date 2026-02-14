import 'package:dartz/dartz.dart';
import '../../../../core/unified_api/failures.dart';
import '../entities/reward_entity.dart';

abstract class RewardRepository {
  Future<Either<Failure, List<RewardEntity>>> getEmployeeRewards(int employeeId);
  Future<Either<Failure, List<RewardEntity>>> getAdminRewards();
  Future<Either<Failure, void>> issueReward({
    required int employeeId,
    required double amount,
    required String reason,
  });
}
