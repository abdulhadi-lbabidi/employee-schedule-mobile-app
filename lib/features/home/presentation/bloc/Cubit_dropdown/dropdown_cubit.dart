import 'package:flutter_bloc/flutter_bloc.dart';
import 'dropdown_state.dart';

class DropdownCubit extends Cubit<DropdownState> {
  // لم يعد هذا الـ Cubit مسؤولاً عن جلب الورشات، لذا يمكن إزالة getWorkshopsUseCase
  DropdownCubit() : super(DropdownState(selectedValue: null));

  /// تغيير القيمة المختارة (اسم الورشة)
  void changeValue(String newValue) {
    emit(DropdownState(selectedValue: newValue));
  }

  /// إعادة تعيين الـ Dropdown
  void reset() {
    print('🔄 Dropdown Reset');
    emit(DropdownState(selectedValue: null));
  }

  /// الحصول على القيمة المختارة الحالية
  String? getSelectedValue() {
    return state.selectedValue;
  }

  /// التحقق من وجود قيمة مختارة
  bool hasSelectedValue() {
    return state.selectedValue != null && state.selectedValue!.isNotEmpty;
  }
}
