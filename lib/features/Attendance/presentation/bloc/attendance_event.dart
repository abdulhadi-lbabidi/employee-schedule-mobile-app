part of 'attendance_bloc.dart';

sealed class AttendanceEvent {}


class GetAllAttendanceEvent extends AttendanceEvent{
  final bool isAfterSync;

  GetAllAttendanceEvent({ this.isAfterSync=false});
}

class SyncAttendanceEvent extends AttendanceEvent{

}

class GetLocaleAttendanceEvent extends AttendanceEvent{}


class AddToLocaleAttendanceEvent extends AttendanceEvent{
  final AttendanceModel attendanceModel;

  AddToLocaleAttendanceEvent({required this.attendanceModel});
}

class PatchLocaleAttendanceEvent extends AttendanceEvent{
  final AttendanceModel attendanceModel;

  PatchLocaleAttendanceEvent({required this.attendanceModel});
}

class InitLocaleAttendanceEvent extends AttendanceEvent{}