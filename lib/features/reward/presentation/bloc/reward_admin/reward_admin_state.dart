import 'package:equatable/equatable.dart';
import 'package:untitled8/features/reward/domain/entities/reward_entity.dart';

import '../../../data/models/get_all_rewards.dart';

abstract class RewardAdminState extends Equatable {
  const RewardAdminState();

  @override
  List<Object> get props => [];
}

class RewardAdminInitial extends RewardAdminState {}

class RewardAdminLoading extends RewardAdminState {}

class RewardAdminLoaded extends RewardAdminState {
  final List<Rewards> rewards;

  const RewardAdminLoaded({required this.rewards});

  @override
  List<Object> get props => [rewards];
}

class RewardAdminError extends RewardAdminState {
  final String message;

  const RewardAdminError(this.message);

  @override
  List<Object> get props => [message];
}

class RewardAdminActionSuccess extends RewardAdminState {
  final String message;

  const RewardAdminActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}
