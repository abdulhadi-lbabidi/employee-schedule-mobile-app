import 'package:untitled8/common/helper/src/typedef.dart';
import 'package:injectable/injectable.dart';

import '../repositories/workshop_repository.dart';
@lazySingleton
class RestoreWorkshopUseCase {
  final WorkshopRepository repository;

  RestoreWorkshopUseCase(this.repository);

  DataResponse<void> call(String id) async {
    return await repository.restoreArchivedWorkShop(id);
  }
}
