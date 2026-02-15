import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/core/unified_api/base_api.dart';
import 'package:untitled8/core/unified_api/handling_api_manager.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/get_employee_response.dart';
import '../../../../core/unified_api/api_variables.dart';

import '../../domain/entities/employee_entity.dart';
import '../../domain/entities/workshop_entity.dart';
import '../../domain/usecases/add_employee.dart';
import '../models/employee model/employee_model.dart';
import '../models/workshop_model.dart';
import 'admin_remote_data_source.dart';

@lazySingleton
class AdminRemoteDataSourceImpl with HandlingApiManager {
  final BaseApi _baseApi;

  AdminRemoteDataSourceImpl({required BaseApi baseApi}) : _baseApi = baseApi;

  Future<GetAllEmployeeResponse> getOnlineEmployees() async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.get(ApiVariables.employees()),
      jsonConvert: getAllEmployeeResponseFromJson,
    );
  }

  Future<GetAllEmployeeResponse> getAllEmployees() async => wrapHandlingApi(
    tryCall: () => _baseApi.get(ApiVariables.employees()),
    jsonConvert: getAllEmployeeResponseFromJson,
  );

  Future<GetEmployeeResponse> getEmployeeDetails(String id) async =>
      wrapHandlingApi(
        tryCall: () => _baseApi.get(ApiVariables.employeeDetails(id)),
        jsonConvert: getEmployeeResponseFromJson,
      );

  Future<void> updateHourlyRate(String id, double rate) async {
    return wrapHandlingApi(
      tryCall:
          () => _baseApi.put(
            ApiVariables.updateHourlyRate(id),
            data: {'hourly_rate': rate},
          ),
      jsonConvert: (_) {},
    );
  }

  Future<void> updateOvertimeRate(String id, double rate) async {
    return wrapHandlingApi(
      tryCall:
          () => _baseApi.put(
            ApiVariables.employeeUpdate(id),
            data: {'overtime_rate': rate},
          ),

      jsonConvert: (_) {},
    );
  }

  Future<void> confirmPayment(String id, int weekNumber) async {
    return wrapHandlingApi(
      tryCall:
          () => _baseApi.post(
            ApiVariables.employeeUpdate(id),
            data: {'week_number': weekNumber},
          ),

      jsonConvert: (_) {},
    );
  }

  Future<void> addEmployee(AddEmployeeParams employee) async {
    return wrapHandlingApi(
      tryCall:
          () => _baseApi.post(
            ApiVariables.addEmployee(),
            data: employee.getBody(),
          ),

      jsonConvert: (_) {},
    );
  }

  Future<void> deleteEmployee(String id) async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.delete(ApiVariables.employeeDelete(id)),

      jsonConvert: (_) {},
    );
  }

  Future<void> toggleEmployeeArchive(String id, bool isArchived) async {

    return wrapHandlingApi(
      tryCall: () => _baseApi.put(
        ApiVariables.archiveEmployee(id),
        data: {'is_archived': isArchived},
      ),

      jsonConvert: (_) {},
    );
  }

  Future<void> updateEmployee(EmployeeModel employee) async {

    return wrapHandlingApi(
      tryCall: () =>  _baseApi.put(
        ApiVariables.employeeDetails(employee.id.toString()),
        data: {
          'hourly_rate': employee.hourlyRate ?? 0,
          'overtime_rate': employee.overtimeRate ?? 0,
        },
      ),

      jsonConvert: (_) {},
    );

  }

  // 🔹 إضافة دالة تحديث بيانات الموظف الكاملة
  Future<void> updateEmployeeFullDetails({
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
  }) async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.put(
        ApiVariables.employeeUpdate(employeeId), //  استخدام نقطة نهاية التحديث
        data: {
          'full_name': name,
          'phone_number': phoneNumber,
          'email': email,
          'password': password,
          'position': position,
          'department': department,
          'hourly_rate': hourlyRate,
          'overtime_rate': overtimeRate,
          'current_location': currentLocation,
        },
      ),
      jsonConvert: (_) {},
    );
  }

  Future<List<WorkshopEntity>> getWorkshops() async {
    final response = await _baseApi.get(ApiVariables.workshops());

    if (response.statusCode == 200) {
      if (response.data is List) {
        final list = response.data as List;
        return list
            .map((e) => WorkshopEntity.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        final list = data['data'] as List? ?? [];
        return list
            .map((e) => WorkshopEntity.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    throw Exception('Failed to load workshops: ${response.statusCode}');
  }

  Future<void> addWorkshop({
    required String name,
    double? latitude,
    double? longitude,
    double radius = 200,
  }) async {
    final response = await _baseApi.post(
      ApiVariables.addWorkshop(),
      data: {
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      },
    );

    if (response.statusCode! >= 400) {
      throw Exception('Failed to add workshop: ${response.statusCode}');
    }
  }

  Future<void> deleteWorkshop(int id) async {
    final response = await _baseApi.delete(ApiVariables.workshopDetails(id));

    if (response.statusCode! >= 400) {
      throw Exception('Failed to delete workshop: ${response.statusCode}');
    }
  }

  Future<void> toggleWorkshopArchive(String id, bool isArchived) async {
    final response = await _baseApi.put(
      ApiVariables.archiveWorkshop(id),
      data: {'is_archived': isArchived},
    );

    if (response.statusCode! >= 400) {
      throw Exception(
        'Failed to toggle workshop archive: ${response.statusCode}',
      );
    }
  }
}
