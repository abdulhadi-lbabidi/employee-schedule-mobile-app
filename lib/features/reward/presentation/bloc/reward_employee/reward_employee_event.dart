import 'package:equatable/equatable.dart';

abstract class RewardEmployeeEvent extends Equatable {
  const RewardEmployeeEvent();

  @override
  List<Object> get props => [];
}

class LoadEmployeeRewards extends RewardEmployeeEvent {
  final String employeeId;

  const LoadEmployeeRewards(this.employeeId);

  @override
  List<Object> get props => [employeeId];
}
