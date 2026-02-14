import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/typedef.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/get_employee_response.dart';
import '../repositories/admin_repository.dart';
@lazySingleton
class GetEmployeeDetailsUseCase {
  final AdminRepository repository;

  GetEmployeeDetailsUseCase(this.repository);

  DataResponse<GetEmployeeResponse> call(String employeeId) {
    return repository.getEmployeeDetails(employeeId);
  }
}
