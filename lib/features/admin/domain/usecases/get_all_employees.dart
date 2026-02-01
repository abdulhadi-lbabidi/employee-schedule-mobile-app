import '../entities/employee_entity.dart';
import '../repositories/admin_repository.dart';

class GetAllEmployeesUseCase {
  final AdminRepository adminRepository;

  GetAllEmployeesUseCase(this.adminRepository);

  Future<List<EmployeeEntity>> call() {
    return adminRepository.getAllEmployees();
  }
}