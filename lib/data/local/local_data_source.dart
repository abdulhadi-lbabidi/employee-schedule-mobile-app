// import 'package:hive/hive.dart';
// import 'package:injectable/injectable.dart';
// import '../../core/hive_service.dart';
// import '../../features/Attendance/data/models/attendance_record.dart';
// import '../../features/admin/data/models/workshop_model.dart';
//
// @lazySingleton
// class LocalDataSource {
//   final HiveService hiveService;
//
//   LocalDataSource({required this.hiveService});
//
//   /// 🔹 الحصول على Boxes من HiveService
//   Future<Box> get _settingsBox async => await hiveService.settingsBox;
//   Future<Box<AttendanceRecord>> get _attendanceBox async =>
//       await hiveService.attendanceBox;
//   Future<Box<AttendanceRecord>> get _pendingBox async =>
//       await hiveService.pendingAttendanceBox;
//   Future<Box<WorkshopModel>> get _workshopsBox async =>
//       await hiveService.workshopBox;
//
//   /// 🔹 تخزين التوكن
//   Future<void> saveToken(String token) async {
//     final box = await _settingsBox;
//     await box.put('auth_token', token);
//   }
//
//   /// 🔹 الحصول على التوكن
//   Future<String?> getToken() async {
//     final box = await _settingsBox;
//     return box.get('auth_token');
//   }
//
//   /// 🔹 حفظ قائمة الورش
//   Future<void> saveWorkshops(List<WorkshopModel> list) async {
//     final box = await _workshopsBox;
//     await box.clear();
//     for (var w in list) {
//       await box.add(w);
//     }
//   }
//
//   /// 🔹 جلب كل الورش
//   Future<List<WorkshopModel>> getWorkshops() async {
//     final box = await _workshopsBox;
//     return box.values.cast<WorkshopModel>().toList();
//   }
//
//   /// 🔹 إضافة حضور مؤقت (Pending)
//   Future<void> addPendingAttendance(AttendanceRecord rec) async {
//     final box = await _pendingBox;
//     await box.add(rec);
//   }
//
//   /// 🔹 تحديث سجل حضور
//   Future<void> updateAttendanceRecord(AttendanceRecord rec) async {
//     final box = await _attendanceBox;
//     await box.add(rec);
//   }
//
//   /// 🔹 تحديث سجل حضور باستخدام المفتاح
//   Future<void> updateAttendanceRecordWithKey(dynamic key, AttendanceRecord rec) async {
//     final box = await _attendanceBox;
//     await box.put(key, rec);
//   }
//
//   /// 🔹 الحصول على سجلات الحضور المعلقة
//   Future<Map<dynamic, AttendanceRecord>> getPendingEntries() async {
//     final pending = await _pendingBox;
//     final attendance = await _attendanceBox;
//     final Map<dynamic, AttendanceRecord> result = {};
//
//     for (var key in pending.keys) {
//       final rec = pending.get(key);
//       if (rec != null) result[key] = rec;
//     }
//
//     for (var key in attendance.keys) {
//       final rec = attendance.get(key);
//       if (rec != null && rec.syncStatus == 'pending') {
//         result['main_$key'] = rec;
//       }
//     }
//
//     return result;
//   }
//
//   /// 🔹 الحصول على قائمة الحضور المعلق
//   Future<List<AttendanceRecord>> getPendingAttendance() async {
//     final entries = await getPendingEntries();
//     return entries.values.toList();
//   }
//
//   /// 🔹 حفظ حضور من السيرفر
//   Future<void> saveAttendanceFromServer(List<Map<String, dynamic>> items) async {
//     final box = await _attendanceBox;
//
//     for (var it in items) {
//       final String? checkIn = it['checkInMillis']?.toString() ?? it['check_in']?.toString();
//       final String? checkOut = it['checkOutMillis']?.toString() ?? it['check_out']?.toString();
//
//       final rec = AttendanceRecord(
//         day: it['day']?.toString() ?? '',
//         date: it['date']?.toString() ?? '',
//         workshopNumber: int.tryParse("${it['workshopNumber'] ?? it['workshop_id']}") ?? 0,
//         checkInMillis: checkIn,
//         checkOutMillis: checkOut,
//         note: it['note']?.toString(),
//         weekNumber: int.tryParse("${it['weekNumber'] ?? it['week_number']}") ?? 0,
//         startDate: it['startDate']?.toString() ?? '',
//         endDate: it['endDate']?.toString() ?? '',
//         syncStatus: 'synced',
//       );
//
//       final exists = box.values.any((element) =>
//       element.checkInMillis == checkIn &&
//           element.workshopNumber == rec.workshopNumber);
//
//       if (!exists) {
//         await box.add(rec);
//       }
//     }
//   }
//
//   /// 🔹 جلب كل سجلات الحضور
//   Future<List<AttendanceRecord>> getAttendance() async {
//     final box = await _attendanceBox;
//     return box.values.cast<AttendanceRecord>().toList();
//   }
//
//   /// 🔹 حذف الحضور الأقدم من تاريخ محدد
//   Future<void> pruneAttendanceOlderThan(DateTime cutoff) async {
//     final box = await _attendanceBox;
//     final keysToDelete = <dynamic>[];
//
//     for (var key in box.keys) {
//       final r = box.get(key) as AttendanceRecord;
//       final created = r.checkInTime;
//       if (created != null && created.isBefore(cutoff) && r.syncStatus == 'synced') {
//         keysToDelete.add(key);
//       }
//     }
//
//     for (var k in keysToDelete) {
//       await box.delete(k);
//     }
//   }
//
//   /// 🔹 حذف سجل حضور معلق باستخدام المفتاح
//   Future<void> removePendingByKey(dynamic key) async {
//     final box = await _pendingBox;
//     if (key is String && key.startsWith('main_')) {
//       // لا تفعل شيء للحضور الرئيسي لأنه موجود في attendanceBox
//     } else {
//       await box.delete(key);
//     }
//   }
// }

