import 'package:equatable/equatable.dart';
import 'package:untitled8/features/reward/domain/entities/reward_entity.dart';

abstract class RewardEmployeeState extends Equatable {
  const RewardEmployeeState();

  @override
  List<Object> get props => [];
}

class RewardEmployeeInitial extends RewardEmployeeState {}

class RewardEmployeeLoading extends RewardEmployeeState {}

class RewardEmployeeLoaded extends RewardEmployeeState {
  final List<RewardEntity> rewards;

  const RewardEmployeeLoaded({required this.rewards});

  @override
  List<Object> get props => [rewards];
}

class RewardEmployeeError extends RewardEmployeeState {
  final String message;

  const RewardEmployeeError(this.message);

  @override
  List<Object> get props => [message];
}
