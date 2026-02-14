import 'package:injectable/injectable.dart';
import 'package:untitled8/features/admin/domain/repositories/employee_repository.dart';

@injectable
class UpdateEmployeeFullDetailsUseCase {
  final EmployeeRepository repository;

  UpdateEmployeeFullDetailsUseCase(this.repository);

  Future<void> call(UpdateEmployeeFullDetailsParams params) async {
    await repository.updateEmployeeFullDetails(
      employeeId: params.employeeId,
      name: params.name,
      phoneNumber: params.phoneNumber,
      email: params.email,
      password: params.password,
      position: params.position,
      department: params.department,
      workshop: params.workshop,
      hourlyRate: params.hourlyRate,
      overtimeRate: params.overtimeRate,
      currentLocation: params.currentLocation,
    );
  }
}

class UpdateEmployeeFullDetailsParams {
  final String employeeId;
  final String name;
  final String phoneNumber;
  final String? email;
  final String? password;
  final String? position;
  final String? department;
  final String workshop;
  final double hourlyRate;
  final double overtimeRate;
  final String? currentLocation;

  UpdateEmployeeFullDetailsParams({
    required this.employeeId,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.password,
    this.position,
    this.department,
    required this.workshop,
    required this.hourlyRate,
    required this.overtimeRate,
    this.currentLocation,
  });
}
