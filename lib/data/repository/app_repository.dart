import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/app_varibles.dart';
import '../../core/di/injection.dart';
import '../../features/Attendance/data/models/attendance_record.dart';
import '../../features/admin/data/models/workshop_model.dart';
import '../remote/remote_data_source.dart';
import '../local/local_data_source.dart';
import '../../features/auth/data/repository/login_repo.dart';

@lazySingleton
class AppRepository {
  final RemoteDataSource remote;
  final LocalDataSource local;
  final Connectivity _connectivity;
  bool _isSyncing = false;

  AppRepository({
    required this.remote,
    required this.local,
    required Connectivity connectivity,
  }) : _connectivity = connectivity;

  /// 🔹 التحقق من الاتصال بالإنترنت
  Future<bool> _isOnline() async {
    final res = await _connectivity.checkConnectivity();
    if (res is List) {
      return (res as List).isNotEmpty && !res.contains(ConnectivityResult.none);
    }
    return res != ConnectivityResult.none;
  }

  /// 🔹 مزامنة الحضور المعلق مع السيرفر
  Future<void> syncPending() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      if (await _isOnline()) {
        // الحصول على المستخدم الحالي من AuthRepository
        final userId = AppVariables.user!.id!;

        if (userId == null) {
          print('Sync aborted: No authenticated user ID found.');
          return;
        }

        // 1️⃣ جلب البيانات من السيرفر
        final List<Map<String, dynamic>>? serverData = await remote
            .fetchAttendance(userId: userId);

        if (serverData == null) {
          print('Sync aborted: Auth error or server forbidden access.');
          return;
        }

        // 2️⃣ رفع البيانات المعلقة
        final pendings = await local.getPendingEntries();
        for (var entry in pendings.entries) {
          final dynamic key = entry.key;
          final record = entry.value;

          if (record.checkOutMillis == null) continue;

          try {
            await remote.postAttendance(record.toServerJson());

            if (key is String && key.startsWith('main_')) {
              final originalKey =
                  int.tryParse(key.replaceFirst('main_', '')) ?? -1;
              if (originalKey != -1) {
                await local.updateAttendanceRecordWithKey(
                  originalKey,
                  record.copyWith(syncStatus: 'synced'),
                );
              }
            } else {
              await local.removePendingByKey(key);
              await local.updateAttendanceRecord(
                record.copyWith(syncStatus: 'synced'),
              );
            }
          } catch (e) {
            print('Error uploading record $key to server: $e');
          }
        }

        // 3️⃣ تحديث البيانات المحلية من السيرفر
        if (serverData.isNotEmpty) {
          await local.saveAttendanceFromServer(serverData);
        }

        // 4️⃣ حذف الحضور الأقدم من 30 يوم
        final cutoff = DateTime.now().subtract(const Duration(days: 30));
        await local.pruneAttendanceOlderThan(cutoff);
      }
    } catch (e) {
      print('Global sync error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// 🔹 جلب قائمة الورش
  Future<List<WorkshopModel>> getWorkshops() async {
    if (await _isOnline()) {
      try {
        final workshops = await remote.getWorkshops();
        if (workshops.isNotEmpty) {
          await local.saveWorkshops(workshops);
          return workshops;
        }
      } catch (_) {}
    }
    return await local.getWorkshops();
  }

  /// 🔹 إضافة حضور جديد
  Future<void> addAttendance(AttendanceRecord rec) async {
    await local.addPendingAttendance(rec.copyWith(syncStatus: 'pending'));
    if (await _isOnline()) await syncPending();
  }
}

extension AttendanceRecordExtension on AttendanceRecord {
  AttendanceRecord copyWith({String? syncStatus}) {
    return AttendanceRecord(
      day: day,
      date: date,
      workshopNumber: workshopNumber,
      checkInMillis: checkInMillis,
      checkOutMillis: checkOutMillis,
      note: note,
      weekNumber: weekNumber,
      startDate: startDate,
      endDate: endDate,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
