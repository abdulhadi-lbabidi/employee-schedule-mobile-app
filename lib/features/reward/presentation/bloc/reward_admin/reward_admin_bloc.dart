import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/get_admin_rewards.dart';
import '../../../domain/usecases/issue_reward.dart';
import 'reward_admin_event.dart';
import 'reward_admin_state.dart';

@injectable
class RewardAdminBloc extends Bloc<RewardAdminEvent, RewardAdminState> {
  final GetAdminRewardsUseCase getAdminRewardsUseCase;
  final IssueRewardUseCase issueRewardUseCase;

  RewardAdminBloc({
    required this.getAdminRewardsUseCase,
    required this.issueRewardUseCase,
  }) : super(RewardAdminInitial()) {
    on<LoadAdminRewards>(_onLoadAdminRewards);
    on<IssueRewardEvent>(_onIssueReward);
  }

  Future<void> _onLoadAdminRewards(
    LoadAdminRewards event,
    Emitter<RewardAdminState> emit,
  ) async {
    emit(RewardAdminLoading());
    final result = await getAdminRewardsUseCase();
    print('result: $result');
    result.fold(
      (failure) => emit(RewardAdminError(failure.message)),
      (rewards) => emit(RewardAdminLoaded(rewards: rewards)),
    );
  }

  Future<void> _onIssueReward(
    IssueRewardEvent event,
    Emitter<RewardAdminState> emit,
  ) async {
    emit(RewardAdminLoading());
    final result = await issueRewardUseCase(
      employeeId: event.employeeId,
      amount: event.amount,
      reason: event.reason,
    );
    result.fold(
      (failure) => emit(RewardAdminError(failure.message)),
      (_) => add(LoadAdminRewards()),
    );
  }
}
