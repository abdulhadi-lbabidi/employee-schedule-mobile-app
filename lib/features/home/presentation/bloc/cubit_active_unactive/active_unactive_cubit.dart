import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/hive_service.dart';
import 'active_unactive_state.dart';
import 'package:injectable/injectable.dart';



@injectable
class ActiveUnactiveCubit extends Cubit<ActiveUnactiveState> {
  final HiveService _hiveService;

  ActiveUnactiveCubit(this._hiveService) : super(ActiveUnactiveState.initial()) {
    _loadPersistedStatus();
  }

  /// استعادة الحالة عند تشغيل التطبيق
  Future<void> _loadPersistedStatus() async {
    final statusBox = await _hiveService.attendanceStatusBox;

    final savedStatus = statusBox.get("status", defaultValue: "inactive");
    final savedCheckIn = statusBox.get("checkIn");

    if (savedStatus == "active" && savedCheckIn != null) {
      emit(state.copyWith(
        status: ActiveUnactiveStatue.active,
        currentCheckInTime: DateTime.tryParse(savedCheckIn),
      ));
    }
  }

  Future<void> checkIn() async {
    final statusBox = await _hiveService.attendanceStatusBox;
    final now = DateTime.now();

    await statusBox.put("status", "active");
    await statusBox.put("checkIn", now.toIso8601String());

    emit(state.copyWith(
      status: ActiveUnactiveStatue.active,
      currentCheckInTime: now,
      successMessage: "تم تسجيل الدخول",
    ));
  }

  Future<void> checkOut() async {
    final statusBox = await _hiveService.attendanceStatusBox;

    await statusBox.put("status", "inactive");
    await statusBox.delete("checkIn");

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
