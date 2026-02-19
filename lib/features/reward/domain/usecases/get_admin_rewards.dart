import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/unified_api/failures.dart';
import '../../data/models/get_all_rewards.dart';
import '../entities/reward_entity.dart';
import '../repositories/reward_repository.dart';

@injectable
class GetAdminRewardsUseCase {
  final RewardRepository repository;

  GetAdminRewardsUseCase(this.repository);

  Future<Either<Failure, List<Rewards>>> call() async {
    return await repository.getAdminRewards();
  }
}
