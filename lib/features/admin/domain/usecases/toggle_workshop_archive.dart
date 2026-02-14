import 'package:untitled8/common/helper/src/typedef.dart';

import '../repositories/admin_repository.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class ToggleWorkshopArchiveUseCase {
  final AdminRepository repository;

  ToggleWorkshopArchiveUseCase(this.repository);

  DataResponse<void> call(String id, bool isArchived) async {
    return await repository.toggleWorkshopArchive(id, isArchived);
  }
}
