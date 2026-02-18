import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../data/models/employee_summary_model.dart';
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
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900, // تم استبدال black بـ w900 لضمان التوافق
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: theme.primaryColor),
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
                return _buildErrorState(state.message, context, employeeId);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryContent(EmployeeSummaryModel summary, ThemeData theme) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmployeeHeader(summary, theme),
          SizedBox(height: 25.h),

          _buildSectionTitle('إحصائيات الساعات', Icons.timer_outlined, theme),
          SizedBox(height: 15.h),
          Row(
            children: [
              _buildStatCard(
                title: 'ساعات نظامية',
                value: summary.grandTotals!.totalRegularHours.toString(),
                unit: 'ساعة',
                icon: Icons.access_time_filled,
                color: Colors.blue.shade700,
                theme: theme,
              ),
              SizedBox(width: 15.w),
              _buildStatCard(
                title: 'ساعات إضافية',
                value: summary.grandTotals!.totalOvertimeHours.toString(),
                unit: 'ساعة',
                icon: Icons.more_time_rounded,
                color: Colors.orange.shade800,
                theme: theme,
              ),
            ],
          ),

          SizedBox(height: 25.h),
          _buildSectionTitle('المستحقات المالية', Icons.payments_outlined, theme),
          SizedBox(height: 15.h),
          _buildMoneyCard(
            title: 'الأجر الأساسي',
            amount: summary.grandTotals!.totalRegularPay!.toDouble(),
            icon: Icons.account_balance_wallet_rounded,
            color: Colors.indigo.shade700,
            theme: theme,
          ),
          SizedBox(height: 12.h),
          _buildMoneyCard(
            title: 'أجر العمل الإضافي',
            amount: summary.grandTotals!.totalOvertimePay!.toDouble(),
            icon: Icons.add_card_rounded,
            color: Colors.teal.shade700,
            theme: theme,
          ),

          SizedBox(height: 25.h),
          _buildTotalPayCard(summary.grandTotals!.grandTotalPay!.toDouble(), theme),

          SizedBox(height: 25.h),
          _buildSectionTitle('الورشات', Icons.workspaces_outline, theme),
          SizedBox(height: 15.h),
          _buildWorkshopsSection(summary.workshopsSummary, theme),
          SizedBox(height: 30.h),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildEmployeeHeader(EmployeeSummaryModel summary, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            summary.employee!.user!.fullName.toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w900), // استبدال black
          ),
          SizedBox(height: 6.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.badge_rounded, color: Colors.white, size: 14.sp),
                SizedBox(width: 6.w),
                Text(
                  summary.employee!.position.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),
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
    final bool isDark = theme.brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.grey.shade300 : Colors.grey.shade900;

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22.sp),
            ),
            SizedBox(height: 12.h),
            Text(title,
                style: TextStyle(
                    fontSize: 12.sp,
                    color: textColor.withOpacity(0.8),
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
                        color: textColor.withOpacity(0.6),
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
    final bool isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, color: color, size: 26.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade800,
                        fontWeight: FontWeight.bold)),
                Text(
                  '${NumberFormat("#,###.##").format(amount)} \$',
                  style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w900,
                      color: theme.primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPayCard(double totalPay, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.green.shade600,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(color: Colors.green.withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 8))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("المجموع النهائي",
                  style: TextStyle(fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.w900)),
              Text("صافي المستحقات",
                  style: TextStyle(fontSize: 12.sp, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600)),
            ],
          ),
          Text(
            "${NumberFormat("#,###.##").format(totalPay)} \$",
            style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ],
      ),
    ).animate().scale(delay: 300.ms, duration: 500.ms, curve: Curves.easeOutBack);
  }

  Widget _buildWorkshopsSection(List<WorkshopsSummary>? summary, ThemeData theme) {
    if (summary == null || summary.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Text('لا توجد ورش عمل مرتبطة حالياً',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp, fontWeight: FontWeight.bold)),
        ),
      );
    }
    return Column(children: summary.map((ws) => _buildWorkshopCard(ws, theme)).toList());
  }

  Widget _buildWorkshopCard(WorkshopsSummary ws, ThemeData theme) {
    final bool isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.primaryColor.withOpacity(0.3), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "ورشة: ${ws.workshopName ?? ''}",
                  style: TextStyle(fontSize: 17.sp, color: theme.primaryColor, fontWeight: FontWeight.w900),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.handyman_rounded, color: theme.primaryColor, size: 22.sp),
            ],
          ),
          Divider(height: 24.h, thickness: 1.2, color: theme.primaryColor.withOpacity(0.15)),
          Row(
            children: [
              Expanded(child: _buildInfoItem("ساعات أساسية", "${ws.regularHours ?? 0} س", theme)),
              Expanded(child: _buildInfoItem("ساعات إضافية", "${ws.overtimeHours ?? 0} س", theme)),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(child: _buildInfoItem("أجر أساسي", "${ws.regularPay ?? 0} \$", theme)),
              Expanded(child: _buildInfoItem("أجر إضافي", "${ws.overtimePay ?? 0} \$", theme)),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.07),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("الإجمالي:", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.black87)),
                Text("${ws.totalPay ?? 0} \$", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: Colors.green.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, ThemeData theme) {
    final bool isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12.sp, color: isDark ? Colors.grey.shade400 : Colors.grey.shade700, fontWeight: FontWeight.bold)),
        SizedBox(height: 5.h),
        Text(value, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900, color: theme.textTheme.bodyLarge?.color)),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 22.sp, color: theme.primaryColor),
        SizedBox(width: 12.w),
        Text(title, style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w900, color: theme.textTheme.bodyLarge?.color)),
      ],
    );
  }

  Widget _buildErrorState(String message, BuildContext context, String id) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, color: Colors.red, size: 70.sp),
          SizedBox(height: 16.h),
          Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.red.shade800, fontSize: 16.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 20.h),
          ElevatedButton.icon(
            onPressed: () => context.read<EmployeeSummaryBloc>().add(LoadEmployeeSummaryEvent(id)),
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
          )
        ],
      ),
    );
  }
}