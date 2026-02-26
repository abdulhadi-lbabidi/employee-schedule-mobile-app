import 'package:dartz/dartz.dart';
import '../../../../core/unified_api/failures.dart';
import '../entities/penalty_entity.dart';

abstract class PenaltyRepository {
  Future<Either<Failure, List<PenaltyEntity>>> getAllPenalties();
  Future<Either<Failure, List<PenaltyEntity>>> getEmployeePenalties(int employeeId);
  Future<Either<Failure, void>> issuePenalty({
    required int employeeId,
    required int workshopId, // 🔹 إضافة رقم الورشة
    required double amount,
    required String reason,
    required int adminId,
    required DateTime date,
  });
}
