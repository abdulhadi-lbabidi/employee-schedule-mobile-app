import 'package:untitled8/common/helper/src/app_varibles.dart';

class ApiVariables {
  static const String _scheme = 'https';
  static const String _host = 'employee-api.nouh-agency.com';
  static const int? _port = null;

  static Uri _mainUri(String path, {Map<String, String>? params}) {
    return Uri(
      scheme: _scheme,
      host: _host,
      port: _port,
      path: path,
      queryParameters: params,
    );
  }

  // --- Auth ---
  static Uri login() => _mainUri('/api/login');

  static Uri logout() => _mainUri('/api/logout');

  static Uri updatePassword() => _mainUri('/api/update-password');

  static Uri register() => _mainUri('/api/auth/register');

  static Uri verifyToken() => _mainUri('/api/auth/verify');

  // --- Profile ---
  static Uri getProfile() => _mainUri('/api/me');

  static Uri updateProfile() => _mainUri('/api/update-profile');

  static Uri uploadAvatar() => _mainUri('/api/profile/upload-avatar');

  // --- Admin: Dashboard & Stats ---
  static Uri dashboardStats() => _mainUri('/api/admin/dashboard/stats');

  static Uri financialReport() => _mainUri('/api/admin/finance/report');

  // --- Admin: Employees ---
  static Uri getEmployeesStatus() => _mainUri('/api/admin/employees/is_online');

  static Uri employees() => _mainUri('/api/employees');

  static Uri addEmployee() => _mainUri('/api/employees');

  static Uri employeeUpdate(String id) => _mainUri('/api/employees/$id');

  static Uri employeeDetails(String id) => _mainUri('/api/employees/$id');

  static Uri archiveGetEmployees() => _mainUri('/api/employees-archived');

  static Uri archiveRestoreAllEmployees() =>
      _mainUri('/api/employees-archived/restore');

  static Uri archiveEmployee(String id) => _mainUri('/api/employees/$id');

  static Uri archiveRestoreEmployee(String id) =>
      _mainUri('/api/employees/$id/restore');

  static Uri archiveDeleteEmployee(String id) => _mainUri('/api/employees/$id');

  static Uri archiveDeleteEmployees() => _mainUri('/api/employees-archived');

  static Uri updateEmployeeArchive(String id) =>
      _mainUri('/api/employees/$id/archive');

  static Uri updateHourlyRate(String id) =>
      _mainUri('/api/employees/$id/hourly_rate');

  static Uri updateEmployee(String id) => _mainUri('/api/employees/$id');

  // --- Admin: Workshops ---
  static Uri workshops() => _mainUri('/api/workshops/');

  static Uri addWorkshop() => _mainUri('/api/workshops');

  static Uri updateWorkshop(String id) => _mainUri('/api/workshops/$id');

  static Uri workshopDelete(String id) => _mainUri('/api/workshops/$id');

  static Uri workshopDetails(int id) => _mainUri('/api/workshops/$id');

  static Uri archiveWorkshop(String id) => _mainUri('/api/workshops/$id');

  static Uri archiveGetWorkshops() => _mainUri('/api/workshops-archived');

  static Uri archiveRestoreWorkshop(String id) =>
      _mainUri('/api/workshops/$id/restore');

  static Uri workshopEmployees(String id) =>
      _mainUri('/api/admin/workshops/$id/employees');

  // --- Attendance ---
  static Uri getAttendances({Map<String, String>? params}) => _mainUri(
    '/api/my-attendance/${AppVariables.user!.id}',
    params: params,
  ); // تم التعديل هنا
  static Uri postAttendance() => _mainUri('/api/attendances/sync');

  static Uri syncAttendance() => _mainUri('/api/attendances/sync');

  // --- Loans ---
  static Uri adminLoans() => _mainUri('/api/loans');

  static Uri employeeLoans(int empId) => _mainUri('/api/loans/$empId');

  static Uri updateLoanStatus(int loanId) => _mainUri('/api/loans/$loanId');

  static Uri archiveLoans(int loanId) => _mainUri('/api/loans/$loanId');

  static Uri archiveRestoreLoans(String loanId) =>
      _mainUri('/api/loans/$loanId/restore');

  static Uri archiveDeleteLoans(String loanId) =>
      _mainUri('/api/loans/$loanId');

  static Uri getarchiveAllLoans() => _mainUri('/api/loans-archived');

  static Uri recordPayment(String loanId) =>
      _mainUri('/api/admin/loans/$loanId/payments');

  static Uri addLoan() => _mainUri('/api/loans');

  // دالتان إضافيتان مطلوبة من قبل الـ DataSource
  static Uri loanStatus(int id) => _mainUri('/api/loans/$id/status');

  static Uri loanPayments(int id) => _mainUri('/api/loans/$id/payments');

  // --- Rewards ---
  static Uri adminRewards() => _mainUri('/api/rewards/admin');

  static Uri employeeRewards(String empId) =>
      _mainUri('/api/rewards/employee/$empId');

  static Uri issueReward() => _mainUri('/api/rewards/issue');

  // --- Notifications ---
  static Uri notifications() => _mainUri('/api/notifications');

  static Uri sendNotification() => _mainUri('/api/notifications/send');

  static Uri deleteNotification(String id) =>
      _mainUri('/api/notifications/$id');
}
