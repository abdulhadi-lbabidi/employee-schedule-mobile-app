import '../repositories/admin_repository.dart';

class DeleteWorkshopUseCase {
  final AdminRepository repository;

  DeleteWorkshopUseCase(this.repository);

  Future<void> call(String id) async {
    return repository.deleteWorkshop(id);
  }
}
