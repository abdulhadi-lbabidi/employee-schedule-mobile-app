import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

abstract class RewardAdminEvent extends Equatable {
  const RewardAdminEvent();

  @override
  List<Object> get props => [];
}

class LoadAdminRewards extends RewardAdminEvent {}

class IssueRewardEvent extends RewardAdminEvent {
  final int employeeId;
  final int adminId;
  final double amount;
  final String reason;
  final String  date;

  const IssueRewardEvent({
    required this.employeeId,
    required this.adminId,
    required this.amount,
    required this.reason,
    required this.date,
  });

  @override
  List<Object> get props => [employeeId, adminId, amount, reason,date];
}
