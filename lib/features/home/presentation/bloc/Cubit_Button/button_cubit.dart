import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'button_state.dart';

class ButtonCubit extends Cubit<ButtonState> {
  final Box statusBox;

  ButtonCubit({required this.statusBox})
    : super(ButtonState(isLoginEnabled: true, isLogoutEnabled: false)) {
    _syncWithStatus();
  }

  // مزامنة حالة الأزرار مع الحالة المخزنة عند التشغيل
  void _syncWithStatus() {
    final savedStatus = statusBox.get("status", defaultValue: "inactive");
    if (savedStatus == "active") {
      emit(state.copyWith(isLoginEnabled: false, isLogoutEnabled: true));
    }
  }

  void pressLogin() {
    emit(state.copyWith(isLoginEnabled: false, isLogoutEnabled: true, isPressed: true));
  }

  void pressLogout() {
    emit(state.copyWith(isLoginEnabled: true, isLogoutEnabled: false, isPressed: true));
  }

  void releaseButton() {
    emit(state.copyWith(isPressed: false));
  }
}
