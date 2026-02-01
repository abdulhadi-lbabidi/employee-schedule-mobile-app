import 'package:hive/hive.dart';

import '../../../../features/Attendance/data/model/work/workshope.dart';
import '../../../../features/Attendance/data/models/attendance_record.dart';

class LocalDataSource {
  final Box settingsBox;
  final Box<AttendanceRecord> attendanceBox;
  final Box<AttendanceRecord> pendingBox;
  final Box<Workshope> workshopsBox;


  LocalDataSource({
    required this.settingsBox,
    required this.attendanceBox,
    required this.pendingBox,
    required this.workshopsBox,

  });

  Future<void> saveToken(String token) => settingsBox.put('auth_token', token);
  String? getToken() => settingsBox.get('auth_token');

  Future<void> saveWorkshops(List<Workshope> list) async {
    await workshopsBox.clear();
    await workshopsBox.addAll(list);
  }

  List<Workshope> getWorkshops() => workshopsBox.values.toList();

  // Future<void> saveLogisticteam(List<Logisticteam> list) async {
  //   await logisticteamBox.clear();
  //   await logisticteamBox.addAll(list);
  // }

  // List<Logisticteam> getLogisticteams() => logisticteamBox.values.toList();

  Future<void> addPendingAttendance(AttendanceRecord rec) async => await pendingBox.add(rec);

  Map<dynamic, AttendanceRecord> getPendingEntries() {
    final Map<dynamic, AttendanceRecord> result = {};
    for (var key in pendingBox.keys) {
      result[key] = pendingBox.get(key) as AttendanceRecord;
    }
    return result;
  }

  Future<void> saveAttendanceFromServer(List<Map<String, dynamic>> items) async {
    await attendanceBox.clear();
    for (var it in items) {
      final rec = AttendanceRecord(
        day: it['day']?.toString() ?? '',
        date: it['date']?.toString() ?? '',
        workshopNumber: int.tryParse("${it['workshopNumber']}") ?? 0,
        checkInMillis: it['checkInMillis'] ?? it['check_in'],
        checkOutMillis: it['checkOutMillis'] ?? it['check_out'],
        note: it['note']?.toString(),
        weekNumber: int.tryParse("${it['weekNumber']}") ?? 0,
        startDate: it['startDate']?.toString() ?? '',
        endDate: it['endDate']?.toString() ?? '',
        syncStatus: 'synced',
      );
      await attendanceBox.add(rec);
    }
  }

  List<AttendanceRecord> getAttendance() => attendanceBox.values.toList();

  Future<void> removePendingByKey(dynamic key) async => await pendingBox.delete(key);
}
