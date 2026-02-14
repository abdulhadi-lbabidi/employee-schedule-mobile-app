import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart'; // 🔹 إضافة مكتبة الانميشن
import 'package:intl/intl.dart'; 

import '../../../../core/services/pdf_report_service.dart';
import '../bloc/employees/employees_bloc.dart';
import '../bloc/employees/employees_event.dart';
import '../bloc/employees/employees_state.dart';
import '../bloc/employee_details/employee_details_bloc.dart';
import '../bloc/employee_details/employee_details_state.dart';
import 'EmployeeDetailsPage.dart';

class AdminFinancePage extends StatelessWidget {
  const AdminFinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<EmployeeDetailsBloc, EmployeeDetailsState>(
          listener: (context, state) {
            if (state is EmployeeDetailsLoaded) {
              context.read<EmployeesBloc>().add(LoadEmployeesEvent());
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text("الرقابة المالية", 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: theme.primaryColor)),
          centerTitle: true,
          // actions: [
          //   BlocBuilder<EmployeesBloc, EmployeesState>(
          //     builder: (context, state) {
          //       if (state is EmployeesLoaded) {
          //         final stats = _calculateDetailedStats(state.employees);
          //         return IconButton(
          //           icon: Icon(Icons.picture_as_pdf_rounded, color: theme.primaryColor, size: 24.sp),
          //           onPressed: () {
          //             PdfReportService.generateFinanceReport(
          //               employees: state.employees,
          //               totalDue: stats['totalDue'],
          //             );
          //           },
          //           tooltip: "استخراج كشف PDF",
          //         );
          //       }
          //       return const SizedBox.shrink();
          //     },
          //   ),
          //   SizedBox(width: 8.w),
          // ],
        ),
        // body: BlocBuilder<EmployeesBloc, EmployeesState>(
        //   builder: (context, state) {
        //     if (state is EmployeesLoading) return const Center(child: CircularProgressIndicator());
        //     if (state is! EmployeesLoaded) return Center(child: Text("لا توجد بيانات متاحة", style: TextStyle(fontSize: 14.sp)));
        //
        //     final stats = _calculateDetailedStats(state.employees);
        //     // final unpaidEmployees = state.employees.where((e) => e.unpaidBalance > 0).toList();
        //
        //     return ListView(
        //       padding: EdgeInsets.all(16.w),
        //       physics: const BouncingScrollPhysics(),
        //       children: [
        //         _buildMainFinancialOverview(stats['totalDue'], theme)
        //             .animate().fadeIn(duration: 800.ms).scale(curve: Curves.easeOutBack),
        //
        //         SizedBox(height: 24.h),
        //
        //         _buildEnhancedExpenseChart(stats['workshopData'], theme)
        //             .animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(begin: 0.1, end: 0),
        //
        //         SizedBox(height: 28.h),
        //
        //         _buildSectionTitle("كشف مستحقات العمال", theme)
        //             .animate().fadeIn(delay: 500.ms),
        //
        //         SizedBox(height: 12.h),
        //
        //         // if (unpaidEmployees.isEmpty)
        //         //   _buildAllPaidState(theme).animate().fadeIn(delay: 600.ms)
        //         // else
        //         //   ...unpaidEmployees.asMap().entries.map((entry) =>
        //         //     _buildEmployeeFinTile(context, entry.value, theme)
        //         //         .animate()
        //         //         .fadeIn(delay: (600 + (entry.key * 100)).ms, duration: 400.ms)
        //         //         .slideX(begin: 0.05, end: 0)
        //         //   ),
        //       ],
        //     );
        //   },
        // ),
      ),
    );
  }

  Map<String, dynamic> _calculateDetailedStats(List<dynamic> employees) {
    double totalDue = 0;
    Map<String, double> workshopData = {};

    for (var emp in employees) {
      double empUnpaid = emp.unpaidBalance;
      totalDue += empUnpaid;

      for (var week in emp.weeklyHistory) {
        if (!week.isPaid) {
          for (var ws in week.workshops) {
            double val = ws.calculateValue(emp.hourlyRate, emp.overtimeRate);
            workshopData[ws.workshopName] = (workshopData[ws.workshopName] ?? 0) + val;
          }
        }
      }
    }
    return {'totalDue': totalDue, 'workshopData': workshopData};
  }

  Widget _buildMainFinancialOverview(double total, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.2), 
            blurRadius: 15.r, 
            offset: Offset(0, 8.h)
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("إجمالي الالتزامات المالية الحالية", 
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13.sp)),
          SizedBox(height: 12.h),
          FittedBox(
            child: Text("${NumberFormat.decimalPattern().format(total)} ل.س", 
                 style: TextStyle(color: Colors.white, fontSize: 30.sp, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
          ),
          SizedBox(height: 15.h),
          Divider(color: Colors.white.withValues(alpha: 0.2)),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user_rounded, color: Colors.greenAccent, size: 16.sp)
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(duration: 2.seconds, color: Colors.white24),
              SizedBox(width: 8.w),
              Text("بيانات مالية محدثة وآمنة", 
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11.sp)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEnhancedExpenseChart(Map<String, double> data, ThemeData theme) {
    if (data.isEmpty) return const SizedBox();
    final keys = data.keys.toList();
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardColor, 
        borderRadius: BorderRadius.circular(24.r), 
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10.r)]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("توزيع السيولة حسب الورشات", 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp, color: theme.primaryColor)),
          SizedBox(height: 25.h),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 140.h,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 30.r,
                      sections: data.entries.map((e) {
                        final index = keys.indexOf(e.key);
                        return PieChartSectionData(
                          value: e.value,
                          title: '', 
                          radius: 35.r,
                          color: Colors.primaries[index % Colors.primaries.length],
                        );
                      }).toList(),
                    ),
                  ).animate().rotate(duration: 1000.ms, curve: Curves.easeInOut),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.entries.map((e) {
                    final index = keys.indexOf(e.key);
                    return _buildLegendItem(theme, e.key, e.value, Colors.primaries[index % Colors.primaries.length]);
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(ThemeData theme, String label, double value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Container(width: 10.w, height: 10.w, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          SizedBox(width: 8.w),
          Expanded(child: Text(label, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 11.sp), overflow: TextOverflow.ellipsis)),
          Text("${(value/1000).toStringAsFixed(1)}k", style: TextStyle(fontSize: 10.sp, color: theme.disabledColor)),
        ],
      ),
    );
  }

  Widget _buildEmployeeFinTile(BuildContext context, dynamic emp, ThemeData theme) {
    double due = emp.unpaidBalance;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: theme.cardColor, 
        borderRadius: BorderRadius.circular(18.r), 
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10.r)]
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context, 
          MaterialPageRoute(builder: (_) => EmployeeDetailsPage(employeeId: emp.id))
        ),
        borderRadius: BorderRadius.circular(18.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22.r, 
                backgroundColor: theme.primaryColor.withValues(alpha: 0.1), 
                child: Icon(Icons.person_rounded, color: theme.primaryColor, size: 22.sp)
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(emp.name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                    SizedBox(height: 4.h),
                    Text("انقر للمراجعة والصرف", 
                      style: TextStyle(color: Colors.orange.shade700, fontSize: 10.sp, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${NumberFormat.decimalPattern().format(due)}", 
                    style: TextStyle(fontWeight: FontWeight.w900, color: Colors.green, fontSize: 14.sp)),
                  Text("ل.س", style: TextStyle(fontSize: 9.sp, color: theme.disabledColor)),
                ],
              ),
              SizedBox(width: 8.w),
              Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: theme.dividerColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(title, 
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8)));
  }

  Widget _buildAllPaidState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: Column(
          children: [
            Icon(Icons.task_alt_rounded, color: Colors.green, size: 60.sp),
            SizedBox(height: 12.h),
            Text("تمت تسوية جميع الرواتب بنجاح ✓", 
              style: TextStyle(color: Colors.green, fontSize: 14.sp, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
