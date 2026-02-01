import 'package:hive/hive.dart';
import '../../features/Attendance/data/models/attendance_record.dart';
import '../../features/admin/data/models/workshop_model.dart';

class LocalDataSource {
  final Box settingsBox;
  final Box<AttendanceRecord> attendanceBox;
  final Box<AttendanceRecord> pendingBox;
  final Box<WorkshopModel> workshopsBox;

  LocalDataSource({
    required this.settingsBox,
    required this.attendanceBox,
    required this.pendingBox,
    required this.workshopsBox,
  });

  Future<void> saveToken(String token) => settingsBox.put('auth_token', token);
  String? getToken() => settingsBox.get('auth_token');

  Future<void> saveWorkshops(List<WorkshopModel> list) async {
    await workshopsBox.clear();
    for (var w in list) {
      await workshopsBox.add(w);
    }
  }

  List<WorkshopModel> getWorkshops() {
    return workshopsBox.values.cast<WorkshopModel>().toList();
  }

  Future<void> addPendingAttendance(AttendanceRecord rec) async {
    await pendingBox.add(rec);
  }

  Future<void> updateAttendanceRecord(AttendanceRecord rec) async {
    await attendanceBox.add(rec); 
  }

  Future<void> updateAttendanceRecordWithKey(dynamic key, AttendanceRecord rec) async {
    await attendanceBox.put(key, rec);
  }

  Map<dynamic, AttendanceRecord> getPendingEntries() {
    final Map<dynamic, AttendanceRecord> result = {};
    for (var key in pendingBox.keys) {
      final rec = pendingBox.get(key);
      if (rec != null) result[key] = rec;
    }
    for (var key in attendanceBox.keys) {
      final rec = attendanceBox.get(key);
      if (rec != null && rec.syncStatus == 'pending') {
        result['main_$key'] = rec;
      }
    }
    return result;
  }

  List<AttendanceRecord> getPendingAttendance() {
    return getPendingEntries().values.toList();
  }

  Future<void> saveAttendanceFromServer(List<Map<String, dynamic>> items) async {
    for (var it in items) {
      final String? checkIn = it['checkInMillis']?.toString() ?? it['check_in']?.toString();
      final String? checkOut = it['checkOutMillis']?.toString() ?? it['check_out']?.toString();

      final rec = AttendanceRecord(
        day: it['day']?.toString() ?? '',
        date: it['date']?.toString() ?? '',
        workshopNumber: int.tryParse("${it['workshopNumber'] ?? it['workshop_id']}") ?? 0,
        checkInMillis: checkIn,
        checkOutMillis: checkOut,
        note: it['note']?.toString(),
        weekNumber: int.tryParse("${it['weekNumber'] ?? it['week_number']}") ?? 0,
        startDate: it['startDate']?.toString() ?? '',
        endDate: it['endDate']?.toString() ?? '',
        syncStatus: 'synced',
      );

      bool exists = attendanceBox.values.any((element) => 
        element.checkInMillis == checkIn && 
        element.workshopNumber == rec.workshopNumber
      );

      if (!exists) {
        await attendanceBox.add(rec);
      }
    }
  }

  List<AttendanceRecord> getAttendance() {
    return attendanceBox.values.cast<AttendanceRecord>().toList();
  }

  Future<void> pruneAttendanceOlderThan(DateTime cutoff) async {
    final keysToDelete = <dynamic>[];

    for (var key in attendanceBox.keys) {
      final r = attendanceBox.get(key) as AttendanceRecord;
      final created = r.checkInTime; 

      if (created != null) {
        if (created.isBefore(cutoff) && r.syncStatus == 'synced') {
          keysToDelete.add(key);
        }
      }
    }

    for (var k in keysToDelete) {
      await attendanceBox.delete(k);
    }
  }

  Future<void> removePendingByKey(dynamic key) async {
    if (key is String && key.startsWith('main_')) {
    } else {
      await pendingBox.delete(key);
    }
  }
}
