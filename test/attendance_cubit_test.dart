// import 'package:flutter_test/flutter_test.dart';
// import 'package:untitled8/features/Attendance/presentation/bloc/Cubit_Attendance/attendance_cubit.dart';
// import 'package:untitled8/features/Attendance/presentation/bloc/Cubit_Attendance/attendance_state.dart';
// import 'package:untitled8/features/Attendance/Repository/AttendanceRepository.dart';
// import 'package:untitled8/features/Attendance/data/models/attendance_record.dart';
// import 'package:untitled8/features/auth/data/datasources/auth_remote_data_source.dart';
// import 'package:untitled8/features/auth/data/repository/login_repo.dart';
// import 'package:untitled8/features/auth/data/model/login_response.dart';
// import 'package:hive/hive.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:untitled8/features/admin/domain/repositories/admin_repository.dart';
// import 'package:untitled8/features/admin/domain/entities/employee_entity.dart';
// import 'package:untitled8/features/admin/domain/entities/workshop_entity.dart';
//
// // محاكاة مستودع البيانات للاختبار
// class MockAttendanceRepository extends AttendanceRepository {
//   MockAttendanceRepository() : super(FakeBox<AttendanceRecord>());
//
//   @override
//   Future<int> addRecord(AttendanceRecord record) async => 1;
//
//   @override
//   List<AttendanceRecord> getAllRecords() => [];
//
//   @override
//   Future<void> updateCheckOut(int key, DateTime time) async {}
// }
//
// // محاكاة لـ AdminRepository
// class MockAdminRepository implements AdminRepository {
//   @override
//   Future<List<WorkshopEntity>> getWorkshops() async => [
//     const WorkshopEntity(id: "101", name: "ورشة تجريبية", latitude: 0, longitude: 0, radiusInMeters: 500)
//   ];
//
//   @override
//   dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
// }
//
// // محاكاة يدوية لـ AuthRepository
// class ManualMockAuthRepository implements AuthRepository {
//   @override
//   dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
//
//   @override
//   Future<User?> getCurrentUser() async {
//     return User(
//       id: 1,
//       username: "testuser",
//       fullName: "المستخدم التجريبي",
//       email: "test@test.com",
//       role: "employee",
//     );
//   }
//
//   @override
//   Future<String?> getUsername() async => "testuser";
//
//   @override
//   Future<bool> isLoggedIn() async => true;
//
//   @override
//   Future<String?> getToken() async => "fake_token";
//
//   @override
//   AuthRemoteDataSource get remoteDataSource => throw UnimplementedError();
//
//   @override
//   FlutterSecureStorage get secureStorage => throw UnimplementedError();
//
//   @override
//   Future<LoginResponse> login({required String username, required String password}) async => throw UnimplementedError();
//
//   @override
//   Future<LoginResponse> register({required String username, required String password, required String email, required String fullName, required String role}) async => throw UnimplementedError();
//
//   @override
//   Future<void> saveToken(String token) async {}
//
//   @override
//   Future<void> saveUser(User user) async {}
//
//   @override
//   Future<void> logout() async {}
// }
//
// // كلاس FakeBox مصلح ليتوافق مع أحدث إصدارات Hive
// class FakeBox<T> extends Iterable<T> implements Box<T> {
//   final Map<dynamic, T> _data = {};
//
//   @override
//   Future<void> put(key, T value) async => _data[key] = value;
//
//   @override
//   T? get(key, {T? defaultValue}) => _data[key] ?? defaultValue;
//
//   @override
//   Future<void> delete(key) async => _data.remove(key);
//
//   @override
//   bool get isOpen => true;
//
//   @override
//   String get name => 'fake_box';
//
//   @override
//   String? get path => null;
//
//   @override
//   bool get lazy => false;
//
//   @override
//   Future<int> clear() async {
//     int count = _data.length;
//     _data.clear();
//     return count;
//   }
//
//   @override
//   Future<void> close() async {}
//
//   @override
//   Future<void> compact() async {}
//
//   @override
//   bool containsKey(key) => _data.containsKey(key);
//
//   @override
//   Future<void> deleteAll(Iterable keys) async => _data.removeWhere((k, v) => keys.contains(k));
//
//   @override
//   Future<void> deleteAt(int index) async => _data.remove(keyAt(index));
//
//   @override
//   Future<void> deleteFromDisk() async => _data.clear();
//
//   @override
//   Future<void> flush() async {}
//
//   @override
//   T? getAt(int index) => _data.values.elementAt(index);
//
//   @override
//   bool get isEmpty => _data.isEmpty;
//
//   @override
//   bool get isNotEmpty => _data.isNotEmpty;
//
//   @override
//   keyAt(int index) => _data.keys.elementAt(index);
//
//   @override
//   Iterable get keys => _data.keys;
//
//   @override
//   int get length => _data.length;
//
//   @override
//   Future<void> putAll(Map<dynamic, T> entries) async => _data.addAll(entries);
//
//   @override
//   Future<void> putAt(int index, T value) async => _data[_data.keys.elementAt(index)] = value;
//
//   @override
//   Iterable<T> get values => _data.values;
//
//   @override
//   Iterable<T> valuesBetween({dynamic startKey, dynamic endKey}) => _data.values;
//
//   @override
//   Stream<BoxEvent> watch({key}) => throw UnimplementedError();
//
//   @override
//   Map<dynamic, T> toMap() => _data;
//
//   @override
//   Future<Iterable<int>> addAll(Iterable<T> values) async {
//     List<int> keys = [];
//     for (var v in values) {
//       keys.add(await add(v));
//     }
//     return keys;
//   }
//
//   @override
//   Future<int> add(T value) async {
//     int key = _data.length;
//     _data[key] = value;
//     return key;
//   }
//
//   @override
//   Iterator<T> get iterator => _data.values.iterator;
// }
//
// void main() {
//   late AttendanceCubit attendanceCubit;
//   late MockAttendanceRepository mockRepo;
//   late ManualMockAuthRepository mockAuthRepo;
//   late MockAdminRepository mockAdminRepo;
//   late FakeBox<AttendanceRecord> mockAttendanceBox;
//   late FakeBox mockStatusBox;
//
//   setUp(() {
//     mockAttendanceBox = FakeBox<AttendanceRecord>();
//     mockStatusBox = FakeBox();
//     mockRepo = MockAttendanceRepository();
//     mockAuthRepo = ManualMockAuthRepository();
//     mockAdminRepo = MockAdminRepository();
//
//     attendanceCubit = AttendanceCubit(
//       repository: mockRepo,
//       authRepository: mockAuthRepo,
//       adminRepository: mockAdminRepo,
//       attendanceBox: mockAttendanceBox,
//       statusBox: mockStatusBox,
//     );
//   });
//
//   group('AttendanceCubit Logic Tests', () {
//     test('الحالة الابتدائية يجب أن تكون inactive', () {
//       expect(attendanceCubit.state.status, AttendanceStatus.inactive);
//     });
//
//     test('عند عمل checkIn يجب أن تتحول الحالة لـ active', () async {
//       await attendanceCubit.checkIn(
//         day: "الأحد",
//         date: "2024/05/20",
//         workshopNumber: 101,
//         weekNumber: 1,
//         startDate: "2024/05/19",
//         endDate: "2024/05/25",
//       );
//
//       expect(attendanceCubit.state.status, AttendanceStatus.active);
//       expect(attendanceCubit.state.checkInTime, isNotNull);
//     });
//
//     test('عند عمل checkOut يجب أن تعود الحالة لـ inactive', () async {
//       // تسجيل دخول أولاً
//       await attendanceCubit.checkIn(
//         day: "الأحد", date: "20/05", workshopNumber: 101,
//         weekNumber: 1, startDate: "19/05", endDate: "25/05"
//       );
//
//       // ثم تسجيل خروج
//       await attendanceCubit.checkOut();
//
//       expect(attendanceCubit.state.status, AttendanceStatus.inactive);
//       expect(attendanceCubit.state.checkOutTime, isNotNull);
//     });
//   });
// }
