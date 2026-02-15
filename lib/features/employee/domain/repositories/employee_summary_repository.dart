import 'package:dartz/dartz.dart';
import '../../../../core/unified_api/failures.dart';
import '../../data/models/employee_summary_model.dart';
import '../entities/employee_summary_entity.dart';

abstract class EmployeeSummaryRepository {
  Future<Either<Failure, EmployeeSummaryModel>> getEmployeeSummary(String employeeId);
}
