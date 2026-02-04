import 'package:untitled8/features/Attendance/data/models/attendance_model.dart';

import '../../../../admin/domain/entities/workshop_entity.dart';

class DropdownState {
  final WorkshopEntity? selectedValue;
  final AttendanceModel? localeAttendanceModel;
  final AttendanceModel? setLocaleAttendanceForLogOut;

  DropdownState({
    this.selectedValue,
    this.localeAttendanceModel,
    this.setLocaleAttendanceForLogOut,
  });

  DropdownState copyWith({
    Object? selectedValue = _unset,
    Object? localeAttendanceModel = _unset,
    Object? setLocaleAttendanceForLogOut = _unset,
  }) {
    return DropdownState(
      selectedValue: identical(selectedValue, _unset)
          ? this.selectedValue
          : selectedValue as WorkshopEntity?,
      localeAttendanceModel: identical(localeAttendanceModel, _unset)
          ? this.localeAttendanceModel
          : localeAttendanceModel as AttendanceModel?,
      setLocaleAttendanceForLogOut: identical(setLocaleAttendanceForLogOut, _unset)
          ? this.setLocaleAttendanceForLogOut
          : setLocaleAttendanceForLogOut as AttendanceModel?,
    );
  }
}

const _unset = Object();
