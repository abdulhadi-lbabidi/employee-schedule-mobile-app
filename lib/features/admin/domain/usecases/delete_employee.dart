import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/typedef.dart';

import '../repositories/admin_repository.dart';

@lazySingleton
class DeleteEmployeeUseCase {
  final AdminRepository repository;

  DeleteEmployeeUseCase(this.repository);

  DataResponse<void> call(String id) async {
    return repository.deleteEmployee(id);
  }
}
