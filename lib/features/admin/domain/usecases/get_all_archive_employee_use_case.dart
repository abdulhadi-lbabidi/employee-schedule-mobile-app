import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/typedef.dart';
import '../../data/models/employee model/employee_model.dart';
import '../repositories/admin_repository.dart';

@lazySingleton
class GetAllArchiveEmployeeUseCase {
  final AdminRepository adminRepository;

  GetAllArchiveEmployeeUseCase(this.adminRepository);

  DataResponse<GetAllEmployeeResponse> call() {
    return adminRepository.getAllArchiveEmployees();
  }
}