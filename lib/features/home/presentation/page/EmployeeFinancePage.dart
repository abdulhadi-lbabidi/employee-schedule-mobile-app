import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/date_helper.dart';
import '../bloc/finance/finance_bloc.dart';
import '../../domain/entities/finance_entity.dart';

class EmployeeFinancePage extends StatefulWidget {
  const EmployeeFinancePage({super.key});

  @override
  State<EmployeeFinancePage> createState() => _EmployeeFinancePageState();
}

class _EmployeeFinancePageState extends State<EmployeeFinancePage> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    context.read<FinanceBloc>().add(LoadFinanceHistory());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<FinanceBloc, FinanceState>(
        builder: (context, state) {
          if (state is FinanceLoading) {
            return Center(child: CircularProgressIndicator(color: theme.primaryColor));
          }

          if (state is FinanceError) {
            return _buildErrorState(state.message, theme);
          }

          if (state is FinanceLoaded) {
            return _buildContent(state, state.history, theme);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(FinanceLoaded state, List<FinanceWeekEntity> history, ThemeData theme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          SizedBox(height: 25.h),
          
          _buildSummaryCards(state, theme),
          
          SizedBox(height: 35.h),
          _buildDateSelector(theme),
          
          SizedBox(height: 20.h),
          _buildSectionTitle("سجل الدفعات", Icons.history_rounded, theme),
          SizedBox(height: 15.h),
          
          if (history.isEmpty)
            _buildEmptyState(theme)
          else
            ...history.reversed.toList().asMap().entries.map((entry) {
              return _buildWeekCard(entry.value, theme)
                  .animate()
                  .fadeIn(delay: (400 + (entry.key * 100)).ms)
                  .slideY(begin: 0.1, end: 0);
            }).toList(),
          
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "صندقي",
          style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 24.sp, fontWeight: FontWeight.w900),
        ).animate().fadeIn().slideX(begin: -0.2),
        Text(
          "تتبع أرباحك ومدفوعاتك الأسبوعية",
          style: TextStyle(color: theme.disabledColor, fontSize: 12.sp, fontWeight: FontWeight.bold),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildSummaryCards(FinanceLoaded state, ThemeData theme) {
    return Row(
      children: [
        _buildStatCard("المقبوضات", "${state.totalEarned.toStringAsFixed(0)}", Colors.green, theme),
        SizedBox(width: 15.w),
        _buildStatCard("قيد الانتظار", "${state.currentDue.toStringAsFixed(0)}", Colors.orange, theme),
      ],
    ).animate().fadeIn(delay: 300.ms).scale(curve: Curves.easeOutBack);
  }

  Widget _buildStatCard(String title, String value, Color color, ThemeData theme) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: color, fontSize: 12.sp, fontWeight: FontWeight.w900)),
            SizedBox(height: 8.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value, style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 20.sp, fontWeight: FontWeight.w900)),
                SizedBox(width: 4.w),
                Text("ل.س", style: TextStyle(color: theme.disabledColor, fontSize: 10.sp, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Expanded(child: _dropdownItem(selectedYear, DateHelper.getYearsRange(), (v) => setState(() => selectedYear = v!), theme)),
          SizedBox(width: 10.w),
          Expanded(child: _dropdownItem(selectedMonth, List.generate(12, (i) => i + 1), (v) => setState(() => selectedMonth = v!), theme, isMonth: true)),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _dropdownItem(int value, List<int> items, ValueChanged<int?> onChanged, ThemeData theme, {bool isMonth = false}) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        value: value,
        isExpanded: true,
        dropdownColor: theme.cardColor,
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(isMonth ? DateHelper.getMonthName(i) : i.toString(), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color)))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildWeekCard(FinanceWeekEntity week, ThemeData theme) {
    return Card(
      color: theme.cardColor,
      margin: EdgeInsets.only(bottom: 15.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        iconColor: theme.primaryColor,
        title: Text('الأسبوع ${week.weekNumber}', style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontWeight: FontWeight.w900, fontSize: 16.sp)),
        subtitle: _buildStatusBadge(week.isPaid),
        trailing: Text('${NumberFormat.decimalPattern().format(week.totalAmount)} ل.س', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w900, fontSize: 14.sp)),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
            child: Column(
              children: [
                Divider(color: theme.dividerColor.withOpacity(0.1)),
                _row("الساعات الأساسية", "${week.regularHours} س", theme),
                _row("الساعات الإضافية", "${week.overtimeHours} س", theme),
                _row("أجر الإضافي", "${week.overtimeRate} ل.س", theme),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    spacing: 8.w,
                    children: week.workshops.map((w) => Chip(
                      label: Text(w, style: TextStyle(fontSize: 10.sp, color: theme.primaryColor, fontWeight: FontWeight.bold)),
                      backgroundColor: theme.primaryColor.withOpacity(0.05),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isPaid) {
    return Container(
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: (isPaid ? Colors.green : Colors.orange).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(isPaid ? "تمت التسوية " : "بانتظار الصرف ", 
        style: TextStyle(color: isPaid ? Colors.green : Colors.orange, fontSize: 10.sp, fontWeight: FontWeight.bold)),
    );
  }

  Widget _row(String l, String v, ThemeData theme) => Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(l, style: TextStyle(color: theme.disabledColor, fontSize: 12.sp, fontWeight: FontWeight.bold)),
      Text(v, style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 13.sp, fontWeight: FontWeight.w900)),
    ]),
  );

  Widget _buildSectionTitle(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: theme.primaryColor),
        SizedBox(width: 8.w),
        Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) => Center(child: Padding(padding: EdgeInsets.only(top: 40.h), child: Text("لا توجد سجلات لهذا التاريخ", style: TextStyle(color: theme.disabledColor, fontWeight: FontWeight.bold))));

  Widget _buildErrorState(String msg, ThemeData theme) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error_outline, color: theme.colorScheme.error, size: 50.sp), SizedBox(height: 10.h), Text(msg, style: TextStyle(color: theme.textTheme.bodyLarge?.color))]));
}
