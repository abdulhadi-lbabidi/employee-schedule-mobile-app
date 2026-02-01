import '../entities/employee_entity.dart';
import '../entities/workshop_entity.dart';

abstract class AdminRepository {
  Future<List<EmployeeEntity>> getOnlineEmployees();
  Future<List<EmployeeEntity>> getAllEmployees();

  Future<void> updateHourlyRate({required String employeeId, required double newRate});
  Future<void> updateOvertimeRate({required String employeeId, required double newRate});
  Future<void> confirmPayment({required String employeeId, required int weekNumber});
  Future<void> addEmployee(EmployeeEntity employee);
  Future<EmployeeEntity> getEmployeeDetails(String id);
  Future<void> deleteEmployee(String id);
  Future<void> toggleEmployeeArchive(String id, bool isArchived); // 🔹 أرشفة الموظف
  
  // 🔹 إدارة الورشات
  Future<List<WorkshopEntity>> getWorkshops();
  Future<void> addWorkshop({
    required String name,
    double? latitude,
    double? longitude,
    double radius = 200,
  });
  Future<void> deleteWorkshop(String id);
  Future<void> toggleWorkshopArchive(String id, bool isArchived);
}
