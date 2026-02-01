import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:untitled8/core/services/location_service.dart';
import 'package:untitled8/core/services/notification_service.dart';
import 'package:untitled8/features/Notification/data/model/notification_model.dart';
import 'package:untitled8/features/Notification/presentation/bloc/notification_bloc.dart';
import 'package:untitled8/features/Notification/presentation/bloc/notification_event.dart';
import 'package:untitled8/features/admin/domain/repositories/admin_repository.dart';
import 'package:untitled8/features/admin/domain/repositories/workshop_repository.dart';
import 'package:untitled8/data/repository/app_repository.dart';
import '../../../../auth/data/repository/login_repo.dart';
import '../../../Repository/AttendanceRepository.dart';
import '../../../data/models/attendance_record.dart';

import 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final AttendanceRepository repository;
  final AuthRepository authRepository;
  final WorkshopRepository workshopRepository; 
  final Box<AttendanceRecord> attendanceBox; 
  final Box statusBox; 
  final NotificationBloc? notificationBloc; 
  final LocationService locationService = LocationService(); 
  final AppRepository appRepository;

  int? currentRecordKey; 

  AttendanceCubit({
    required this.repository,
    required this.authRepository,
    required this.workshopRepository,
    required this.attendanceBox,
    required this.statusBox,
    this.notificationBloc,
    required this.appRepository,
  }) : super(AttendanceState(status: AttendanceStatus.inactive)) {
    _init();
    _loadStatus();
    loadAllRecords();
  }

  void _loadStatus() {
    final savedStatusString = statusBox.get("status", defaultValue: "inactive");
    final savedStatus = savedStatusString == "active" ? AttendanceStatus.active : AttendanceStatus.inactive;
    final savedCheckInString = statusBox.get("checkIn");
    final savedCheckOutString = statusBox.get("checkOut");

    DateTime? checkInTime = savedCheckInString != null ? DateTime.tryParse(savedCheckInString) : null;
    DateTime? checkOutTime = savedCheckOutString != null ? DateTime.tryParse(savedCheckOutString) : null;

    final rawKey = statusBox.get("currentRecordKey");
    if (rawKey is int) {
      currentRecordKey = rawKey;
    } else if (rawKey is String) {
      currentRecordKey = int.tryParse(rawKey);
    }

    emit(state.copyWith(status: savedStatus, checkInTime: checkInTime, checkOutTime: checkOutTime));
  }

  Future<void> _init() async {
    try {
      final records = await repository.getAllRecords();
      final savedStatusString = statusBox.get("status", defaultValue: "inactive");
      final savedStatus = savedStatusString == "active" ? AttendanceStatus.active : AttendanceStatus.inactive;
      final savedCheckInString = statusBox.get("checkIn");
      
      DateTime? checkInTime = savedCheckInString != null ? DateTime.tryParse(savedCheckInString) : null;

      emit(state.copyWith(records: records, status: savedStatus, checkInTime: checkInTime));
    } catch (e) {
      print('خطأ في التهيئة: $e');
    }
  }

  Future<void> loadAllRecords() async {
    try {
      final records = await repository.getAllRecords();
      emit(state.copyWith(records: records));
    } catch (e) {
      print("خطأ في تحميل السجلات: $e");
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
  }) async {
    try {
      emit(state.copyWith(errorMessage: null, isLocationLoading: true));

      final workshopsResult = await workshopRepository.getWorkshops();
      String workshopName = "ورشة رقم $workshopNumber";
      
      workshopsResult.fold(
        (failure) => throw failure.message,
        (workshops) {
          final currentWorkshop = workshops.firstWhere(
            (w) => w.id == workshopNumber.toString(),
            orElse: () => throw 'الورشة المحددة غير موجودة أو غير متاحة لك.',
          );
          workshopName = currentWorkshop.name;
        }
      );

      final now = DateTime.now();
      final user = await authRepository.getCurrentUser();
      final userName = user?.fullName ?? "الموظف";

      await statusBox.put("status", "active");
      await statusBox.put("checkIn", now.toIso8601String());

      final record = AttendanceRecord(
        day: day,
        date: date,
        workshopNumber: workshopNumber,
        checkInMillis: now.toIso8601String(), // 🔹 تم التعديل إلى String (ISO8601)
        checkOutMillis: null,
        weekNumber: weekNumber,
        startDate: startDate,
        endDate: endDate,
        note: note,
        syncStatus: 'pending',
      );

      final key = await repository.addRecord(record);
      currentRecordKey = key;
      await statusBox.put("currentRecordKey", key);

      await loadAllRecords();

      await NotificationService().showNotification(
        title: "تم تسجيل الحضور ✅",
        body: "أهلاً $userName، تم تسجيل حضورك في $workshopName بنجاح.",
      );

      notificationBloc?.add(AddLocalNotificationEvent(NotificationModel(
        id: "checkin_${now.millisecondsSinceEpoch}",
        title: "تسجيل حضور",
        body: "قام $userName بتسجيل الحضور في $workshopName بتاريخ $date",
        createdAt: now,
        type: 'attendance',
        isRead: false,
      )));

      emit(state.copyWith(
        status: AttendanceStatus.active, 
        checkInTime: now, 
        checkOutTime: null,
        isLocationLoading: false
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
        isLocationLoading: false
      ));
    }
  }

  Future<void> checkOut() async {
    try {
      final now = DateTime.now();
      final user = await authRepository.getCurrentUser();
      final userName = user?.fullName ?? "الموظف";

      await statusBox.put("status", "inactive");
      await statusBox.put("checkOut", now.toIso8601String());

      if (currentRecordKey != null) {
        await repository.updateCheckOut(currentRecordKey!, now);
        await statusBox.delete("currentRecordKey");
        currentRecordKey = null;
      }

      await loadAllRecords();

      await NotificationService().showNotification(
        title: "تم تسجيل الانصراف 👋",
        body: "وداعاً $userName، تم تسجيل انصرافك بنجاح. يومك سعيد!",
      );

      notificationBloc?.add(AddLocalNotificationEvent(NotificationModel(
        id: "checkout_${now.millisecondsSinceEpoch}",
        title: "تسجيل انصراف",
        body: "تم تسجيل انصراف $userName بنجاح في تمام الساعة ${DateFormat('HH:mm').format(now)}",
        createdAt: now,
        type: 'attendance',
        isRead: false,
      )));

      emit(state.copyWith(status: AttendanceStatus.inactive, checkOutTime: now));
    } catch (e) {
      print("خطأ في checkOut: $e");
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
      emit(state.copyWith(errorMessage: "فشل في مزامنة البيانات: ${e.toString()}"));
    } finally {
      emit(state.copyWith(isSyncing: false));
    }
  }

  Future<void> clearAllRecords() async {
    try {
      await repository.clearAll();
      await statusBox.delete("currentRecordKey");
      currentRecordKey = null;
      emit(state.copyWith(records: []));
    } catch (e) {
      print("خطأ في clearAllRecords: $e");
    }
  }
}
