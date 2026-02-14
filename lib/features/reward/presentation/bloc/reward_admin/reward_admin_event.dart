import 'package:equatable/equatable.dart';

abstract class RewardAdminEvent extends Equatable {
  const RewardAdminEvent();

  @override
  List<Object> get props => [];
}

class LoadAdminRewards extends RewardAdminEvent {}

class IssueRewardEvent extends RewardAdminEvent {
  final int employeeId;
  final String employeeName;
  final double amount;
  final String reason;

  const IssueRewardEvent({
    required this.employeeId,
    required this.employeeName,
    required this.amount,
    required this.reason,
  });

  @override
  List<Object> get props => [employeeId, employeeName, amount, reason];
}
