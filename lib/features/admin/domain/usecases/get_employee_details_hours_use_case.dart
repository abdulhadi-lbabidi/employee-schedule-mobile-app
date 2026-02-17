import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/typedef.dart';
import '../../data/models/employee model/get_employee_details_hours_details_response.dart';
import '../repositories/admin_repository.dart';
@lazySingleton
class GetEmployeeDetailsHoursUseCase {
  final AdminRepository repository;

  GetEmployeeDetailsHoursUseCase(this.repository);

  DataResponse<GetEmployeeDetailsHoursResponse> call(String employeeId) {
    return repository.getEmployeeDetailsHoursDetails(employeeId);
  }
}
