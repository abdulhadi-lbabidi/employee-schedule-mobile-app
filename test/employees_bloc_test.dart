// import 'package:flutter_test/flutter_test.dart';
// import 'package:untitled8/features/admin/presentation/bloc/employees/employees_bloc.dart';
// import 'package:untitled8/features/admin/presentation/bloc/employees/employees_event.dart';
// import 'package:untitled8/features/admin/presentation/bloc/employees/employees_state.dart';
// import 'package:untitled8/features/admin/domain/entities/employee_entity.dart';
// import 'package:untitled8/features/admin/domain/usecases/get_all_employees.dart';
// import 'package:untitled8/features/admin/domain/usecases/add_employee.dart';
// import 'package:untitled8/features/admin/domain/usecases/toggle_employee_archive.dart';
// import 'package:untitled8/features/admin/domain/repositories/admin_repository.dart';
// import 'package:untitled8/features/admin/domain/entities/workshop_entity.dart';
//
// // محاكاة المستودع للاختبار
// class MockAdminRepo implements AdminRepository {
//   List<EmployeeEntity> mockEmployees = [];
//
//   @override Future<List<EmployeeEntity>> getAllEmployees() async => mockEmployees;
//   @override Future<List<EmployeeEntity>> getOnlineEmployees() async => [];
//   @override Future<EmployeeEntity> getEmployeeDetails(String id) => throw UnimplementedError();
//   @override Future<void> addEmployee(EmployeeEntity employee) async => mockEmployees.add(employee);
//   @override Future<void> deleteEmployee(String id) async {}
//   @override Future<void> confirmPayment({required String employeeId, required int weekNumber}) async {}
//   @override Future<void> updateHourlyRate({required String employeeId, required double newRate}) async {}
//   @override Future<void> updateOvertimeRate({required String employeeId, required double newRate}) async {}
//   @override Future<void> toggleEmployeeArchive(String id, bool isArchived) async {}
//
//   @override Future<List<WorkshopEntity>> getWorkshops() async => [];
//
//   @override
//   Future<void> addWorkshop({
//     required String name,
//     double? latitude,
//     double? longitude,
//     double radius = 200,
//   }) async {}
//
//   @override Future<void> deleteWorkshop(String id) async {}
//   @override Future<void> toggleWorkshopArchive(String id, bool isArchived) async {}
// }
//
// void main() {
//   late EmployeesBloc bloc;
//   late MockAdminRepo mockRepo;
//
//   setUp(() {
//     mockRepo = MockAdminRepo();
//     bloc = EmployeesBloc(
//       getAllEmployeesUseCase: GetAllEmployeesUseCase(mockRepo),
//       addEmployeeUseCase: AddEmployeeUseCase(mockRepo),
//       toggleEmployeeArchiveUseCase: ToggleEmployeeArchiveUseCase(mockRepo),
//     );
//   });
//
//   tearDown(() {
//     bloc.close();
//   });
//
//   group('EmployeesBloc Unit Tests', () {
//     test('يجب أن يبدأ بـ EmployeesInitial', () {
//       expect(bloc.state, isA<EmployeesInitial>());
//     });
//
//     test('يجب أن يصدر [Loading, Empty] عندما تكون القائمة فارغة', () async {
//       mockRepo.mockEmployees = [];
//
//       final expectedStates = [
//         isA<EmployeesLoading>(),
//         isA<EmployeesEmpty>(),
//       ];
//
//       expectLater(bloc.stream, emitsInOrder(expectedStates));
//       bloc.add(LoadEmployeesEvent());
//     });
//
//     test('يجب أن يصدر [Loading, Loaded] عند وجود بيانات', () async {
//       mockRepo.mockEmployees = [
//         EmployeeEntity(id: "1", name: "أحمد", phoneNumber: "123", workshopName: "أ", imageUrl: "", currentLocation: "", isOnline: true, dailyWorkHours: {}, weeklyHistory: [], weeklyOvertime: 0, hourlyRate: 10, overtimeRate: 15, password: '')
//       ];
//
//       final expectedStates = [
//         isA<EmployeesLoading>(),
//         isA<EmployeesLoaded>(),
//       ];
//
//       expectLater(bloc.stream, emitsInOrder(expectedStates));
//       bloc.add(LoadEmployeesEvent());
//     });
//
//     test('يجب أن يعمل البحث بشكل صحيح ويصفي القائمة', () async {
//       // 1. شحن البيانات أولاً
//       final emp1 = EmployeeEntity(id: "1", name: "محمد", phoneNumber: "111", workshopName: "أ", imageUrl: "", currentLocation: "", isOnline: true, dailyWorkHours: {}, weeklyHistory: [], weeklyOvertime: 0, hourlyRate: 10, overtimeRate: 15, password: '');
//       final emp2 = EmployeeEntity(id: "2", name: "علي", phoneNumber: "222", workshopName: "ب", imageUrl: "", currentLocation: "", isOnline: true, dailyWorkHours: {}, weeklyHistory: [], weeklyOvertime: 0, hourlyRate: 10, overtimeRate: 15, password: '');
//
//       mockRepo.mockEmployees = [emp1, emp2];
//       bloc.add(LoadEmployeesEvent());
//       await Future.delayed(Duration.zero);
//
//       // 2. تجربة البحث
//       bloc.add(SearchEmployeesEvent("محمد"));
//
//       expectLater(bloc.stream, emitsThrough(predicate((state) {
//         if (state is EmployeesLoaded) {
//           return state.employees.length == 1 && state.employees.first.name == "محمد";
//         }
//         return false;
//       })));
//     });
//   });
// }
