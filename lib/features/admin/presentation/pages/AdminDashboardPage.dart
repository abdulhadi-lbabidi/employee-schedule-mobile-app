import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/App theme/bloc/theme_bloc.dart';
import '../../../payments/presentation/pages/AdminFinancePage.dart';
import '../bloc/admin_dashboard/admin_dashboard_bloc.dart';
import '../bloc/admin_dashboard/admin_dashboard_event.dart';
import '../bloc/admin_dashboard/admin_dashboard_state.dart';

import 'AdminNotificationsPage.dart';
import 'AdminProfilePage.dart';
import 'AdminRewardsPage.dart';
import 'EmployeesPage.dart';
import '../widgets/EmployeeStatusCard.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocProvider(
      create: (_) => sl<AdminDashboardBloc>()..add(LoadDashboardEvent()),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              theme.brightness == Brightness.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: theme.primaryColor,
            ),
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleThemeEvent());
            },
          ),
          toolbarHeight: 80.h,
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("لوحة التحكم",
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900, color: theme.primaryColor)),
              Text(DateFormat('EEEE, d MMMM').format(DateTime.now()), 
                style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
            ],
          ),
          actions: [

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminProfilePage())),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, 
                    border: Border.all(color: theme.primaryColor.withOpacity(0.2), width: 2)
                  ),
                  child: CircleAvatar(
                    radius: 22.r, 
                    backgroundColor: theme.primaryColor.withOpacity(0.1), 
                    child: Icon(Icons.person_rounded, color: theme.primaryColor)
                  ),
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) return _buildLoadingState(theme);
            if (state is DashboardError) return _buildErrorState(state.message);

            if (state is DashboardLoaded) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        SizedBox(height: 10.h),
                        _buildKPISection(state, theme),
                        SizedBox(height: 30.h),
                        _buildSectionTitle("الإجراءات السريعة", Icons.flash_on_rounded, Colors.orange),
                        SizedBox(height: 15.h),
                        _buildQuickActions(context, theme),
                        SizedBox(height: 30.h),
                        _buildSectionTitle("توزيع السيولة على الورشات", Icons.analytics_rounded, Colors.blue),
                        SizedBox(height: 15.h),
                        _buildRestoredFinanceCard(state, theme),
                        SizedBox(height: 30.h),
                        _buildSectionTitle("نشاط الحضور الأسبوعي", Icons.bar_chart_rounded, Colors.purple),
                        SizedBox(height: 15.h),
                        _buildAttendanceChart(state.weeklyAttendance, theme),
                        SizedBox(height: 30.h),
                        _buildSectionTitle("حالة الموظفين", Icons.supervised_user_circle_rounded, Colors.green),
                        SizedBox(height: 15.h),
                        ..._buildEmployeeList(state),
                        SizedBox(height: 100.h),
                      ]),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildKPISection(DashboardLoaded state, ThemeData theme) {
    return Row(
      children: [
        _buildKPICard("العمال", "${state.onlineEmployees.length + state.offlineEmployees.length}", "نشط الآن", Icons.people_rounded, Colors.blue, theme),
        SizedBox(width: 15.w),
        _buildKPICard("التكاليف", NumberFormat.compact().format(state.totalOperationalCost), "هذا الشهر", Icons.account_balance_wallet_rounded, Colors.green, theme),
      ],
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0, duration: 800.ms); // بطيئة أكثر
  }

  Widget _buildKPICard(String label, String value, String subLabel, IconData icon, Color color, ThemeData theme) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15.r)),
              child: Icon(icon, color: color, size: 22.sp),
            ),
            SizedBox(height: 15.h),
            Text(value, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900)),
            Text(label, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.grey)),
            SizedBox(height: 4.h),
            Text(subLabel, style: TextStyle(fontSize: 10.sp, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _actionBtn("إضافة موظف", Icons.add_reaction_rounded, Colors.blue, theme, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeesPage()));
          }),
          _actionBtn("صرف مكافأة", Icons.card_giftcard_rounded, Colors.purple, theme, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminRewardsPage()));
          }),
          _actionBtn("إرسال تنبيه", Icons.notification_add_rounded, Colors.red, theme, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminNotificationsPage()));
          }),
          _actionBtn("كشف رواتب", Icons.payments_rounded, Colors.green, theme, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const FinancialDashboard()));
          }),
        ],
      ),
    );
  }

  Widget _actionBtn(String label, IconData icon, Color color, ThemeData theme, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 15.w),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 26.sp),
            ),
            SizedBox(height: 8.h),
            Text(label, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    ).animate().scale(delay: 500.ms, duration: 600.ms); // تأخير أطول ومدة أطول
  }

  Widget _buildRestoredFinanceCard(DashboardLoaded state, ThemeData theme) {
    final data = state.workshopExpenses;
    if (data.isEmpty) return const SizedBox();
    double total = data.values.reduce((a, b) => a + b);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10.r)]
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 140.h,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 30.r,
                  sections: data.entries.map((e) {
                    int index = data.keys.toList().indexOf(e.key);
                    double percentage = (e.value / total) * 100;
                    return PieChartSectionData(
                      value: e.value,
                      title: '${percentage.toStringAsFixed(0)}%',
                      titleStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: Colors.white),
                      color: Colors.primaries[index % Colors.primaries.length],
                      radius: 40.r,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.keys.map((key) {
                int index = data.keys.toList().indexOf(key);
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: Colors.primaries[index % Colors.primaries.length],
                          shape: BoxShape.circle
                        )
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(key,
                          style: TextStyle(fontSize: 12.sp, color: theme.textTheme.bodyMedium?.color),
                          overflow: TextOverflow.ellipsis
                        )
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 800.ms); // أبطأ
  }

  Widget _buildAttendanceChart(Map<String, int> data, ThemeData theme) {
    List<String> days = data.keys.toList();
    return Container(
      height: 240.h,
      padding: EdgeInsets.fromLTRB(10.w, 20.h, 10.w, 10.h),
      decoration: BoxDecoration(
        color: theme.cardColor, 
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10.r)]
      ),
      child: Column(
        children: [
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (data.values.isEmpty ? 10 : data.values.reduce((a, b) => a > b ? a : b) + 2).toDouble(),
                barGroups: data.entries.toList().asMap().entries.map((e) => BarChartGroupData(
                  x: e.key,
                  barRods: [BarChartRodData(
                    toY: e.value.value.toDouble(),
                    color: theme.primaryColor,
                    width: 16.w,
                    borderRadius: BorderRadius.circular(4.r),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: (data.values.isEmpty ? 10 : data.values.reduce((a, b) => a > b ? a : b) + 2).toDouble(),
                      color: theme.primaryColor.withOpacity(0.05),
                    ),
                  )]
                )).toList(),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30.w,
                      getTitlesWidget: (value, meta) => SideTitleWidget(
                        meta: meta,
                        child: Text(value.toInt().toString(), style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40.h,
                      interval: 1, 
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < days.length) {
                          return SideTitleWidget(
                            meta: meta,
                            space: 10.h,
                            child: Text(
                              days[index], 
                              style: TextStyle(
                                fontSize: 9.sp, 
                                fontWeight: FontWeight.bold, 
                                color: theme.textTheme.bodyMedium?.color
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms, duration: 1000.ms); // أبطأ بكثير
  }

  List<Widget> _buildEmployeeList(DashboardLoaded state) {
    final list = [...state.onlineEmployees, ...state.offlineEmployees];
    return list.map((e) => EmployeeStatusCard(employee: e)).toList();
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20.sp),
        SizedBox(width: 10.w),
        Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _buildLoadingState(ThemeData theme) => const Center(child: CircularProgressIndicator());
  Widget _buildErrorState(String m) => Center(child: Text(m));
}
