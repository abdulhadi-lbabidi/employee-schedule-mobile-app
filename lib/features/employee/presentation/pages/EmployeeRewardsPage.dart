import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../../../core/di/injection.dart';
import '../../../reward/presentation/bloc/reward_employee/reward_employee_bloc.dart';
import '../../../reward/presentation/bloc/reward_employee/reward_employee_event.dart';
import '../../../reward/presentation/bloc/reward_employee/reward_employee_state.dart';

class EmployeeRewardsPage extends StatelessWidget {
  final int employeeId;

  const EmployeeRewardsPage({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) =>
      sl<RewardEmployeeBloc>()..add(LoadEmployeeRewards(employeeId)),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            "مكافآتي",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context
                    .read<RewardEmployeeBloc>()
                    .add(LoadEmployeeRewards(employeeId)),
              ),
            ),
          ],
        ),
        body: BlocBuilder<RewardEmployeeBloc, RewardEmployeeState>(
          builder: (context, state) {
            /// ===== Loading =====
            if (state is RewardEmployeeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            /// ===== Loaded =====
            else if (state is RewardEmployeeLoaded) {
              if (state.rewards.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.workspace_premium_rounded,
                          size: 80.sp, color: Colors.grey.shade300),
                      SizedBox(height: 16.h),
                      Text(
                        "لم تحصل على مكافآت بعد، استمر في العمل الجيد!",
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(color: Colors.grey, fontSize: 14.sp),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => context
                    .read<RewardEmployeeBloc>()
                    .add(LoadEmployeeRewards(employeeId)),
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: state.rewards.length,
                  itemBuilder: (context, index) {
                    final reward = state.rewards[index];
                    final theme = Theme.of(context);

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        gradient: LinearGradient(
                          colors: [
                            theme.cardColor,
                            theme.cardColor.withOpacity(0.85),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// ===== Header =====
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        color:
                                        Colors.amber.withOpacity(0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.stars_rounded,
                                        color: Colors.amber.shade800,
                                        size: 18.sp,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      "مكافأة مالية",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),

                                /// 💰 Amount pill
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color:
                                    Colors.green.withOpacity(0.12),
                                    borderRadius:
                                    BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    "${NumberFormat.decimalPattern().format(reward.amount)} \$",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 14.h),

                            /// ===== Reason =====
                            Directionality(
                              textDirection: _isArabic(reward.reason)
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: Text(
                                reward.reason,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: theme.textTheme.bodyMedium?.color,
                                  height: 1.6,
                                ),
                              ),
                            ),

                            SizedBox(height: 14.h),
                            Divider(color: Colors.grey.withOpacity(0.2)),
                            SizedBox(height: 8.h),

                            /// ===== Footer =====
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person_outline,
                                        size: 14.sp,
                                        color: Colors.grey),
                                    SizedBox(width: 5.w),
                                    Text(
                                      "بواسطة: ${reward.adminName ?? 'الإدارة'}",
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                        Icons
                                            .calendar_today_outlined,
                                        size: 14.sp,
                                        color: Colors.grey),
                                    SizedBox(width: 5.w),
                                    Text(
                                      DateFormat('yyyy/MM/dd')
                                          .format(reward.dateIssued),
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
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
            }

            /// ===== Error =====
            else if (state is RewardEmployeeError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
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