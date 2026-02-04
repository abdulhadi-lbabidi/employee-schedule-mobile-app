import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/hive_service.dart';
import 'button_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ButtonCubit extends Cubit<ButtonState> {
  final HiveService _hiveService;

  ButtonCubit(this._hiveService)
      : super(ButtonState(isLoginEnabled: true, isLogoutEnabled: false)) {
    _syncWithStatus();
  }

  /// مزامنة حالة الأزرار مع الحالة المخزنة عند التشغيل
  Future<void> _syncWithStatus() async {
    final statusBox = await _hiveService.attendanceStatusBox;
    final savedStatus = statusBox.get("status", defaultValue: "inactive");

    if (savedStatus == "active") {
      emit(state.copyWith(isLoginEnabled: false, isLogoutEnabled: true));
    } else {
      emit(state.copyWith(isLoginEnabled: true, isLogoutEnabled: false));
    }
  }

  /// عند الضغط على زر تسجيل الدخول
  Future<void> pressLogin() async {
    final statusBox = await _hiveService.attendanceStatusBox;
    await statusBox.put("status", "active");

    emit(state.copyWith(
      isLoginEnabled: false,
      isLogoutEnabled: true,
      isPressed: true,
    ));
  }

  /// عند الضغط على زر تسجيل الخروج
  Future<void> pressLogout() async {
    final statusBox = await _hiveService.attendanceStatusBox;
    await statusBox.put("status", "inactive");

    emit(state.copyWith(
      isLoginEnabled: true,
      isLogoutEnabled: false,
      isPressed: true,
    ));
  }

  /// عند رفع الإصبع عن الزر (Reset)
  void releaseButton() {
    emit(state.copyWith(isPressed: false));
  }
}
