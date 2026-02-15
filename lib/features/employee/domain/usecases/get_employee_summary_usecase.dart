import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/unified_api/failures.dart';
import '../../data/models/employee_summary_model.dart';
import '../entities/employee_summary_entity.dart';
import '../repositories/employee_summary_repository.dart';

@injectable
class GetEmployeeSummaryUseCase {
  final EmployeeSummaryRepository repository;

  GetEmployeeSummaryUseCase(this.repository);

  Future<Either<Failure, EmployeeSummaryModel>> call(String employeeId) async {
    return await repository.getEmployeeSummary(employeeId);
  }
}
