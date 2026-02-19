import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import '../../../../core/unified_api/failures.dart';
import '../repositories/reward_repository.dart';

@injectable
class IssueRewardUseCase {
  final RewardRepository repository;

  IssueRewardUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int employeeId,
    required int adminId,
    required double amount,
    required String reason,
    required String  date,
  }) async {
    return await repository.issueReward(
      employeeId: employeeId,
      adminId: adminId,
      amount: amount,
      reason: reason,
      date: date,
    );
  }
}
