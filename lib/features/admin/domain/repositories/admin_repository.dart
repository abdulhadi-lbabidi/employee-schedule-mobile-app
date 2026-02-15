import 'package:untitled8/common/helper/src/typedef.dart';

import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/get_employee_response.dart';
import '../entities/workshop_entity.dart';
import '../usecases/add_employee.dart';

abstract class AdminRepository {
  DataResponse<GetAllEmployeeResponse> getOnlineEmployees();
  DataResponse<GetAllEmployeeResponse> getAllEmployees();

  DataResponse<void> updateHourlyRate({required String employeeId, required double newRate});
  DataResponse<void> updateOvertimeRate({required String employeeId, required double newRate});
  DataResponse<void> confirmPayment({required String employeeId, required int weekNumber});
  DataResponse<void> addEmployee(AddEmployeeParams employee);
  DataResponse<GetEmployeeResponse> getEmployeeDetails(String id);
  DataResponse<void> deleteEmployee(String id);
  DataResponse<void> toggleEmployeeArchive(String id, bool isArchived); // 🔹 أرشفة الموظف

  //  إضافة دالة تحديث بيانات الموظف الكاملة
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
  });
  
  // 🔹 إدارة الورشات
  DataResponse<List<WorkshopEntity>> getWorkshops();
  DataResponse<void> addWorkshop({
    required String name,
    double? latitude,
    double? longitude,
    double radius = 200,
  });
  DataResponse<void> deleteWorkshop(int id);
  DataResponse<void> toggleWorkshopArchive(String id, bool isArchived);
}
