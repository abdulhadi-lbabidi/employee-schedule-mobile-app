import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/typedef.dart';
import 'package:untitled8/core/unified_api/use_case.dart';
import '../../data/models/employee model/employee_model.dart';
import '../repositories/admin_repository.dart';

@lazySingleton
class AddEmployeeUseCase {
  final AdminRepository repository;

  AddEmployeeUseCase(this.repository);

  DataResponse<void> call(AddEmployeeParams employee) async {
    return repository.addEmployee(employee);
  }
}

class AddEmployeeParams with Params {
  final String fullName;
  final String phone_number;
  final String email;
  final String password;
  final String position;
  final String department;
  final String current_location;
  final double hourly_rate;
  final double overtime_rate;

  AddEmployeeParams({
    required this.fullName,
    required this.phone_number,
    required this.email,
    required this.password,
    required this.position,
    required this.department,
    required this.current_location,
    required this.hourly_rate,
    required this.overtime_rate,
  });

  @override
  BodyMap getBody() {
    // TODO: implement getBody
    return {
      'full_name': fullName,
      'phone_number': phone_number,
      'email': email,
      'password': password,
      'position': position,
      'department': department,
      'hourly_rate': hourly_rate,
      'overtime_rate': overtime_rate,
      'current_location': current_location,
    };
  }
}
