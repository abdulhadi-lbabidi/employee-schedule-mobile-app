import 'package:equatable/equatable.dart';

abstract class EmployeeSummaryEvent extends Equatable {
  const EmployeeSummaryEvent();

  @override
  List<Object> get props => [];
}

class LoadEmployeeSummaryEvent extends EmployeeSummaryEvent {
  final String employeeId;
  const LoadEmployeeSummaryEvent(this.employeeId);

  @override
  List<Object> get props => [employeeId];
}
