import 'package:untitled8/features/reward/domain/entities/reward_entity.dart';
import 'package:untitled8/features/reward/domain/repositories/reward_repository.dart';

class GetEmployeeRewardsUseCase {
  final RewardRepository repository;

  GetEmployeeRewardsUseCase(this.repository);

  Future<List<RewardEntity>> call(String employeeId) async {
    return await repository.getEmployeeRewards(employeeId);
  }
}
