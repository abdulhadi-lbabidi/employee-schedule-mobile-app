import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/unified_api/failures.dart';
import '../entities/reward_entity.dart';
import '../repositories/reward_repository.dart';

@injectable
class GetEmployeeRewardsUseCase {
  final RewardRepository repository;

  GetEmployeeRewardsUseCase(this.repository);

  Future<Either<Failure, List<RewardEntity>>> call(int employeeId) async {
    return await repository.getEmployeeRewards(employeeId);
  }
}
