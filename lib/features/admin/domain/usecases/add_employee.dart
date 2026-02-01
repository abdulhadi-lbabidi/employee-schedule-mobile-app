import '../entities/employee_entity.dart';
import '../repositories/admin_repository.dart';

class AddEmployeeUseCase {
  final AdminRepository repository;

  AddEmployeeUseCase(this.repository);

  Future<void> call(EmployeeEntity employee) async {
    return repository.addEmployee(employee);
  }
}
