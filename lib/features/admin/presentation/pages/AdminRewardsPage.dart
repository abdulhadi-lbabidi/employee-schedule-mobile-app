import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../../reward/presentation/bloc/reward_admin/reward_admin_bloc.dart';
import '../../../reward/presentation/bloc/reward_admin/reward_admin_event.dart';
import '../../../reward/presentation/bloc/reward_admin/reward_admin_state.dart';
import '../widgets/issue_reward_dialog.dart';

class AdminRewardsPage extends StatelessWidget {
  const AdminRewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RewardAdminBloc>()..add(LoadAdminRewards()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("سجل المكافآت الصادرة", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: BlocListener<RewardAdminBloc, RewardAdminState>(
          listener: (context, state) {
            if (state is RewardAdminActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green),
              );
            } else if (state is RewardAdminError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          child: BlocBuilder<RewardAdminBloc, RewardAdminState>(
            builder: (context, state) {
              if (state is RewardAdminLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RewardAdminLoaded) {
                if (state.rewards.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.card_giftcard, size: 80.sp, color: Colors.grey.shade300),
                        SizedBox(height: 16.h),
                        Text("لا يوجد مكافآت مسجلة حالياً", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
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
                      margin: EdgeInsets.only(bottom: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.amber.shade100,
                          child: Icon(Icons.star, color: Colors.amber.shade800),
                        ),
                        title: Text(reward.employeeName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(reward.reason, style: TextStyle(fontSize: 12.sp)),
                            Text(DateFormat('yyyy/MM/dd - hh:mm a').format(reward.dateIssued), 
                                 style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
                          ],
                        ),
                        trailing: Text("${reward.amount.toStringAsFixed(0)} ل.س", 
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 15.sp)),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (dContext) => BlocProvider.value(
                  value: context.read<RewardAdminBloc>(),
                  child: const IssueRewardDialog(
                    adminId: "admin_1", // يمكن جلبها من AuthCubit لاحقاً
                    adminName: "المدير العام",
                  ),
                ),
              );
            },
            label: const Text("صرف مكافأة",style: TextStyle(color: Colors.white,fontSize: 16),),
            icon: const Icon(Icons.add,color: Colors.white,),
            backgroundColor: Colors.indigo,
          ),
        ),
      ),
    );
  }
}
