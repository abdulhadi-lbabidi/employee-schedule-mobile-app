import 'package:hive/hive.dart';
import '../models/audit_log_model.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class AuditLogRepository {
  final Box<AuditLogModel> _box;

  AuditLogRepository(this._box);

  /// 🔹 تسجيل نشاط جديد في السجل
  Future<void> logAction({
    required String actionType,
    required String targetName,
    required String details,
  }) async {
    final log = AuditLogModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      adminName: "المدير العام", // يمكن جلب الاسم الحقيقي من الـ Profile مستقبلاً
      actionType: actionType,
      targetName: targetName,
      details: details,
      timestamp: DateTime.now(),
    );
    await _box.add(log);
  }

  /// 🔹 جلب كافة النشاطات مرتبة من الأحدث
  List<AuditLogModel> getLogs() {
    return _box.values.toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// 🔹 مسح السجل (إجراء إداري علوي)
  Future<void> clearLogs() async {
    await _box.clear();
  }
}
