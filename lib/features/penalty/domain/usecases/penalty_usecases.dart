import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/unified_api/failures.dart';
import '../entities/penalty_entity.dart';
import '../repositories/penalty_repository.dart';

@injectable
class GetAllPenaltiesUseCase {
  final PenaltyRepository repository;
  GetAllPenaltiesUseCase(this.repository);

  Future<Either<Failure, List<PenaltyEntity>>> call() async {
    return await repository.getAllPenalties();
  }
}

@injectable
class GetEmployeePenaltiesUseCase {
  final PenaltyRepository repository;
  GetEmployeePenaltiesUseCase(this.repository);

  Future<Either<Failure, List<PenaltyEntity>>> call(int employeeId) async {
    return await repository.getEmployeePenalties(employeeId);
  }
}

@injectable
class IssuePenaltyUseCase {
  final PenaltyRepository repository;
  IssuePenaltyUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int employeeId,
    required int workshopId, //  إضافة رقم الورشة
    required double amount,
    required String reason,
    required int adminId,
    required DateTime date,
  }) async {
    return await repository.issuePenalty(
      employeeId: employeeId,
      workshopId: workshopId, //  تمرير رقم الورشة
      amount: amount,
      reason: reason,
      adminId: adminId,
      date: date,
    );
  }
}
