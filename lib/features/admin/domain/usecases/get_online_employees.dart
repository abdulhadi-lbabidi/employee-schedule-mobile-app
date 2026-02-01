import '../entities/employee_entity.dart';
import '../repositories/admin_repository.dart';

class GetOnlineEmployeesUseCase {
  final AdminRepository repository;

  GetOnlineEmployeesUseCase(this.repository);

  Future<List<EmployeeEntity>> call() {
    return repository.getOnlineEmployees();
  }
}
