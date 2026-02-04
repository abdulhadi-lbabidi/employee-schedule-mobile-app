import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled8/features/reward/domain/usecases/get_employee_rewards.dart';
import 'package:untitled8/features/reward/presentation/bloc/reward_employee/reward_employee_event.dart';
import 'package:untitled8/features/reward/presentation/bloc/reward_employee/reward_employee_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class RewardEmployeeBloc extends Bloc<RewardEmployeeEvent, RewardEmployeeState> {
  final GetEmployeeRewardsUseCase getEmployeeRewardsUseCase;

  RewardEmployeeBloc({
    required this.getEmployeeRewardsUseCase,
  }) : super(RewardEmployeeInitial()) {
    on<LoadEmployeeRewards>(_onLoadEmployeeRewards);
  }

  Future<void> _onLoadEmployeeRewards(
    LoadEmployeeRewards event,
    Emitter<RewardEmployeeState> emit,
  ) async {
    emit(RewardEmployeeLoading());
    try {
      final rewards = await getEmployeeRewardsUseCase(event.employeeId);
      emit(RewardEmployeeLoaded(rewards: rewards));
    } catch (e) {
      emit(RewardEmployeeError('فشل تحميل المكافآت: ${e.toString()}'));
    }
  }
}
