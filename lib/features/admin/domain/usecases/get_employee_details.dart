import 'package:injectable/injectable.dart';

import '../entities/employee_entity.dart';
import '../repositories/admin_repository.dart';
@lazySingleton
class GetEmployeeDetailsUseCase {
  final AdminRepository repository;

  GetEmployeeDetailsUseCase(this.repository);

  Future<EmployeeEntity> call(String employeeId) {
    return repository.getEmployeeDetails(employeeId);
  }
}
