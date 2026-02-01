import 'package:hive/hive.dart';
import '../data/models/attendance_record.dart';

abstract class IAttendanceRepository {
  Future<int> addRecord(AttendanceRecord record);
  Future<void> addMultipleRecords(List<AttendanceRecord> records);
  Future<List<AttendanceRecord>> getAllRecords();
  Future<void> updateRecord(int key, AttendanceRecord record);
  Future<void> deleteRecord(int key);
  List<int> getAvailableWeeks();
  Future<void> clearAll();
  Future<List<AttendanceRecord>> getFilteredRecords({int? workshopNumber, DateTime? startDate, DateTime? endDate});
}

class AttendanceRepository implements IAttendanceRepository {
  final Box<AttendanceRecord> _box;

  AttendanceRepository(this._box);

  @override
  Future<int> addRecord(AttendanceRecord record) async => await _box.add(record);

  @override
  Future<void> addMultipleRecords(List<AttendanceRecord> records) async => await _box.addAll(records);

  @override
  Future<List<AttendanceRecord>> getAllRecords() async => await Future.value(_box.values.toList());

  @override
  Future<List<AttendanceRecord>> getFilteredRecords({int? workshopNumber, DateTime? startDate, DateTime? endDate}) async {
    return await Future.value(_box.values.where((record) {
      bool matchesWorkshop = workshopNumber == null || record.workshopNumber == workshopNumber;
      
      bool matchesDate = true;
      final recordDate = record.checkInTime; 
      if (recordDate != null) {
        if (startDate != null && recordDate.isBefore(startDate)) matchesDate = false;
        if (endDate != null && recordDate.isAfter(endDate)) matchesDate = false;
      }
      
      return matchesWorkshop && matchesDate;
    }).toList());
  }

  Future<void> updateCheckOut(int key, DateTime checkOutTime) async {
    final record = _box.get(key);
    if (record != null) {
      // 🔹 تحويل الوقت لنص ISO8601 عند التحديث ليناسب نوع String?
      final updatedRecord = record.copyWith(checkOutMillis: checkOutTime.toIso8601String());
      await _box.put(key, updatedRecord);
    }
  }

  @override
  Future<void> updateRecord(int key, AttendanceRecord updatedRecord) async => await _box.put(key, updatedRecord);

  @override
  Future<void> deleteRecord(int key) async => await _box.delete(key);

  @override
  Future<void> clearAll() async => await _box.clear();

  @override
  List<int> getAvailableWeeks() => _box.values.map((r) => r.weekNumber).toSet().toList()..sort();
}
