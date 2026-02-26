import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../bloc/penalty_bloc.dart';
import '../widgets/issue_penalty_dialog.dart';

class AdminPenaltiesPage extends StatefulWidget {
  const AdminPenaltiesPage({super.key});

  @override
  State<AdminPenaltiesPage> createState() => _AdminPenaltiesPageState();
}

class _AdminPenaltiesPageState extends State<AdminPenaltiesPage> {
  @override
  void initState() {
    super.initState();
    context.read<PenaltyBloc>().add(LoadAllPenalties());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("سجل الخصومات", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.read<PenaltyBloc>().add(LoadAllPenalties()),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showIssuePenaltyDialog(context),
        label: const Text("إضافة خصم", style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_circle_outline),
        backgroundColor: Colors.redAccent,
      ).animate().scale(delay: 400.ms),
      body: BlocBuilder<PenaltyBloc, PenaltyState>(
        builder: (context, state) {
          return state.penalties.builder(
            onSuccess: (list) {
              if (list.isEmpty) return _buildEmptyState(theme);
              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final penalty = list[index];
                  return _buildPenaltyCard(penalty, theme).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1, end: 0);
                },
              );
            },
            loadingWidget: const Center(child: CircularProgressIndicator()),
            failedWidget: Center(child: Text(state.penalties.errorMessage)),
          );
        },
      ),
    );
  }

  Widget _buildPenaltyCard(dynamic penalty, ThemeData theme) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red.withOpacity(0.1),
              child: const Icon(Icons.gavel_rounded, color: Colors.red),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(penalty.employeeName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
                        child: Text(penalty.workshopName ?? 'غير محدد', style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(penalty.reason, style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600)),
                  SizedBox(height: 4.h),
                  Text(DateFormat('yyyy-MM-dd').format(penalty.dateIssued), style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
                ],
              ),
            ),
            Text("${penalty.amount.toStringAsFixed(0)} \$", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.sp, color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.gavel_rounded, size: 60.sp, color: Colors.grey.shade300),
        SizedBox(height: 16.h),
        Text("لا توجد خصومات مسجلة حالياً", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
      ],
    ),
  );

  void _showIssuePenaltyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<PenaltyBloc>(),
        child: const IssuePenaltyDialog(),
      ),
    );
  }
}
