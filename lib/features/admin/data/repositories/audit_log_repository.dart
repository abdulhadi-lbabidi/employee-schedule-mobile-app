import 'package:hive/hive.dart';
import '../models/audit_log_model.dart';
import 'package:injectable/injectable.dart';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class AuditLogRepository {
  static const String _logsKey = "audit_logs";

  final SharedPreferences _prefs;

  AuditLogRepository(this._prefs);

  ///  تسجيل نشاط جديد في السجل
  Future<void> logAction({
    required String actionType,
    required String targetName,
    required String details,
  }) async {
    final log = AuditLogModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      adminName: "المدير العام",
      actionType: actionType,
      targetName: targetName,
      details: details,
      timestamp: DateTime.now(),
    );

    final logs = await _getStoredLogs();
    logs.add(log);

    await _saveLogs(logs);
  }

  /// 🔹 جلب كافة النشاطات مرتبة من الأحدث
  List<AuditLogModel> getLogs() {
    final logsJson = _prefs.getStringList(_logsKey) ?? [];

    final logs = logsJson
        .map((e) => AuditLogModel.fromJson(jsonDecode(e)))
        .toList();

    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return logs;
  }

  /// 🔹 مسح السجل (إجراء إداري علوي)
  Future<void> clearLogs() async {
    await _prefs.remove(_logsKey);
  }

  /// ================== Private Helpers ==================

  Future<List<AuditLogModel>> _getStoredLogs() async {
    final logsJson = _prefs.getStringList(_logsKey) ?? [];

    return logsJson
        .map((e) => AuditLogModel.fromJson(jsonDecode(e)))
        .toList();
  }

  Future<void> _saveLogs(List<AuditLogModel> logs) async {
    final encodedLogs =
    logs.map((e) => jsonEncode(e.toJson())).toList();

    await _prefs.setStringList(_logsKey, encodedLogs);
  }
}
