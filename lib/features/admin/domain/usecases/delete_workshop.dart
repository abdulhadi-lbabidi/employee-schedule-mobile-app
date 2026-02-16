import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/typedef.dart';
import '../repositories/workshop_repository.dart';
@lazySingleton
class DeleteWorkshopUseCase {
  final WorkshopRepository repository;

  DeleteWorkshopUseCase(this.repository);

  DataResponse<void> call(int id) async {
    return repository.deleteWorkshop(id);
  }
}
