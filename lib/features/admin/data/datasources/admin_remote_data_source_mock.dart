// import '../models/employee_model.dart';
// import '../models/workshop_model.dart';
// import 'admin_remote_data_source.dart';
//
// class AdminRemoteDataSourceMock implements AdminRemoteDataSource {
//   final List<EmployeeModel> _mockEmployees = [
//     EmployeeModel(
//       id: '1', name: 'أحمد محمد علي', phoneNumber: '0933112233', image: '', isOnline: true, workshop: 'ورشة النجارة',
//       dailyHours: {'السبت': 8.0, 'الأحد': 7.5, 'الاثنين': 8.0}, hourlyRate: 3500.0, overtimeRate: 5000.0,
//       weeklyHistoryJson: [
//         {'week_number': 1, 'is_paid': true, 'workshops': [{'name': 'ورشة النجارة', 'reg_hours': 40.0, 'ot_hours': 5.0}]},
//         {'week_number': 2, 'is_paid': false, 'workshops': [{'name': 'ورشة النجارة', 'reg_hours': 35.0, 'ot_hours': 2.0}, {'name': 'ورشة الدهان', 'reg_hours': 10.0, 'ot_hours': 0.0}]}
//       ], password: '',
//     ),
//     EmployeeModel(
//       id: '2', name: 'سارة أحمد محمود', phoneNumber: '0944556677', image: '', isOnline: true, workshop: 'ورشة الخياطة',
//       dailyHours: {'السبت': 6.0, 'الأحد': 8.0}, hourlyRate: 4000.0, overtimeRate: 6000.0,
//       weeklyHistoryJson: [{'week_number': 1, 'is_paid': false, 'workshops': [{'name': 'ورشة الخياطة', 'reg_hours': 45.0, 'ot_hours': 10.0}]}], password: '',
//     ),
//     EmployeeModel(
//       id: '3', name: 'خالد وليد الحسين', phoneNumber: '0955112244', image: '', isOnline: false, workshop: 'المستودع المركزي',
//       dailyHours: {'السبت': 8.0, 'الأحد': 8.0}, hourlyRate: 3000.0, overtimeRate: 4500.0,
//       weeklyHistoryJson: [{'week_number': 1, 'is_paid': true, 'workshops': [{'name': 'المستودع المركزي', 'reg_hours': 40.0, 'ot_hours': 0.0}]}], password: '',
//     ),
//   ];
//
//   final List<WorkshopModel> _mockWorkshops = [
//     WorkshopModel(id: '1', name: 'ورشة النجارة', employeeCount: 12),
//     WorkshopModel(id: '2', name: 'ورشة الخياطة', employeeCount: 8),
//     WorkshopModel(id: '3', name: 'المستودع المركزي', employeeCount: 5),
//     WorkshopModel(id: '4', name: 'ورشة الدهان', employeeCount: 6),
//   ];
//
//   @override
//   Future<List<EmployeeModel>> getOnlineEmployees() async {
//     await Future.delayed(const Duration(milliseconds: 400));
//     return _mockEmployees.where((e) => e.isOnline == true).toList();
//   }
//
//   @override
//   Future<List<EmployeeModel>> getAllEmployees() async {
//     await Future.delayed(const Duration(milliseconds: 400));
//     return _mockEmployees;
//   }
//
//   @override
//   Future<EmployeeModel> getEmployeeDetails(String id) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     return _mockEmployees.firstWhere((e) => e.id == id);
//   }
//
//   @override
//   Future<void> updateHourlyRate(String id, double rate) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//   }
//
//   @override
//   Future<void> updateOvertimeRate(String id, double rate) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//   }
//
//   @override
//   Future<void> confirmPayment(String id, int weekNumber) async {
//     await Future.delayed(const Duration(milliseconds: 800));
//     final index = _mockEmployees.indexWhere((e) => e.id == id);
//     if (index != -1) {
//       final List<Map<String, dynamic>> history =
//           List<Map<String, dynamic>>.from(_mockEmployees[index].weeklyHistoryJson ?? []);
//       for (var i = 0; i < history.length; i++) {
//         if (history[i]['week_number'] == weekNumber) {
//           history[i]['is_paid'] = true;
//         }
//       }
//       _mockEmployees[index] = _mockEmployees[index].copyWith(weeklyHistoryJson: history);
//     }
//   }
//
//   @override
//   Future<void> addEmployee(EmployeeModel employee) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     _mockEmployees.add(employee);
//   }
//
//   @override
//   Future<void> deleteEmployee(String id) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     _mockEmployees.removeWhere((e) => e.id == id);
//   }
//
//   @override
//   Future<void> toggleEmployeeArchive(String id, bool isArchived) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     final index = _mockEmployees.indexWhere((e) => e.id == id);
//     if (index != -1) {
//       _mockEmployees[index] = _mockEmployees[index].copyWith(isArchived: isArchived);
//     }
//   }
//
//   @override
//   Future<void> updateEmployee(EmployeeModel employee) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     final index = _mockEmployees.indexWhere((e) => e.id == employee.id);
//     if (index != -1) {
//       _mockEmployees[index] = employee;
//     }
//   }
//
//   @override
//   Future<List<WorkshopModel>> getWorkshops() async {
//     await Future.delayed(const Duration(milliseconds: 400));
//     return _mockWorkshops;
//   }
//
//   @override
//   Future<void> addWorkshop({
//     required String name,
//     double? latitude,
//     double? longitude,
//     double radius = 200,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     _mockWorkshops.add(WorkshopModel(
//       id: DateTime.now().toString(),
//       name: name,
//       latitude: latitude,
//       longitude: longitude,
//       radiusInMeters: radius,
//       employeeCount: 0,
//     ));
//   }
//
//   @override
//   Future<void> deleteWorkshop(String id) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     _mockWorkshops.removeWhere((w) => w.id == id);
//   }
//
//   @override
//   Future<void> toggleWorkshopArchive(String id, bool isArchived) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     final index = _mockWorkshops.indexWhere((w) => w.id == id);
//     if (index != -1) {
//       _mockWorkshops[index] = _mockWorkshops[index].copyWith(isArchived: isArchived);
//     }
//   }
// }
//
// extension on EmployeeModel {
//   EmployeeModel copyWith({List<Map<String, dynamic>>? weeklyHistoryJson, bool? isArchived}) {
//     return EmployeeModel(
//       id: id, name: name, phoneNumber: phoneNumber, image: image,
//       isOnline: isOnline, workshop: workshop, dailyHours: dailyHours,
//       weeklyOvertime: weeklyOvertime, hourlyRate: hourlyRate,
//       overtimeRate: overtimeRate, location: location,
//       weeklyHistoryJson: weeklyHistoryJson ?? this.weeklyHistoryJson,
//       isArchived: isArchived ?? this.isArchived, password:password,
//     );
//   }
// }
