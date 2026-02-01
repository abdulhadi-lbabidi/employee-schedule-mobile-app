import '../entities/employee_entity.dart';
import '../repositories/admin_repository.dart';

class GetEmployeeDetailsUseCase {
  final AdminRepository repository;

  GetEmployeeDetailsUseCase(this.repository);

  Future<EmployeeEntity> call(String employeeId) {
    return repository.getEmployeeDetails(employeeId);
  }
}
