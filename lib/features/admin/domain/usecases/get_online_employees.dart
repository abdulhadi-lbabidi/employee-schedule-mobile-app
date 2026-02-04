import 'package:injectable/injectable.dart';

import '../entities/employee_entity.dart';
import '../repositories/admin_repository.dart';
@lazySingleton
class GetOnlineEmployeesUseCase {
  final AdminRepository repository;

  GetOnlineEmployeesUseCase(this.repository);

  Future<List<EmployeeEntity>> call() {
    return repository.getOnlineEmployees();
  }
}
