import 'package:injectable/injectable.dart';
import 'package:untitled8/core/unified_api/base_api.dart';
import 'package:untitled8/core/unified_api/handling_api_manager.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/get_employee_response.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../../domain/usecases/add_employee.dart';
import '../models/employee model/employee_model.dart';
import '../models/employee model/get_employee_details_hours_details_response.dart';

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

  Future<GetAllEmployeeResponse> getAllArchiveEmployees() async => wrapHandlingApi(
    tryCall: () => _baseApi.get(ApiVariables.employeesArchived()),
    jsonConvert: getAllEmployeeResponseFromJson,
  );




  Future<GetEmployeeResponse> getEmployeeDetails(String id) async =>
      wrapHandlingApi(
        tryCall: () => _baseApi.get(ApiVariables.employeeDetails(id)),
        jsonConvert: getEmployeeResponseFromJson,
      );

  Future<GetEmployeeDetailsHoursResponse> getEmployeeDetailsHours(String id) async =>
      wrapHandlingApi(
        tryCall: () => _baseApi.get(ApiVariables.employeeDetailsHours(id)),
        jsonConvert: getEmployeeDetailsHoursResponseFromJson,
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

  Future<void> toggleEmployeeArchive(String id) async {
    return wrapHandlingApi(
      tryCall:
          () => _baseApi.delete(
            ApiVariables.archiveEmployee(id),
          ),

      jsonConvert: (_) {},
    );
  }

  Future<void> restoreEmployeeArchive(String id) async {
    return wrapHandlingApi(
      tryCall:
          () => _baseApi.post(
        ApiVariables.archiveEmployee(id),
      ),

      jsonConvert: (_) {},
    );
  }

  Future<void> updateEmployee(EmployeeModel employee) async {
    return wrapHandlingApi(
      tryCall:
          () => _baseApi.put(
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
      tryCall:
          () => _baseApi.put(
            ApiVariables.employeeUpdate(employeeId),
            //  استخدام نقطة نهاية التحديث
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

}
