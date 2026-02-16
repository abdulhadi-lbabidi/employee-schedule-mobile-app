import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import '../features/Attendance/data/models/attendance_record.dart';
import '../features/Notification/data/model/notification_model.dart';
import '../features/admin/data/models/audit_log_model.dart';
import '../features/admin/data/models/workshop_models/workshop_model.g.dart';

@lazySingleton
class HiveService {
  final Map<String, Box> _boxes = {};
  bool _initialized = false;

  HiveService();

  /// تهيئة Hive وفتح جميع الـ Boxes
  Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();
    _registerAdapters();

    await Future.wait([
      openBox<AttendanceRecord>('attendanceBox'),
      openBox<AttendanceRecord>('pendingAttendance'),
      openBox('attendanceStatusBox'),
     // openBox<WorkshopModel>('workshopBox'),
      openBox<NotificationModel>('notificationBox'),
      openBox<AuditLogModel>('auditLogBox'),
      openBox('settings'),
    ]);

    _initialized = true;
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(AttendanceRecordAdapter());
   // if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(WorkshopModelAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(NotificationModelAdapter());
  //  if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(AuditLogModelAdapter());
  }

  Future<Box<T>> openBox<T>(String name) async {
    if (_boxes.containsKey(name)) return _boxes[name]! as Box<T>;
    final box = await Hive.openBox<T>(name);
    _boxes[name] = box;
    return box;
  }

  Future<Box<T>> getBox<T>(String name) async {
    if (!_boxes.containsKey(name)) {
      await openBox<T>(name);
    }
    return _boxes[name]! as Box<T>;
  }

  // getters
  Future<Box<AttendanceRecord>> get attendanceBox async => getBox('attendanceBox');
  Future<Box<AttendanceRecord>> get pendingAttendanceBox async => getBox('pendingAttendance');
  Future<Box> get attendanceStatusBox async => getBox('attendanceStatusBox');
  Future<Box<WorkshopModel>> get workshopBox async => getBox('workshopBox');
  Future<Box<NotificationModel>> get notificationBox async => getBox('notificationBox');
  Future<Box<AuditLogModel>> get auditLogBox async => getBox('auditLogBox');
  Future<Box> get settingsBox async => getBox('settings');
}

