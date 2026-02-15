import 'package:injectable/injectable.dart';

import '../repositories/admin_repository.dart';

@injectable
class UpdateEmployeeFullDetailsUseCase {
  final AdminRepository repository;

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
    required this.hourlyRate,
    required this.overtimeRate,
    this.currentLocation,
  });
}
