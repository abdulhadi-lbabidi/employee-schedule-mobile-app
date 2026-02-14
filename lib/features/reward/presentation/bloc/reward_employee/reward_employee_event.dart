import 'package:equatable/equatable.dart';

abstract class RewardEmployeeEvent extends Equatable {
  const RewardEmployeeEvent();

  @override
  List<Object> get props => [];
}

class LoadEmployeeRewards extends RewardEmployeeEvent {
  final int employeeId; // Changed from String to int

  const LoadEmployeeRewards(this.employeeId);

  @override
  List<Object> get props => [employeeId];
}
