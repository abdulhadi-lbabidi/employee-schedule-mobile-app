import 'package:equatable/equatable.dart';

abstract class RewardAdminEvent extends Equatable {
  const RewardAdminEvent();

  @override
  List<Object> get props => [];
}

class LoadAdminRewards extends RewardAdminEvent {}

class IssueNewReward extends RewardAdminEvent {
  final String employeeId;
  final String employeeName;
  final String adminId;
  final String adminName;
  final double amount;
  final String reason;

  const IssueNewReward({
    required this.employeeId,
    required this.employeeName,
    required this.adminId,
    required this.adminName,
    required this.amount,
    required this.reason,
  });

  @override
  List<Object> get props => [employeeId, employeeName, adminId, adminName, amount, reason];
}
