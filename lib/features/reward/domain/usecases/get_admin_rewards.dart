import 'package:untitled8/features/reward/domain/entities/reward_entity.dart';
import 'package:untitled8/features/reward/domain/repositories/reward_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetAdminRewardsUseCase {
  final RewardRepository repository;

  GetAdminRewardsUseCase(this.repository);

  Future<List<RewardEntity>> call() async {
    return await repository.getAdminRewards();
  }
}
