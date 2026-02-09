import 'package:equatable/equatable.dart';
import 'package:untitled8/features/employee/domain/entities/employee_summary_entity.dart';

abstract class EmployeeSummaryState extends Equatable {
  const EmployeeSummaryState();

  @override
  List<Object> get props => [];
}

class EmployeeSummaryInitial extends EmployeeSummaryState {}

class EmployeeSummaryLoading extends EmployeeSummaryState {}

class EmployeeSummaryLoaded extends EmployeeSummaryState {
  final EmployeeSummaryEntity summary;
  const EmployeeSummaryLoaded(this.summary);

  @override
  List<Object> get props => [summary];
}

class EmployeeSummaryError extends EmployeeSummaryState {
  final String message;
  const EmployeeSummaryError(this.message);

  @override
  List<Object> get props => [message];
}
