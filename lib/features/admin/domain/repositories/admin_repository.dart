import 'package:untitled8/common/helper/src/typedef.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/get_employee_response.dart';
import '../../data/models/employee model/get_employee_details_hours_details_response.dart';
import '../../data/models/get_dashboard_data.dart';
import '../../data/models/workshop_models/get_all_workshop_response.dart';
import '../usecases/add_employee.dart';

abstract class AdminRepository {
  DataResponse<GetAllEmployeeResponse> getOnlineEmployees();
  DataResponse<GetDashboardData> getDashbordData();
  DataResponse<GetAllEmployeeResponse> getAllEmployees();
  DataResponse<GetAllEmployeeResponse> getAllArchiveEmployees();

  DataResponse<void> updateHourlyRate({required String employeeId, required double newRate});
  DataResponse<void> updateOvertimeRate({required String employeeId, required double newRate});
  DataResponse<void> confirmPayment({required String employeeId, required int weekNumber});
  DataResponse<void> addEmployee(AddEmployeeParams employee);
  DataResponse<GetEmployeeResponse> getEmployeeDetails(String id);
  DataResponse<GetEmployeeDetailsHoursResponse> getEmployeeDetailsHoursDetails(String id);
  DataResponse<void> deleteEmployee(String id);
  DataResponse<void> toggleEmployeeArchive(String id); // 🔹 أرشفة الموظف
  DataResponse<void> restoreEmployeeArchive(String id); // 🔹 أرشفة الموظف

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


}
