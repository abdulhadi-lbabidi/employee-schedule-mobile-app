import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

@HiveType(typeId: 0)
class AttendanceRecord extends HiveObject {
  @HiveField(0)
  final String day;
  @HiveField(1)
  final String date; // تستخدم للعرض في UI
  @HiveField(2)
  final int workshopNumber;
  @HiveField(3)
  final String? checkInMillis; 
  @HiveField(4)
  final String? checkOutMillis; 
  @HiveField(5)
  final String? note;
  @HiveField(6)
  final int weekNumber;
  @HiveField(7)
  final String startDate;
  @HiveField(8)
  final String endDate;
  @HiveField(9)
  final String syncStatus;

  AttendanceRecord({
    required this.day,
    required this.date,
    required this.workshopNumber,
    this.checkInMillis,
    this.checkOutMillis,
    this.note,
    required this.weekNumber,
    required this.startDate,
    required this.endDate,
    required this.syncStatus,
  });

  AttendanceRecord copyWith({
    String? day, String? date, int? workshopNumber, String? checkInMillis,
    String? checkOutMillis, String? note, int? weekNumber, String? startDate,
    String? endDate, String? syncStatus,
  }) {
    return AttendanceRecord(
      day: day ?? this.day,
      date: date ?? this.date,
      workshopNumber: workshopNumber ?? this.workshopNumber,
      checkInMillis: checkInMillis ?? this.checkInMillis,
      checkOutMillis: checkOutMillis ?? this.checkOutMillis,
      note: note ?? this.note,
      weekNumber: weekNumber ?? this.weekNumber,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  Map<String, dynamic> toJson() => {
    'day': day, 'date': date, 'workshopNumber': workshopNumber,
    'checkInMillis': checkInMillis, 'checkOutMillis': checkOutMillis,
    'note': note, 'weekNumber': weekNumber, 'startDate': startDate,
    'endDate': endDate, 'syncStatus': syncStatus,
  };

  // 🔹 التعديل الاحترافي للإرسال للسيرفر لتجنب خطأ 422
  Map<String, dynamic> toServerJson() {
    // نستخدم وقت تسجيل الحضور الفعلي للحصول على تاريخ صحيح بصيغة yyyy-MM-dd
    final DateTime? fullDate = checkInTime;
    final String formattedDate = fullDate != null 
        ? DateFormat('yyyy-MM-dd').format(fullDate) 
        : DateFormat('yyyy-MM-dd').format(DateTime.now());

    return {
      'workshop_id': workshopNumber.toString(), // تحويل لـ String لضمان القبول
      'date': formattedDate, // الصيغة التي يتوقعها الباك إند
      'check_in': checkInFormatted != "---" ? checkInFormatted : null,
      'check_out': checkOutFormatted != "---" ? checkOutFormatted : null,
      'week_number': weekNumber.toString(),
      'note': note ?? "",
    };
  }

  DateTime? _parseTime(String? val) {
    if (val == null || val.isEmpty) return null;
    return DateTime.tryParse(val) ?? DateTime.fromMillisecondsSinceEpoch(int.tryParse(val) ?? 0);
  }

  DateTime? get checkInTime => _parseTime(checkInMillis);
  DateTime? get checkOutTime => _parseTime(checkOutMillis);
  
  Duration? get workDuration {
    final start = checkInTime;
    final end = checkOutTime;
    if (start == null || end == null) return null;
    return end.difference(start);
  }

  String get checkInFormatted => checkInTime == null ? "---" : DateFormat('HH:mm').format(checkInTime!);
  String get checkOutFormatted => checkOutTime == null ? "---" : DateFormat('HH:mm').format(checkOutTime!);
  
  String get hoursFormatted {
    if (workDuration == null) return "---";
    final hours = workDuration!.inHours.toString().padLeft(2, '0');
    final minutes = (workDuration!.inMinutes % 60).toString().padLeft(2, '0');
    return "$hours:$minutes";
  }
}

class AttendanceRecordAdapter extends TypeAdapter<AttendanceRecord> {
  @override
  final int typeId = 0;
  @override
  AttendanceRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read()};
    return AttendanceRecord(
      day: fields[0] as String, 
      date: fields[1] as String, 
      workshopNumber: fields[2] as int,
      checkInMillis: fields[3]?.toString(), 
      checkOutMillis: fields[4]?.toString(), 
      note: fields[5] as String?,
      weekNumber: fields[6] as int, 
      startDate: fields[7] as String, 
      endDate: fields[8] as String,
      syncStatus: fields[9] as String,
    );
  }
  @override
  void write(BinaryWriter writer, AttendanceRecord obj) {
    writer..writeByte(10)..writeByte(0)..write(obj.day)..writeByte(1)..write(obj.date)..writeByte(2)..write(obj.workshopNumber)
      ..writeByte(3)..write(obj.checkInMillis)..writeByte(4)..write(obj.checkOutMillis)..writeByte(5)..write(obj.note)
      ..writeByte(6)..write(obj.weekNumber)..writeByte(7)..write(obj.startDate)..writeByte(8)..write(obj.endDate)..writeByte(9)..write(obj.syncStatus);
  }
}
