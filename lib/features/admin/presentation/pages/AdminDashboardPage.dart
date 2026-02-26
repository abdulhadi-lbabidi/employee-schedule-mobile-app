import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/App theme/bloc/theme_bloc.dart';
import '../../../loan/presentation/pages/admin_loan_page.dart';
import '../../../penalty/presentation/pages/admin_penalties_page.dart';
import '../../../reward/presentation/AdminRewardsPage.dart';
import '../bloc/admin_dashboard/admin_dashboard_bloc.dart';
import '../bloc/admin_dashboard/admin_dashboard_event.dart';
import '../bloc/admin_dashboard/admin_dashboard_state.dart';
import 'AdminProfilePage.dart';
import 'EmployeesPage.dart';
import 'WorkshopsPage.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => sl<AdminDashboardBloc>()..add(LoadDashboardEvent()),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(context, theme),
        body: BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is DashboardError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
            }

            if (state is DashboardLoadedFromApi) {
              final data = state.dashboardData;
              return RefreshIndicator(
                onRefresh: () async => context.read<AdminDashboardBloc>().add(LoadDashboardEvent()),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeSection(data.monthName ?? '', theme),
                      SizedBox(height: 25.h),

                      // شبكة الإحصائيات الأساسية مع التنقل
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 15.w,
                        mainAxisSpacing: 18.h,
                        childAspectRatio: 1.1,
                        children: [
                          InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeesPage())),
                            child: _buildModernKPICard(
                              "الموظفين",
                              "${data.generalCounts?.totalEmployees ?? 0}",
                              "عدد الموظفين",
                              Icons.people_alt_rounded,
                              Colors.blueAccent,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkshopsPage())),
                            child: _buildModernKPICard(
                              "الورشات",
                              "${data.generalCounts?.totalWorkshops ?? 0}",
                              "عدد الورشات ",
                              Icons.home_work_rounded,
                              Colors.teal,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15.h),

                      // البطاقات المالية العريضة مع التنقل
                      _buildFinancialRow(
                        label: "المكافآت",
                        amount: "${data.rewardsStats?.totalAmount ?? 0} \$",
                        count: "${data.rewardsStats?.count ?? 0}",
                        icon: Icons.stars_rounded,
                        color: Colors.purple,
                        theme: theme,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminRewardsPage())),
                      ),

                      _buildFinancialRow(
                        label: "القروض",
                        amount: "${data.loansStats?.totalAmount ?? 0} \$",
                        count: "${data.loansStats?.count ?? 0}",
                        icon: Icons.account_balance_wallet_rounded,
                        color: Colors.orange.shade800,
                        theme: theme,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminLoanPage())),
                      ),
                      
                      _buildFinancialRow(
                        label: "الخصومات المالية",
                        amount: "عرض السجل",
                        count: "إدارة",
                        icon: Icons.gavel_rounded,
                        color: Colors.red.shade700,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPenaltiesPage())),
                        theme: theme,
                      ),

                      SizedBox(height: 25.h),

                      // قسم الحضور والأداء
                      if (data.attendanceEarnings != null)
                        _buildAttendanceSection(data.attendanceEarnings, theme),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // ==================== UI Components ====================

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 90.h,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(4.5.w),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            theme.brightness == Brightness.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: theme.primaryColor,
            size: 22.sp,
          ),
        ),
        onPressed: () => context.read<ThemeBloc>().add(ToggleThemeEvent()),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("لوحة التحكم", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: theme.textTheme.bodyLarge?.color)),
          Text(DateFormat('EEEE, d MMMM').format(DateTime.now()), style: TextStyle(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.w500)),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminProfilePage(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.primaryColor.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 22.r,
                backgroundColor: theme.primaryColor.withOpacity(0.1),
                child: Icon(Icons.person_rounded, color: theme.primaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(String month, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "إحصائيات شهر $month",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: theme.primaryColor),
        ),
        Container(
          height: 3.h,
          width: 70.w,
          margin: EdgeInsets.only(top: 5.h),
          decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(10)),
        ),
      ],
    );
  }

  Widget _buildModernKPICard(String label, String value, String subLabel, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: color.withOpacity(0.15), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 22.sp),
              ),
              SizedBox(width: 7.w),
              Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
            ]
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(value, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900, color: color)),
                Text(subLabel, style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialRow({required String label, required String amount, required String count, required IconData icon, required Color color, required ThemeData theme, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15.r)),
              child: Icon(icon, color: color, size: 28.sp),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.grey)),
                  Text(amount, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10.r)),
              child: Text("$count", style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12.sp)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceSection(attendance, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.teal.shade700, Colors.teal.shade400], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("ملخص الحضور والأجر", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white)), const Icon(Icons.analytics_outlined, color: Colors.white70)],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAttendanceItem("ساعات عادية", "${attendance.regularHours ?? 0}", Icons.timer),
              _buildAttendanceItem("ساعات إضافية", "${attendance.overtimeHours ?? 0}", Icons.more_time),
            ],
          ),
          const Divider(color: Colors.white24, height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("المبلغ التقديري الكلي", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
              Text("${attendance.totalEstimatedAmount ?? 0} \$", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Icon(icon, size: 14.sp, color: Colors.white70), SizedBox(width: 5.w), Text(label, style: TextStyle(color: Colors.white70, fontSize: 12.sp))]),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
