import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/typedef.dart';

import '../repositories/admin_repository.dart';
@lazySingleton
class AddWorkshopUseCase {
  final AdminRepository repository;

  AddWorkshopUseCase(this.repository);

  DataResponse<void> call({
    required String name,
    double? latitude,
    double? longitude,
    double radius = 200,
  }) async {
    return repository.addWorkshop(
      name: name,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );
  }
}
