import 'package:injectable/injectable.dart';

import '../repositories/admin_repository.dart';

@lazySingleton
class DeleteEmployeeUseCase {
  final AdminRepository repository;

  DeleteEmployeeUseCase(this.repository);

  Future<void> call(String id) async {
    return repository.deleteEmployee(id);
  }
}
