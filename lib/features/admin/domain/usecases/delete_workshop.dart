import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/typedef.dart';

import '../repositories/admin_repository.dart';
@lazySingleton
class DeleteWorkshopUseCase {
  final AdminRepository repository;

  DeleteWorkshopUseCase(this.repository);

  DataResponse<void> call(int id) async {
    return repository.deleteWorkshop(id);
  }
}
