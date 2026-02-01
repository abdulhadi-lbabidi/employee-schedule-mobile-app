import '../repositories/admin_repository.dart';

class ToggleEmployeeArchiveUseCase {
  final AdminRepository repository;

  ToggleEmployeeArchiveUseCase(this.repository);

  Future<void> call(String id, bool isArchived) async {
    return await repository.toggleEmployeeArchive(id, isArchived);
  }
}
