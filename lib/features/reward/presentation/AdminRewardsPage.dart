import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../data/models/get_all_rewards.dart';
import 'bloc/reward_admin/reward_admin_bloc.dart';
import 'bloc/reward_admin/reward_admin_event.dart';
import 'bloc/reward_admin/reward_admin_state.dart';
import 'issue_reward_dialog.dart';

class AdminRewardsPage extends StatefulWidget {
  const AdminRewardsPage({super.key});

  @override
  State<AdminRewardsPage> createState() => _AdminRewardsPageState();
}

class _AdminRewardsPageState extends State<AdminRewardsPage> {
  @override
  void initState() {
    super.initState();
    _fetchRewards();
  }

  void _fetchRewards() {
    context.read<RewardAdminBloc>().add(LoadAdminRewards());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل مكافآت الموظفين"),
        centerTitle: true,
        elevation: 0,
      ),
      // القائمة الرئيسية
      body: BlocBuilder<RewardAdminBloc, RewardAdminState>(
        builder: (context, state) {
          if (state is RewardAdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RewardAdminLoaded) {
            final rewardsList = state.rewards.reversed.toList();
            if (rewardsList.isEmpty) {
              return const Center(child: Text("لا توجد مكافآت حالياً"));
            }

            return RefreshIndicator(
              onRefresh: () async => _fetchRewards(),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                itemCount: rewardsList.length,
                itemBuilder: (context, index) => _buildRewardCard(rewardsList[index], theme),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),

      // إعادة زر إضافة المكافأة الضائع!
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {
          showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<RewardAdminBloc>(),
              child: const IssueRewardDialog(),
            ),
          ),
        },
        backgroundColor: theme.primaryColor,
        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
        label: const Text("صرف مكافأة", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- واجهة إضافة مكافأة جديدة ---


  Widget _buildRewardCard(Rewards item, ThemeData theme) {
    final isDarkMode = theme.brightness == Brightness.dark;
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      elevation: 0,
      color: isDarkMode ? theme.cardColor : Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "${item.amount ?? '0'}\$",
                    style: TextStyle(
                      color: isDarkMode ? Colors.greenAccent : Colors.green[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                Text(
                  item.dateIssued != null ? DateFormat('yyyy-MM-dd').format(item.dateIssued!) : "---",
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text("السبب:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
            SizedBox(height: 4.h),
            Text(
              item.reason ?? "لم يتم ذكر السبب",
              style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: 13.sp),
            ),
            const Divider(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "بواسطة: ${item.adminName ?? 'غير محدد'}",
                style: TextStyle(fontSize: 11.sp, color: theme.primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}