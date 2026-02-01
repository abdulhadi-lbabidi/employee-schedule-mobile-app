import 'package:connectivity_plus/connectivity_plus.dart';
import '../../features/Attendance/data/models/attendance_record.dart';
import '../../features/admin/data/models/workshop_model.dart';
import '../remote/remote_data_source.dart';
import '../local/local_data_source.dart';
import '../../features/auth/data/repository/login_repo.dart';
import '../../core/di/service_locator.dart';

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

  Future<bool> _isOnline() async {
    final res = await _connectivity.checkConnectivity();
    if (res is List) {
      return (res as List).isNotEmpty && !res.contains(ConnectivityResult.none);
    }
    return res != ConnectivityResult.none;
  }

  Future<void> syncPending() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      if (await _isOnline()) {
        final authRepo = sl<AuthRepository>();
        final user = await authRepo.getCurrentUser();
        final userId = user?.id.toString();

        if (userId == null) {
          print('Sync aborted: No authenticated user ID found.');
          return;
        }

        // 1. جلب البيانات من السيرفر (GET)
        final List<Map<String, dynamic>>? serverData = await remote.fetchAttendance(userId: userId);
        
        if (serverData == null) {
          print('Sync aborted: Auth error or server forbidden access.');
          return; 
        }

        // 2. رفع البيانات المعلقة (POST)
        final pendings = local.getPendingEntries();
        for (var entry in pendings.entries) {
          final dynamic key = entry.key;
          final record = entry.value;
          
          if (record.checkOutMillis == null) continue;

          try {
            // 🔹 التصحيح: استخدام toServerJson() بدلاً من toJson()
            await remote.postAttendance(record.toServerJson());
            
            if (key is String && key.startsWith('main_')) {
              final originalKey = int.tryParse(key.replaceFirst('main_', '')) ?? -1;
              if (originalKey != -1) {
                await local.updateAttendanceRecordWithKey(originalKey, record.copyWith(syncStatus: 'synced'));
              }
            } else {
              await local.removePendingByKey(key);
              await local.updateAttendanceRecord(record.copyWith(syncStatus: 'synced'));
            }
          } catch (e) {
             print('Error uploading record $key to server: $e');
          }
        }

        // 3. تحديث البيانات المحلية
        if (serverData.isNotEmpty) {
          await local.saveAttendanceFromServer(serverData);
        }
        
        final cutoff = DateTime.now().subtract(const Duration(days: 30));
        await local.pruneAttendanceOlderThan(cutoff);
      }
    } catch (e) {
      print('Global sync error: $e');
    } finally {
      _isSyncing = false;
    }
  }

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
    return local.getWorkshops();
  }

  Future<void> addAttendance(AttendanceRecord rec) async {
    await local.addPendingAttendance(rec.copyWith(syncStatus: 'pending'));
    if (await _isOnline()) await syncPending();
  }
}

extension AttendanceRecordExtension on AttendanceRecord {
  AttendanceRecord copyWith({String? syncStatus}) {
    return AttendanceRecord(
      day: day, date: date, workshopNumber: workshopNumber,
      checkInMillis: checkInMillis, checkOutMillis: checkOutMillis,
      note: note, weekNumber: weekNumber, startDate: startDate,
      endDate: endDate, syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
