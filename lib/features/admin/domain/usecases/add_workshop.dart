import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/typedef.dart';
import 'package:untitled8/core/unified_api/use_case.dart';
import '../repositories/workshop_repository.dart';
@lazySingleton
class AddWorkshopUseCase {
  final WorkshopRepository repository;

  AddWorkshopUseCase(this.repository);

  DataResponse<void> call(
    AddWorkshopParams params
  ) async {

    return repository.addWorkshop(params
    );
  }
}

class AddWorkshopParams with Params{
  final String? name;
  final double? latitude;
  final double? longitude;
  final double? radius ;
  final String? city ;
  final String? description;

  AddWorkshopParams({required this.name, required this.latitude, required this.longitude, required this.radius, required this.city, required this.description});
@override
  BodyMap getBody() {
    // TODO: implement getBody
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'radiusInMeters': radius,
      'location':city,
      'description':description
    };
  }

}