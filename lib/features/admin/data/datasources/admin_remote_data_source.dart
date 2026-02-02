import '../models/employee model/employee_model.dart';

import '../models/workshop_model.dart';

abstract class AdminRemoteDataSource {
  // Employees
  Future<List<Datum>> getAllEmployees();
  Future<List<Datum>> getOnlineEmployees();
  Future<Datum> getEmployeeDetails(String id);

  Future<void> addEmployee(Datum model);
  Future<void> updateEmployee(Datum model);
  Future<void> deleteEmployee(String id);
  Future<void> toggleEmployeeArchive(String id, bool isArchived);

  // Workshops
  Future<List<WorkshopModel>> getWorkshops();
  Future<void> addWorkshop({
    required String name,
    required String location,
    required String description,
    double? latitude,
    double? longitude,
    double radius,
  });
  Future<void> deleteWorkshop(String id);
  Future<void> toggleWorkshopArchive(String id, bool isArchived);

  // Rates
  Future<void> updateHourlyRate(String id, double rate);
  Future<void> updateOvertimeRate(String id, double rate);
  Future<void> confirmPayment(String id, int weekNumber);
}
