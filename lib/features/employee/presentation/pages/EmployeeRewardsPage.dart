import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' hide TextDirection; // تم إخفاء TextDirection لتجنب التعارض
import '../../../../core/di/injection.dart';
import '../../../reward/presentation/bloc/reward_employee/reward_employee_bloc.dart';
import '../../../reward/presentation/bloc/reward_employee/reward_employee_event.dart';
import '../../../reward/presentation/bloc/reward_employee/reward_employee_state.dart';

class EmployeeRewardsPage extends StatelessWidget {
  final int employeeId;

  const EmployeeRewardsPage({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RewardEmployeeBloc>()..add(LoadEmployeeRewards(employeeId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text("مكافآتي", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<RewardEmployeeBloc>().add(LoadEmployeeRewards(employeeId)),
              ),
            ),
          ],
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
              return RefreshIndicator(
                onRefresh: () async => context.read<RewardEmployeeBloc>().add(LoadEmployeeRewards(employeeId)),
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: state.rewards.length,
                  itemBuilder: (context, index) {
                    final reward = state.rewards[index];
                    return Card(
                      elevation: 3,
                      shadowColor: Colors.black12,
                      margin: EdgeInsets.only(bottom: 16.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: Colors.white60,
                        ),
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.stars, color: Colors.amber.shade700, size: 20.sp),
                                    SizedBox(width: 8.w),
                                    Text("مكافأة مالية", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
                                  ],
                                ),
                                Text("${NumberFormat.decimalPattern().format(reward.amount)}\$",
                                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Directionality(
                              textDirection: _isArabic(reward.reason) ? TextDirection.rtl : TextDirection.ltr,
                              child: Text(
                                reward.reason,
                                style: TextStyle(fontSize: 14.sp, color: Colors.black87, height: 1.5),
                              ),
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person_outline, size: 14.sp, color: Colors.grey),
                                    SizedBox(width: 4.w),
                                    Text("بواسطة: ${reward.adminName ?? 'الإدارة'}", style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_outlined, size: 14.sp, color: Colors.grey),
                                    SizedBox(width: 4.w),
                                    Text(DateFormat('yyyy/MM/dd').format(reward.dateIssued),
                                        style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is RewardEmployeeError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  bool _isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}
