import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/typedef.dart';
import '../../data/models/employee model/employee_model.dart';
import '../repositories/admin_repository.dart';

@lazySingleton
class GetAllEmployeesUseCase {
  final AdminRepository adminRepository;

  GetAllEmployeesUseCase(this.adminRepository);

  DataResponse<GetAllEmployeeResponse> call() {
    return adminRepository.getAllEmployees();
  }
}