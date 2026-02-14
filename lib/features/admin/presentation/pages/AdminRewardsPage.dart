import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:untitled8/features/reward/presentation/bloc/reward_admin/reward_admin_bloc.dart';
import 'package:untitled8/features/reward/presentation/bloc/reward_admin/reward_admin_event.dart';
import 'package:untitled8/features/reward/presentation/bloc/reward_admin/reward_admin_state.dart';
import '../widgets/issue_reward_dialog.dart';

class AdminRewardsPage extends StatefulWidget {
  const AdminRewardsPage({super.key});

  @override
  State<AdminRewardsPage> createState() => _AdminRewardsPageState();
}

class _AdminRewardsPageState extends State<AdminRewardsPage> {
  @override
  void initState() {
    super.initState();
    context.read<RewardAdminBloc>().add(LoadAdminRewards());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل المكافآت", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => context.read<RewardAdminBloc>().add(LoadAdminRewards()),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: BlocBuilder<RewardAdminBloc, RewardAdminState>(
        builder: (context, state) {
          if (state is RewardAdminLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RewardAdminLoaded) {
            final rewards = state.rewards;
            if (rewards.isEmpty) {
              return const Center(child: Text("لا يوجد سجل مكافآت حالياً"));
            }
            return ListView.builder(
              itemCount: rewards.length,
              itemBuilder: (context, index) {
                final reward = rewards[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(reward.employeeName[0])),
                    title: Text(reward.employeeName),
                    subtitle: Text(reward.reason),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${reward.amount} \$", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        Text(DateFormat('yyyy-MM-dd').format(reward.dateIssued), style: TextStyle(fontSize: 10.sp)),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is RewardAdminError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRewardDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddRewardDialog(BuildContext context) {
    // هذه الصفحة غالباً ما تُفتح من قائمة الموظفين لاختيار موظف معين
    // للتجربة سأفتح الـ Dialog بموظف افتراضي أو يفضل اختيار موظف من القائمة أولاً
    showDialog(
      context: context,
      builder: (context) => const IssueRewardDialog(
         adminId: '1', adminName: "اسم الموظف", // استبدل باسم الموظف المختار
      ),
    );
  }
}
