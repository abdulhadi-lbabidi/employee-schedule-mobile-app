import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:untitled8/common/helper/src/app_varibles.dart';
import 'package:untitled8/core/services/location_service.dart';
import 'package:untitled8/core/services/notification_service.dart';
import 'package:untitled8/features/Notification/data/model/notification_model.dart';
import 'package:untitled8/features/Notification/presentation/bloc/notification_bloc.dart';
import 'package:untitled8/features/Notification/presentation/bloc/notification_event.dart';
import 'package:untitled8/features/admin/domain/repositories/workshop_repository.dart';
import 'package:untitled8/data/repository/app_repository.dart';
import '../../../../../core/hive_service.dart';
import '../../../../auth/data/repository/login_repo.dart';
import '../../../data/models/attendance_record.dart';
import 'attendance_state.dart';

@injectable
class AttendanceCubit extends Cubit<AttendanceState> {
  final AuthRepository authRepository;
  final WorkshopRepository workshopRepository;
  final NotificationBloc? notificationBloc;
  final AppRepository appRepository;
  final HiveService _hiveService;
  final LocationService locationService = LocationService();

  int? currentRecordKey;

  AttendanceCubit(
    this._hiveService,
    this.authRepository,
    this.workshopRepository,
    this.notificationBloc,
    this.appRepository,
  ) : super(AttendanceState(status: AttendanceStatus.inactive)) {
    _init();
  }

  /// ----------------------------
  /// Initialization
  /// ----------------------------
  Future<void> _init() async {
    await _loadStatus();
    await loadAllRecords();
  }

  /// Load saved status from Hive
  Future<void> _loadStatus() async {
    final statusBox = await _hiveService.attendanceStatusBox;
    final savedStatusString = statusBox.get("status", defaultValue: "inactive");
    final savedStatus =
        savedStatusString == "active"
            ? AttendanceStatus.active
            : AttendanceStatus.inactive;

    final savedCheckInString = statusBox.get("checkIn");
    final savedCheckOutString = statusBox.get("checkOut");

    DateTime? checkInTime =
        savedCheckInString != null
            ? DateTime.tryParse(savedCheckInString)
            : null;
    DateTime? checkOutTime =
        savedCheckOutString != null
            ? DateTime.tryParse(savedCheckOutString)
            : null;

    final rawKey = statusBox.get("currentRecordKey");
    if (rawKey is int) {
      currentRecordKey = rawKey;
    } else if (rawKey is String) {
      currentRecordKey = int.tryParse(rawKey);
    }

    emit(
      state.copyWith(
        status: savedStatus,
        checkInTime: checkInTime,
        checkOutTime: checkOutTime,
      ),
    );
  }

  /// ----------------------------
  /// Hive Operations (merged from repository)
  /// ----------------------------
  Future<Box<AttendanceRecord>> get _box async =>
      await _hiveService.getBox<AttendanceRecord>('attendanceBox');

  Future<int> _addRecord(AttendanceRecord record) async {
    final box = await _box;
    return await box.add(record);
  }

  Future<void> _updateCheckOut(int key, DateTime checkOutTime) async {
    final box = await _box;
    final record = box.get(key);
    if (record != null) {
      final updatedRecord = record.copyWith(
        checkOutMillis: checkOutTime.toIso8601String(),
      );
      await box.put(key, updatedRecord);
    }
  }

  Future<void> _updateRecord(int key, AttendanceRecord updatedRecord) async {
    final box = await _box;
    await box.put(key, updatedRecord);
  }

  Future<void> _deleteRecord(int key) async {
    final box = await _box;
    await box.delete(key);
  }

  Future<void> _clearAll() async {
    final box = await _box;
    await box.clear();
  }

  Future<List<AttendanceRecord>> getAllRecords() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<List<AttendanceRecord>> getFilteredRecords({
    int? workshopNumber,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final box = await _box;
    return box.values.where((record) {
      final recordDate = record.checkInTime;
      bool matchesWorkshop =
          workshopNumber == null || record.workshopNumber == workshopNumber;
      bool matchesDate = true;

      if (recordDate != null) {
        if (startDate != null && recordDate.isBefore(startDate))
          matchesDate = false;
        if (endDate != null && recordDate.isAfter(endDate)) matchesDate = false;
      }

      return matchesWorkshop && matchesDate;
    }).toList();
  }

  Future<List<int>> _getAvailableWeeks() async {
    final box = await _hiveService.getBox<AttendanceRecord>('attendanceBox');
    return box.values.map((r) => r.weekNumber).toSet().toList()..sort();
  }

  /// ----------------------------
  /// Public Cubit Methods
  /// ----------------------------
  Future<void> loadAllRecords() async {
    try {
      final records = await getAllRecords();
      emit(state.copyWith(records: records));
    } catch (e) {
      emit(
        state.copyWith(errorMessage: "خطأ في تحميل السجلات: ${e.toString()}"),
      );
    }
  }

  Future<void> checkIn({
    required String day,
    required String date,
    required int workshopNumber,
    required int weekNumber,
    required String startDate,
    required String endDate,
    String? note,
  })
  async {
    try {
      emit(state.copyWith(errorMessage: null, isLocationLoading: true));

      final workshopsResult = await workshopRepository.getWorkshops();
      String workshopName = "ورشة رقم $workshopNumber";

      workshopsResult.fold((failure) => throw failure.message,
              (workshops) {
        final currentWorkshop = workshops.firstWhere(
          (w) => w.id == workshopNumber.toString(),
          orElse: () => throw 'الورشة المحددة غير موجودة أو غير متاحة لك.',
        );
        workshopName = currentWorkshop.name!;
      });

      final now = DateTime.now();
      final user = AppVariables.user;
      final userName = user?.fullName ?? "الموظف";

      final statusBox = await _hiveService.attendanceStatusBox;
      await statusBox.put("status", "active");
      await statusBox.put("checkIn", now.toIso8601String());

      final record = AttendanceRecord(
        day: day,
        date: date,
        workshopNumber: workshopNumber,
        checkInMillis: now.toIso8601String(),
        checkOutMillis: null,
        weekNumber: weekNumber,
        startDate: startDate,
        endDate: endDate,
        note: note,
        syncStatus: 'pending',
      );

      final key = await _addRecord(record);
      currentRecordKey = key;
      await statusBox.put("currentRecordKey", key);

      await loadAllRecords();

      await NotificationService().showNotification(
        title: "تم تسجيل الحضور ✅",
        body: "أهلاً $userName، تم تسجيل حضورك في $workshopName بنجاح.",
      );

      notificationBloc?.add(
        AddLocalNotificationEvent(
          NotificationModel(
            id: "checkin_${now.millisecondsSinceEpoch}",
            title: "تسجيل حضور",
            body: "قام $userName بتسجيل الحضور في $workshopName بتاريخ $date",
            createdAt: now,
            type: 'attendance',
            isRead: false,
          ),
        ),
      );

      emit(
        state.copyWith(
          status: AttendanceStatus.active,
          checkInTime: now,
          checkOutTime: null,
          isLocationLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(errorMessage: e.toString(), isLocationLoading: false),
      );
    }
  }

  Future<void> checkOut() async {
    try {
      final now = DateTime.now();
      final user = AppVariables.user;
      final userName = user?.fullName ?? "الموظف";

      final statusBox = await _hiveService.attendanceStatusBox;
      await statusBox.put("status", "inactive");
      await statusBox.put("checkOut", now.toIso8601String());

      if (currentRecordKey != null) {
        await _updateCheckOut(currentRecordKey!, now);
        await statusBox.delete("currentRecordKey");
        currentRecordKey = null;
      }

      await loadAllRecords();

      await NotificationService().showNotification(
        title: "تم تسجيل الانصراف 👋",
        body: "وداعاً $userName، تم تسجيل انصرافك بنجاح. يومك سعيد!",
      );

      notificationBloc?.add(
        AddLocalNotificationEvent(
          NotificationModel(
            id: "checkout_${now.millisecondsSinceEpoch}",
            title: "تسجيل انصراف",
            body:
                "تم تسجيل انصراف $userName بنجاح في تمام الساعة ${DateFormat('HH:mm').format(now)}",
            createdAt: now,
            type: 'attendance',
            isRead: false,
          ),
        ),
      );

      emit(
        state.copyWith(status: AttendanceStatus.inactive, checkOutTime: now),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: "خطأ في checkOut: ${e.toString()}"));
    }
  }

  Future<void> syncData() async {
    if (state.isSyncing) return;

    emit(state.copyWith(isSyncing: true, errorMessage: null));
    try {
      await appRepository.syncPending();
      await loadAllRecords();
      await NotificationService().showNotification(
        title: "تمت المزامنة بنجاح",
        body: "تم تحديث سجلات الحضور بنجاح مع الخادم.",
      );
    } catch (e) {
      emit(
        state.copyWith(errorMessage: "فشل في مزامنة البيانات: ${e.toString()}"),
      );
    } finally {
      emit(state.copyWith(isSyncing: false));
    }
  }

  Future<void> clearAllRecords() async {
    try {
      await _clearAll();
      final statusBox = await _hiveService.attendanceStatusBox;
      await statusBox.delete("currentRecordKey");
      currentRecordKey = null;
      emit(state.copyWith(records: []));
    } catch (e) {
      emit(state.copyWith(errorMessage: "خطأ في حذف السجلات: ${e.toString()}"));
    }
  }
}
