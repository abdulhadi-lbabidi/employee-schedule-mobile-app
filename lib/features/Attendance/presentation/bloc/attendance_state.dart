part of 'attendance_bloc.dart';


class AttendanceState {
  final DataStateModel<GetAttendanceResponse?> getAllAttendanceData;
  final DataStateModel<GetAttendanceResponse?> syncAttendanceData;
  final List<AttendanceModel> localeAttendanceList;
  final List<AttendanceModel> localeTodayAttendanceList;


  const AttendanceState({
    this.getAllAttendanceData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.syncAttendanceData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.localeAttendanceList=const[],
    this.localeTodayAttendanceList=const[]


  });

  AttendanceState copyWith({
     DataStateModel<GetAttendanceResponse?>? getAllAttendanceData,
     DataStateModel<GetAttendanceResponse?>? syncAttendanceData,
     List<AttendanceModel>? localeAttendanceList,
     List<AttendanceModel>? localeTodayAttendanceList,


  }) {
    return AttendanceState(
      getAllAttendanceData: getAllAttendanceData ?? this.getAllAttendanceData,
      syncAttendanceData: syncAttendanceData ?? this.syncAttendanceData,
      localeAttendanceList: localeAttendanceList ?? this.localeAttendanceList,
      localeTodayAttendanceList: localeTodayAttendanceList ?? this.localeTodayAttendanceList,

    );
  }
}

