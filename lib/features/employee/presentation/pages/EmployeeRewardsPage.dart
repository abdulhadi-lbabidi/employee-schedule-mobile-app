import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../../reward/presentation/bloc/reward_employee/reward_employee_bloc.dart';
import '../../../reward/presentation/bloc/reward_employee/reward_employee_event.dart';
import '../../../reward/presentation/bloc/reward_employee/reward_employee_state.dart';

class EmployeeRewardsPage extends StatelessWidget {
  final String employeeId;

  const EmployeeRewardsPage({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RewardEmployeeBloc>()..add(LoadEmployeeRewards(employeeId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text("مكافآتي", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: BlocBuilder<RewardEmployeeBloc, RewardEmployeeState>(
          builder: (context, state) {
            if (state is RewardEmployeeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RewardEmployeeLoaded) {
              if (state.rewards.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.card_giftcard, size: 80.sp, color: Colors.grey.shade300),
                      SizedBox(height: 16.h),
                      Text("لم تحصل على مكافآت بعد، استمر في العمل الجيد!", 
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: state.rewards.length,
                itemBuilder: (context, index) {
                  final reward = state.rewards[index];
                  return Card(
                    elevation: 4,
                    shadowColor: Colors.amber.withOpacity(0.2),
                    margin: EdgeInsets.only(bottom: 16.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.amber.shade50.withOpacity(0.3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("مكافأة مالية", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
                              Text("${reward.amount.toStringAsFixed(0)} ل.س", 
                                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.green)),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(reward.reason, style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("بواسطة: ${reward.adminName}", style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
                              Text(DateFormat('yyyy/MM/dd').format(reward.dateIssued), 
                                style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is RewardEmployeeError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
