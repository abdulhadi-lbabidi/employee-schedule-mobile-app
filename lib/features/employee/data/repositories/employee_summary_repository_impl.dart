import 'package:dartz/dartz.dart';
import 'package:untitled8/core/unified_api/error_handler.dart';
import 'package:untitled8/core/unified_api/failures.dart';
import '../../domain/entities/employee_summary_entity.dart';
import '../../domain/repositories/employee_summary_repository.dart';
import '../datasources/employee_summary_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: EmployeeSummaryRepository)
class EmployeeSummaryRepositoryImpl implements EmployeeSummaryRepository {
  final EmployeeSummaryRemoteDataSource remoteDataSource;

  EmployeeSummaryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, EmployeeSummaryEntity>> getEmployeeSummary(String employeeId) async {
    try {
      final response = await remoteDataSource.getEmployeeSummary(employeeId);
      print('response.data: ${response.data}');
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
