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
    
    final result = await getEmployeeRewardsUseCase(event.employeeId); // employeeId is already an int in the event
    
    result.fold(
      (failure) => emit(RewardEmployeeError('فشل تحميل المكافآت: ${failure.message}')),
      (rewards) => emit(RewardEmployeeLoaded(rewards: rewards)),
    );
  }
}
