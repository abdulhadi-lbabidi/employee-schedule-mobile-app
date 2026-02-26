import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/core/unified_api/error_handler.dart';
import 'package:untitled8/core/unified_api/failures.dart';
import '../../domain/entities/penalty_entity.dart';
import '../../domain/repositories/penalty_repository.dart';
import '../datasources/penalty_remote_data_source.dart';

@LazySingleton(as: PenaltyRepository)
class PenaltyRepositoryImpl implements PenaltyRepository {
  final PenaltyRemoteDataSource remoteDataSource;

  PenaltyRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PenaltyEntity>>> getAllPenalties() async {
    try {
      final response = await remoteDataSource.getAllPenalties();
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<PenaltyEntity>>> getEmployeePenalties(int employeeId) async {
    try {
      final response = await remoteDataSource.getEmployeePenalties(employeeId);
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> issuePenalty({
    required int employeeId,
    required int workshopId,
    required double amount,
    required String reason,
    required int adminId,
    required DateTime date,
  }) async {
    try {
      final params = {
        'employee_id': employeeId,
        'workshop_id': workshopId, // 🔹 تم الإضافة هنا
        'amount': amount,
        'reason': reason,
        'admin_id': adminId,
        'date_issued': date.toIso8601String(),
      };
      await remoteDataSource.issuePenalty(params);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
