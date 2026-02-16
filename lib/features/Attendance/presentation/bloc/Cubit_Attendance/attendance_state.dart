// import '../../../data/models/attendance_record.dart';
//
// enum AttendanceStatus { active, inactive }
//
// class AttendanceState {
//   final AttendanceStatus status;
//   final DateTime? checkInTime;
//   final DateTime? checkOutTime;
//   final List<AttendanceRecord> records;
//   final String? errorMessage;
//   final bool isLocationLoading;
//   final bool isSyncing; // إضافة حالة المزامنة
//
//   AttendanceState({
//     required this.status,
//     this.checkInTime,
//     this.checkOutTime,
//     this.records = const [],
//     this.errorMessage,
//     this.isLocationLoading = false,
//     this.isSyncing = false,
//   });
//
//   AttendanceState copyWith({
//     AttendanceStatus? status,
//     DateTime? checkInTime,
//     DateTime? checkOutTime,
//     List<AttendanceRecord>? records,
//     String? errorMessage,
//     bool? isLocationLoading,
//     bool? isSyncing,
//   }) {
//     return AttendanceState(
//       status: status ?? this.status,
//       checkInTime: checkInTime ?? this.checkInTime,
//       checkOutTime: checkOutTime ?? this.checkOutTime,
//       records: records ?? this.records,
//       errorMessage: errorMessage,
//       isLocationLoading: isLocationLoading ?? this.isLocationLoading,
//       isSyncing: isSyncing ?? this.isSyncing,
//     );
//   }
//
//   // ===== دوال مساعدة =====
//
//   List<AttendanceRecord> getWeekRecords(int weekNumber) {
//     return records.where((record) => record.weekNumber == weekNumber).toList();
//   }
//
//   List<int> get availableWeeks {
//     return records.map((record) => record.weekNumber).toSet().toList()..sort((a, b) => b.compareTo(a));
//   }
//
//   Duration getTotalHoursForWeek(int weekNumber) {
//     final weekRecords = getWeekRecords(weekNumber);
//     Duration total = Duration.zero;
//     for (var record in weekRecords) {
//       if (record.workDuration != null) total += record.workDuration!;
//     }
//     return total;
//   }
//
//   int getAttendanceDaysForWeek(int weekNumber) {
//     final weekRecords = getWeekRecords(weekNumber);
//     return weekRecords.where((record) => record.checkInMillis != null && record.checkOutMillis != null).length;
//   }
//
//   Map<int, Duration> getWorkshopHoursForWeek(int weekNumber) {
//     final weekRecords = getWeekRecords(weekNumber);
//     Map<int, Duration> workshopHours = {};
//     for (var record in weekRecords) {
//       if (record.workDuration != null) {
//         workshopHours[record.workshopNumber] = (workshopHours[record.workshopNumber] ?? Duration.zero) + record.workDuration!;
//       }
//     }
//     return workshopHours;
//   }
//
//   bool get hasRecords => records.isNotEmpty;
//   bool get hasError => errorMessage != null;
// }
