import 'package:injectable/injectable.dart';

import '../repositories/admin_repository.dart';
@lazySingleton
class DeleteWorkshopUseCase {
  final AdminRepository repository;

  DeleteWorkshopUseCase(this.repository);

  Future<void> call(int id) async {
    return repository.deleteWorkshop(id);
  }
}
