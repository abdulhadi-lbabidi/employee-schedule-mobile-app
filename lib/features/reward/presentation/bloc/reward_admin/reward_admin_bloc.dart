import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled8/features/admin/domain/entities/employee_entity.dart';
import 'package:untitled8/features/admin/domain/usecases/get_all_employees.dart';
import 'package:untitled8/features/reward/domain/usecases/get_admin_rewards.dart';
import 'package:untitled8/features/reward/domain/usecases/issue_reward.dart';
import 'package:untitled8/features/reward/presentation/bloc/reward_admin/reward_admin_event.dart';
import 'package:untitled8/features/reward/presentation/bloc/reward_admin/reward_admin_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class RewardAdminBloc extends Bloc<RewardAdminEvent, RewardAdminState> {
  final GetAdminRewardsUseCase getAdminRewardsUseCase;
  final IssueRewardUseCase issueRewardUseCase;
  final GetAllEmployeesUseCase getAllEmployeesUseCase; // To get a list of employees for issuing rewards

  RewardAdminBloc({
    required this.getAdminRewardsUseCase,
    required this.issueRewardUseCase,
    required this.getAllEmployeesUseCase,
  }) : super(RewardAdminInitial()) {
    on<LoadAdminRewards>(_onLoadAdminRewards);
    on<IssueNewReward>(_onIssueNewReward);
  }

  Future<void> _onLoadAdminRewards(
    LoadAdminRewards event,
    Emitter<RewardAdminState> emit,
  ) async {
    emit(RewardAdminLoading());
    try {
      final rewards = await getAdminRewardsUseCase();
      emit(RewardAdminLoaded(rewards: rewards));
    } catch (e) {
      emit(RewardAdminError('فشل تحميل المكافآت: ${e.toString()}'));
    }
  }

  Future<void> _onIssueNewReward(
    IssueNewReward event,
    Emitter<RewardAdminState> emit,
  ) async {
    // Optionally, emit a loading state or keep the current loaded state while processing
    // If you want a loading indicator for the specific action:
    // emit(RewardAdminLoading()); // This would clear the loaded rewards

    try {
      await issueRewardUseCase(
        employeeId: event.employeeId,
        employeeName: event.employeeName,
        adminId: event.adminId,
        adminName: event.adminName,
        amount: event.amount,
        reason: event.reason,
      );
      emit(const RewardAdminActionSuccess('تم صرف المكافأة بنجاح.'));
      add(LoadAdminRewards()); // Refresh the list after issuing
    } catch (e) {
      emit(RewardAdminError('فشل صرف المكافأة: ${e.toString()}'));
      add(LoadAdminRewards()); // Re-load to show existing rewards even if action failed
    }
  }

  // Helper to fetch all employees (might be used by the UI for dropdowns)
  Future<List<EmployeeEntity>> fetchAllEmployees() async {
    try {
      return await getAllEmployeesUseCase();
    } catch (e) {
      print('Error fetching all employees: $e'); // Log the error
      return [];
    }
  }
}
