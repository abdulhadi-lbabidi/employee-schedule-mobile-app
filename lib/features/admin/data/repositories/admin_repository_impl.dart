import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/typedef.dart';
import 'package:untitled8/core/unified_api/error_handler.dart';
import 'package:untitled8/features/admin/data/datasources/admin_remote_data_source_impl.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/get_employee_response.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/entities/workshop_entity.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../domain/usecases/add_employee.dart';
import '../datasources/admin_remote_data_source.dart';
import '../mappers/employee_mapper.dart';
import '../mappers/employee_to_datum_mapper.dart';
import '../mappers/workshop_mapper.dart';
import '../models/employee model/employee_model.dart';

@LazySingleton(as: AdminRepository)
class AdminRepositoryImpl with HandlingException implements AdminRepository {
  final AdminRemoteDataSourceImpl remote;

  AdminRepositoryImpl(this.remote);

  @override
  DataResponse<void> addEmployee(AddEmployeeParams employee) async =>
      wrapHandlingException(tryCall: () => remote.addEmployee(employee));

  @override
  DataResponse<void> addWorkshop({
    required String name,
    double? latitude,
    double? longitude,
    double radius = 200,
  }) async=> wrapHandlingException(tryCall: () => remote.addWorkshop(name: name));

  @override
  DataResponse<void> confirmPayment({
    required String employeeId,
    required int weekNumber,
  }) async=> wrapHandlingException(
    tryCall: () => remote.confirmPayment(employeeId, weekNumber),
  );

  @override
  DataResponse<void> deleteEmployee(String id)async => wrapHandlingException(
    tryCall: () => remote.deleteEmployee(id),
  );
  @override
  DataResponse<void> deleteWorkshop(int id) async=>
      wrapHandlingException(tryCall: () => remote.deleteWorkshop(id));

  @override
  DataResponse<GetAllEmployeeResponse> getAllEmployees()async =>
      wrapHandlingException(tryCall: () => remote.getAllEmployees());

  @override
  DataResponse<GetEmployeeResponse> getEmployeeDetails(String id) async=>
      wrapHandlingException(tryCall: () => remote.getEmployeeDetails(id));

  @override
  DataResponse<GetAllEmployeeResponse> getOnlineEmployees() async=>
      wrapHandlingException(tryCall: () => remote.getOnlineEmployees());

  @override
  DataResponse<List<WorkshopEntity>> getWorkshops()async =>
      wrapHandlingException(tryCall: () => remote.getWorkshops());


  @override
  DataResponse<void> toggleEmployeeArchive(String id, bool isArchived) async =>
      wrapHandlingException(tryCall: () => remote.toggleEmployeeArchive(id, isArchived));


  @override
  DataResponse<void> toggleWorkshopArchive(String id, bool isArchived)async =>
      wrapHandlingException(tryCall: () => remote.toggleWorkshopArchive(id, isArchived));

  @override
  DataResponse<void> updateHourlyRate({
    required String employeeId,
    required double newRate,
  }) async=>
      wrapHandlingException(tryCall: () => remote.updateHourlyRate(employeeId, newRate));


  @override
  DataResponse<void> updateOvertimeRate({
    required String employeeId,
    required double newRate,
  })  async=>
      wrapHandlingException(tryCall: () => remote.updateOvertimeRate(employeeId, newRate));

  @override
  DataResponse<void> updateEmployeeFullDetails({
    required String employeeId,
    required String name,
    required String phoneNumber,
    String? email,
    String? password,
    String? position,
    String? department,
    required double hourlyRate,
    required double overtimeRate,
    String? currentLocation,
  }) async => wrapHandlingException(
    tryCall: () => remote.updateEmployeeFullDetails(
      employeeId: employeeId,
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
      position: position,
      department: department,
      hourlyRate: hourlyRate,
      overtimeRate: overtimeRate,
      currentLocation: currentLocation,
    ),
  );

}
