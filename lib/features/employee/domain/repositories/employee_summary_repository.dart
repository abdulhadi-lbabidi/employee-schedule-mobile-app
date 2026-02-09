import 'package:dartz/dartz.dart';
import '../../../../core/unified_api/failures.dart';
import '../entities/employee_summary_entity.dart';

abstract class EmployeeSummaryRepository {
  Future<Either<Failure, EmployeeSummaryEntity>> getEmployeeSummary(String employeeId);
}
