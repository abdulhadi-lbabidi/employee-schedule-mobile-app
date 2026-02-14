import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/employee_summary_entity.dart';
import '../bloc/employee_summary/employee_summary_bloc.dart';
import '../bloc/employee_summary/employee_summary_event.dart';
import '../bloc/employee_summary/employee_summary_state.dart';

class EmployeeSummaryPage extends StatelessWidget {
  final String employeeId;

  const EmployeeSummaryPage({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) =>
          sl<EmployeeSummaryBloc>()..add(LoadEmployeeSummaryEvent(employeeId)),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'الكشف المالي',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context
                .read<EmployeeSummaryBloc>()
                .add(LoadEmployeeSummaryEvent(employeeId));
          },
          child: BlocBuilder<EmployeeSummaryBloc, EmployeeSummaryState>(
            builder: (context, state) {
              if (state is EmployeeSummaryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is EmployeeSummaryLoaded) {
                return _buildSummaryContent(state.summary, theme);
              } else if (state is EmployeeSummaryError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          color: Colors.red, size: 60.sp),
                      SizedBox(height: 16.h),
                      Text(state.message,
                          style: TextStyle(
                              color: Colors.red.shade700, fontSize: 16.sp)),
                      TextButton(
                        onPressed: () => context
                            .read<EmployeeSummaryBloc>()
                            .add(LoadEmployeeSummaryEvent(employeeId)),
                        child: const Text('إعادة المحاولة'),
                      )
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryContent(EmployeeSummaryEntity summary, ThemeData theme) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          _buildEmployeeHeader(summary, theme),
          SizedBox(height: 25.h),

          _buildSectionTitle('إحصائيات الساعات', Icons.timer_outlined, theme),
          SizedBox(height: 15.h),
          Row(
            children: [
              _buildStatCard(
                title: 'ساعات نظامية',
                value: summary.totalRegularHours.toStringAsFixed(1),
                unit: 'ساعة',
                icon: Icons.access_time_filled,
                color: Colors.blue,
                theme: theme,
              ),
              SizedBox(width: 15.w),
              _buildStatCard(
                title: 'ساعات إضافية',
                value: summary.totalOvertimeHours.toStringAsFixed(1),
                unit: 'ساعة',
                icon: Icons.more_time_rounded,
                color: Colors.orange,
                theme: theme,
              ),
            ],
          ),

          SizedBox(height: 25.h),
          _buildSectionTitle('المستحقات المالية', Icons.payments_outlined, theme),
          SizedBox(height: 15.h),
          _buildMoneyCard(
            title: 'الأجر الأساسي',
            amount: summary.regularPay,
            icon: Icons.account_balance_wallet_rounded,
            color: Colors.indigo,
            theme: theme,
          ),
          SizedBox(height: 12.h),
          _buildMoneyCard(
            title: 'أجر العمل الإضافي',
            amount: summary.overtimePay,
            icon: Icons.add_card_rounded,
            color: Colors.teal,
            theme: theme,
          ),

          SizedBox(height: 25.h),
          _buildTotalPayCard(summary.totalPay, theme),

          SizedBox(height: 25.h),
          _buildSectionTitle('الورشات', Icons.workspaces_outline, theme),
          SizedBox(height: 15.h),
          _buildWorkshopsSection(summary.workshopNames, theme),
          SizedBox(height: 30.h),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildEmployeeHeader(EmployeeSummaryEntity summary, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            summary.employeeFullName,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on_outlined, color: Colors.white70, size: 14.sp),
              SizedBox(width: 4.w),
              Text(
                summary.currentLocation,
                style: TextStyle(color: Colors.white70, fontSize: 13.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
    required ThemeData theme,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            SizedBox(height: 12.h),
            Text(title,
                style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 4.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: theme.textTheme.bodyLarge?.color)),
                SizedBox(width: 4.w),
                Text(unit,
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoneyCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold)),
                Text(
                  '${NumberFormat("#,###").format(amount)} \$',
                  style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w900,
                      color: theme.textTheme.bodyLarge?.color),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade300, size: 14.sp),
        ],
      ),
    );
  }

  Widget _buildTotalPayCard(double totalPay, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.green.shade500,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("المجموع النهائي",
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              Text("صافي المستحقات",
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Text(
            "${NumberFormat("#,###").format(totalPay)} \$",
            style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white),
          ),
        ],
      ),
    ).animate().scale(delay: 400.ms, duration: 400.ms, curve: Curves.easeOutBack);
  }

  Widget _buildWorkshopsSection(List<String> workshops, ThemeData theme) {
    if (workshops.isEmpty) {
      return Text('لا توجد ورش عمل مرتبطة حالياً',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13.sp));
    }
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: workshops
          .map((ws) => Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
                ),
                child: Text(
                  ws,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: theme.primaryColor),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: theme.textTheme.bodyLarge?.color),
        ),
      ],
    );
  }
}
