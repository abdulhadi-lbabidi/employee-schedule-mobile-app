import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../bloc/penalty_bloc.dart';

class EmployeePenaltiesPage extends StatefulWidget {
  final int employeeId;
  const EmployeePenaltiesPage({super.key, required this.employeeId});

  @override
  State<EmployeePenaltiesPage> createState() => _EmployeePenaltiesPageState();
}

class _EmployeePenaltiesPageState extends State<EmployeePenaltiesPage> {
  @override
  void initState() {
    super.initState();
    context.read<PenaltyBloc>().add(LoadEmployeePenalties(widget.employeeId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("سجل خصم", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocBuilder<PenaltyBloc, PenaltyState>(
        builder: (context, state) {
          return state.penalties.builder(
            onSuccess: (list) {
              if (list.isEmpty) return _buildEmptyState(theme);
              return ListView.builder(
                padding: EdgeInsets.all(20.w),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final penalty = list[index];
                  return _buildPenaltyCard(penalty, theme)
                      .animate()
                      .fadeIn(delay: (index * 150).ms)
                      .slideY(begin: 0.1, end: 0);
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
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.red.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.02),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.gavel_rounded, color: Colors.red, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  penalty.reason,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                // 🔹 عرض اسم الورشة للموظف
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 12.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      penalty.workshopName ?? 'غير محدد',
                      style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  DateFormat('yyyy-MM-dd').format(penalty.dateIssued),
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            "- ${penalty.amount.toStringAsFixed(0)} \$",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16.sp,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sentiment_satisfied_alt_rounded, size: 60.sp, color: Colors.green.withOpacity(0.2)),
          SizedBox(height: 16.h),
          Text("سجلك نظيف! لا توجد عقوبات", style: TextStyle(color: Colors.grey, fontSize: 14.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
