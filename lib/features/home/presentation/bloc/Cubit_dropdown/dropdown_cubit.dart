import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled8/common/helper/src/app_varibles.dart';
import 'package:untitled8/features/Attendance/data/models/attendance_model.dart';
import 'package:untitled8/features/admin/data/models/workshop_models/workshop_model.g.dart';
import 'dropdown_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class DropdownCubit extends Cubit<DropdownState> {
  DropdownCubit() : super(DropdownState());

  /// تغيير القيمة المختارة (اسم الورشة)
  void changeValue(WorkshopModel newValue) {
    emit(state.copyWith(selectedValue: newValue));
  }

  void initDropDown() {
    emit(
      state.copyWith(
        selectedValue: AppVariables.selectedWorkShop,
        localeAttendanceModel: AppVariables.localeAttendance,
      ),
    );
  }

  void clearSelected() {
    AppVariables.clearSelectedWorkShop();
    AppVariables.clearLocaleAttendance();
    emit(state.copyWith(selectedValue: null, localeAttendanceModel: null));
  }

  void clearSelected2() {
    emit(state.copyWith(setLocaleAttendanceForLogOut: null));
  }

  void changeAttendance({
    required AttendanceModel newValue,
    required WorkshopModel workshopEntity,
  })
  {
    AppVariables.localeAttendance = newValue;
    AppVariables.selectedWorkShop = workshopEntity;


    emit(
      state.copyWith(
        localeAttendanceModel: newValue,
        setLocaleAttendanceForLogOut: newValue,
        selectedValue: workshopEntity,
      ),
    );
  }
}
