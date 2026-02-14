part of 'attendance_bloc.dart';

sealed class AttendanceEvent {}


class GetAllAttendanceEvent extends AttendanceEvent{
  final bool isAfterSync;
  final GetEmployeeAttendanceParams params;

  GetAllAttendanceEvent({ this.isAfterSync=false,required this.params});
}

class SyncAttendanceEvent extends AttendanceEvent{

}

class GetLocaleAttendanceEvent extends AttendanceEvent{}


class AddToLocaleAttendanceEvent extends AttendanceEvent{
  final AttendanceModel attendanceModel;
  final String weekNumber;

  AddToLocaleAttendanceEvent({required this.attendanceModel, required this.weekNumber});

}

class PatchLocaleAttendanceEvent extends AttendanceEvent{
  final AttendanceModel attendanceModel;

  PatchLocaleAttendanceEvent({required this.attendanceModel});
}

class InitLocaleAttendanceEvent extends AttendanceEvent{}