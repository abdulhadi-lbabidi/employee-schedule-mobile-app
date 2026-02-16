import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';


abstract class AdminDashboardState {}

class DashboardInitial extends AdminDashboardState {}

class DashboardLoading extends AdminDashboardState {}

class DashboardLoaded extends AdminDashboardState {
  final List<EmployeeModel> onlineEmployees;
  final List<EmployeeModel> offlineEmployees;
  
  // 🔹 إضافة حقول الإحصائيات البيانية
  final Map<String, double> workshopExpenses; // لتوزيع المصاريف
  final Map<String, int> weeklyAttendance;    // لنمو الحضور
  final double totalOperationalCost;          // التكلفة التشغيلية

  DashboardLoaded({
    required this.onlineEmployees,
    required this.offlineEmployees,
    this.workshopExpenses = const {},
    this.weeklyAttendance = const {},
    this.totalOperationalCost = 0.0,
  });
}

class DashboardError extends AdminDashboardState {
  final String message;
  DashboardError(this.message);
}
