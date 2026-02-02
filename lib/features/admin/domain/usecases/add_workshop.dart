import '../repositories/admin_repository.dart';

class AddWorkshopUseCase {
  final AdminRepository repository;

  AddWorkshopUseCase(this.repository);

  Future<void> call({
    required String name,
    required String location,
    required String description,
    double? latitude,
    double? longitude,
    double radius = 200,
  }) async {
    return repository.addWorkshop(
      name: name,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      location: location,
      description: description,
    );
  }
}
