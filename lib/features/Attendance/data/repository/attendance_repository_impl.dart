import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../../data/local/local_data_source.dart';
import '../../../../data/remote/remote_data_source.dart';
import '../models/attendance_record.dart';

class AttendanceRepositoryImpl {
  final RemoteDataSource remote;
  final LocalDataSource local;
  final Connectivity connectivity;

  AttendanceRepositoryImpl({
    required this.remote,
    required this.local,
    required this.connectivity,
  });

  Future<bool> _isOnline() async {
    final res = await connectivity.checkConnectivity();
    // Handling both old and new connectivity_plus API if needed, 
    // but sticking to the simple check for now based on previous errors fix.
    return res != ConnectivityResult.none;
  }

  /// تسجيل حضور جديد (Offline-First)
  Future<void> addAttendance(AttendanceRecord record) async {
    // 1. الحفظ محلياً أولاً لضمان عدم ضياع البيانات
    await local.addPendingAttendance(record);

    // 2. محاولة المزامنة فوراً إذا كان هناك إنترنت
    if (await _isOnline()) {
      await syncPendingRecords();
    }
  }

  /// مزامنة السجلات المعلقة
  Future<void> syncPendingRecords() async {
    final pendingEntries = local.getPendingEntries();
    if (pendingEntries.isEmpty) return;

    for (var entry in pendingEntries.entries) {
      final key = entry.key;
      final AttendanceRecord record = entry.value;

      try {
        await remote.postAttendance(record.toJson());
        await local.removePendingByKey(key);
      } catch (e) {
        print("فشلت مزامنة السجل $key: $e");
      }
    }
    
    // بعد المزامنة، نحدث البيانات المحلية من السيرفر لضمان المطابقة
    await refreshAttendanceFromServer();
  }

  /// تحديث السجلات المحلية من السيرفر
  Future<void> refreshAttendanceFromServer() async {
    try {
      if (await _isOnline()) {
        final serverRecords = await remote.fetchAttendance(userId: 'me');
        await local.saveAttendanceFromServer(
          serverRecords!.cast<Map<String, dynamic>>(),
        );
      }
    } catch (e) {
      print("خطأ في تحديث البيانات من السيرفر: $e");
    }
  }

  /// جلب كافة السجلات (المحلية)
  List<AttendanceRecord> getLocalAttendance() {
    return local.getAttendance();
  }
}
