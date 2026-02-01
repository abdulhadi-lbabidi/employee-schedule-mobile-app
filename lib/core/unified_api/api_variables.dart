class ApiVariables {
  static const String _scheme = 'https';
  static const String _host = 'employee-api.nouh-agency.com';
  static const int? _port = null;

  Uri _mainUri(String path, {Map<String, String>? params}) {
    return Uri(
      scheme: _scheme,
      host: _host,
      port: _port,
      path: path,
      queryParameters: params,
    );
  }

  // --- Auth ---
  Uri login() => _mainUri('/api/login');



  Uri logout() => _mainUri('/api/logout');
  Uri updatePassword() => _mainUri('/api/update-password');
  Uri register() => _mainUri('/api/auth/register');
  Uri verifyToken() => _mainUri('/api/auth/verify');

  // --- Profile ---
  Uri getProfile() => _mainUri('/api/me');
  Uri updateProfile() => _mainUri('/api/update-profile');
  Uri uploadAvatar() => _mainUri('/api/profile/upload-avatar');

  // --- Admin: Dashboard & Stats ---
  Uri dashboardStats() => _mainUri('/api/admin/dashboard/stats');
  Uri financialReport() => _mainUri('/api/admin/finance/report');

  // --- Admin: Employees ---
  Uri getEmployeesStatus() => _mainUri('/api/admin/employees/is_online');
  Uri employees() => _mainUri('/api/employees');
  Uri addEmployee() => _mainUri('/api/employees');
  Uri employeeUpdate(String id) => _mainUri('/api/employees/$id');
  Uri employeeDetails(String id) => _mainUri('/api/employees/$id');
  Uri archiveGetEmployees() => _mainUri('/api/employees-archived');
  Uri archiveRestoreAllEmployees() => _mainUri('/api/employees-archived/restore');
  Uri archiveEmployee(String id) => _mainUri('/api/employees/$id');
  Uri archiveRestoreEmployee(String id) => _mainUri('/api/employees/$id/restore');
  Uri archiveDeleteEmployee(String id) => _mainUri('/api/employees/$id');
  Uri archiveDeleteEmployees() => _mainUri('/api/employees-archived');
  Uri updateEmployeeArchive(String id) => _mainUri('/api/employees/$id/archive');
  Uri updateHourlyRate(String id) => _mainUri('/api/employees/$id/hourly_rate');
  Uri updateEmployee(String id) => _mainUri('/api/employees/$id');


  // --- Admin: Workshops ---
  Uri workshops() => _mainUri('/api/workshops/');
  Uri addWorkshop() => _mainUri('/api/workshops');
  Uri updateWorkshop(String id) => _mainUri('/api/workshops/$id');
  Uri workshopDelete(String id) => _mainUri('/api/workshops/$id');
  Uri workshopDetails(String id) => _mainUri('/api/workshops/$id');
  Uri archiveWorkshop(String id) => _mainUri('/api/workshops/$id');
  Uri archiveGetWorkshops() => _mainUri('/api/workshops-archived');
  Uri archiveRestoreWorkshop(String id) => _mainUri('/api/workshops/$id/restore');
  Uri workshopEmployees(String id) => _mainUri('/api/admin/workshops/$id/employees');

  // --- Attendance ---
  Uri getAttendances({Map<String, String>? params}) => _mainUri('/api/attendances', params: params); // تم التعديل هنا
  Uri postAttendance() => _mainUri('/api/attendances/sync');
  Uri syncAttendance() => _mainUri('/api/attendances/sync');

  // --- Loans ---
  Uri adminLoans() => _mainUri('/api/loans');
  Uri employeeLoans(String empId) => _mainUri('/api/loans/$empId');
  Uri updateLoanStatus(String loanId) => _mainUri('/api/loans/$loanId');
  Uri archiveLoans(String loanId) => _mainUri('/api/loans/$loanId');
  Uri archiveRestoreLoans(String loanId) => _mainUri('/api/loans/$loanId/restore');
  Uri archiveDeleteLoans(String loanId) => _mainUri('/api/loans/$loanId');
  Uri getarchiveAllLoans() => _mainUri('/api/loans-archived');
  Uri recordPayment(String loanId) => _mainUri('/api/admin/loans/$loanId/payments');
  Uri addLoan() => _mainUri('/api/loans');
  
  // دالتان إضافيتان مطلوبة من قبل الـ DataSource
  Uri loanStatus(String id) => _mainUri('/api/loans/$id/status');
  Uri loanPayments(String id) => _mainUri('/api/loans/$id/payments');

  // --- Rewards ---
  Uri adminRewards() => _mainUri('/api/rewards/admin');
  Uri employeeRewards(String empId) => _mainUri('/api/rewards/employee/$empId');
  Uri issueReward() => _mainUri('/api/rewards/issue');

  // --- Notifications ---
  Uri notifications() => _mainUri('/api/notifications');
  Uri sendNotification() => _mainUri('/api/notifications/send');
  Uri deleteNotification(String id) => _mainUri('/api/notifications/$id');
}
