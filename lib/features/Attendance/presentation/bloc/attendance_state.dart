part of 'attendance_bloc.dart';


class AttendanceState {
  final DataStateModel<List<GetAttendanceResponse>?> getAllAttendanceData;
  final DataStateModel<SyncAttendanceResponse?> syncAttendanceData;
  final List<GetAttendanceResponse> localeAttendanceList;
  final List<AttendanceModel> localeTodayAttendanceList;
  final double? totalHours;
  final double? totalSalery;


  const AttendanceState({
    this.totalHours=0,
    this.totalSalery=0,
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
     DataStateModel<List<GetAttendanceResponse>?>? getAllAttendanceData,
     DataStateModel<SyncAttendanceResponse?>? syncAttendanceData,
    List<GetAttendanceResponse>? localeAttendanceList,
     List<AttendanceModel>? localeTodayAttendanceList,
     double? totalHours,
     double? totalSalery,

  }) {
    return AttendanceState(
      totalHours:totalHours??this.totalHours,
      totalSalery:totalSalery??this.totalSalery,
      getAllAttendanceData: getAllAttendanceData ?? this.getAllAttendanceData,
      syncAttendanceData: syncAttendanceData ?? this.syncAttendanceData,
      localeAttendanceList: localeAttendanceList ?? this.localeAttendanceList,
      localeTodayAttendanceList: localeTodayAttendanceList ?? this.localeTodayAttendanceList,

    );
  }
}

