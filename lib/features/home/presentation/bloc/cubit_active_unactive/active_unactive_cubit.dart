import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'active_unactive_state.dart';

class ActiveUnactiveCubit extends Cubit<ActiveUnactiveState> {
  final Box statusBox;

  ActiveUnactiveCubit({required this.statusBox}) : super(ActiveUnactiveState.initial()) {
    _loadPersistedStatus();
  }

  // استعادة الحالة من Hive عند تشغيل التطبيق
  void _loadPersistedStatus() {
    final savedStatus = statusBox.get("status", defaultValue: "inactive");
    final savedCheckIn = statusBox.get("checkIn");

    if (savedStatus == "active" && savedCheckIn != null) {
      emit(state.copyWith(
        status: ActiveUnactiveStatue.active,
        currentCheckInTime: DateTime.tryParse(savedCheckIn),
      ));
    }
  }

  void checkIn() {
    final now = DateTime.now();
    // الحفظ في Hive لضمان البقاء بعد الإغلاق
    statusBox.put("status", "active");
    statusBox.put("checkIn", now.toIso8601String());

    emit(state.copyWith(
      status: ActiveUnactiveStatue.active,
      currentCheckInTime: now,
      successMessage: "تم تسجيل الدخول",
    ));
  }

  void checkOut() {
    // تحديث Hive
    statusBox.put("status", "inactive");
    statusBox.delete("checkIn");

    emit(state.copyWith(
      status: ActiveUnactiveStatue.inactive,
      currentCheckOutTime: DateTime.now(),
      successMessage: "تم تسجيل الخروج",
    ));
  }

  void clearMessages() {
    emit(state.copyWith(
      successMessage: null,
      errorMessage: null,
    ));
  }
}
