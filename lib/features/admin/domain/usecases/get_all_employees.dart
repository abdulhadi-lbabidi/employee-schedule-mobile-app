import 'package:injectable/injectable.dart';

import '../entities/employee_entity.dart';
import '../repositories/admin_repository.dart';

@lazySingleton
class GetAllEmployeesUseCase {
  final AdminRepository adminRepository;

  GetAllEmployeesUseCase(this.adminRepository);

  Future<List<EmployeeEntity>> call() {
    return adminRepository.getAllEmployees();
  }
}