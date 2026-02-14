import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/unified_api/failures.dart';
import '../repositories/reward_repository.dart';

@injectable
class IssueRewardUseCase {
  final RewardRepository repository;

  IssueRewardUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int employeeId,
    required double amount,
    required String reason,
  }) async {
    return await repository.issueReward(
      employeeId: employeeId,
      amount: amount,
      reason: reason,
    );
  }
}
