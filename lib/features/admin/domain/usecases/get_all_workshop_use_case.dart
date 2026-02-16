import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/typedef.dart';
import '../../data/models/workshop_models/get_all_workshop_response.dart';
import '../repositories/workshop_repository.dart'; // ✅ استخدام الـ Repository الجديد

@lazySingleton
class GetAllWorkshopUseCase {
  final WorkshopRepository repository;

  GetAllWorkshopUseCase({required this.repository}); // ✅ استخدام الـ Repository الجديد


 DataResponse<GetAllWorkshopsResponse> call() async {
    return repository.getWorkshops();
  }
}
