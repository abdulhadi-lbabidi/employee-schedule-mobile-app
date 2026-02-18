

import 'package:untitled8/common/helper/src/typedef.dart';

import '../repositories/admin_repository.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class RestoreEmployeeArchiveUseCase {
  final AdminRepository repository;

  RestoreEmployeeArchiveUseCase(this.repository);

  DataResponse<void> call(String id) async {
    return await repository.restoreEmployeeArchive(id);
  }
}
