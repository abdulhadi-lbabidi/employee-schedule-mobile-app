import 'package:equatable/equatable.dart';

abstract class UnpaidWeeksEvent extends Equatable {
  const UnpaidWeeksEvent();
  @override
  List<Object?> get props => [];
}

class LoadUnpaidWeeks extends UnpaidWeeksEvent {
  final String employeeId;
  const LoadUnpaidWeeks(this.employeeId);

  @override
  List<Object?> get props => [employeeId];
}