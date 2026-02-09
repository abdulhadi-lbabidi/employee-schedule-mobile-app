import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../Notification/presentation/bloc/notification_bloc.dart';
import '../../../Notification/presentation/bloc/notification_event.dart';
import '../../domain/entities/employee_entity.dart';
import '../bloc/employee_details/employee_details_bloc.dart';
import '../bloc/employee_details/employee_details_event.dart';
import '../bloc/employee_details/employee_details_state.dart';
import 'EditEmployeePage.dart';

class EmployeeDetailsPage extends StatefulWidget {
  final String employeeId;

  const EmployeeDetailsPage({super.key, required this.employeeId});

  @override
  State<EmployeeDetailsPage> createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (_) =>
          sl<EmployeeDetailsBloc>()..add(LoadEmployeeDetailsEvent(widget.employeeId)),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            AppStrings.employeeDetailsTitle,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: theme.primaryColor),
          ),
          centerTitle: true,
          actions: [
            BlocBuilder<EmployeeDetailsBloc, EmployeeDetailsState>(
              builder: (context, state) {
                if (state is EmployeeDetailsLoaded) {
                  final employee = state.employee;
                  return Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          employee.isArchived ? Icons.unarchive_outlined : Icons.archive_outlined,
                          color: employee.isArchived ? Colors.green : Colors.orange,
                        ),
                        onPressed: () => _showArchiveConfirmation(context, employee),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit_note_rounded, size: 28.sp, color: theme.primaryColor),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditEmployeePage(employee: employee))),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.redAccent, size: 24.sp),
              onPressed: () => _showDeleteConfirmation(context, widget.employeeId),
            ),
          ],
        ),
        body: BlocConsumer<EmployeeDetailsBloc, EmployeeDetailsState>(
          listener: (context, state) {
            if (state is EmployeeDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حذف الموظف بنجاح'), backgroundColor: Colors.red));
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is EmployeeDetailsLoading) return const Center(child: CircularProgressIndicator());

            if (state is EmployeeDetailsLoaded || state is HourlyRateUpdating) {
              final employee = state is EmployeeDetailsLoaded ? state.employee : (state as dynamic).employee as EmployeeEntity;
              
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    if (employee.isArchived) _buildArchivedBanner(theme),
                    _EmployeeHeader(employee, theme),
                    SizedBox(height: 24.h),
                    // _PasswordSection(employee, theme),
                    // SizedBox(height: 20.h),
                    _AttendanceStatsSection(employee, theme),
                    SizedBox(height: 30.h),
                    
                    _buildSectionHeader("تصفية النتائج", Icons.filter_alt_outlined, theme),
                    SizedBox(height: 12.h),
                    _buildDateSelector(theme),
                    
                    SizedBox(height: 30.h),
                    _WeeklyWorkSection(
                      employee: employee, 
                      selectedYear: selectedYear, 
                      selectedMonth: selectedMonth,
                      theme: theme,
                    ),
                    
                    SizedBox(height: 30.h),
                    _RatesSection(employee, theme),
                    SizedBox(height: 40.h),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: theme.primaryColor),
        SizedBox(width: 8.w),
        Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color)),
      ],
    );
  }

  Widget _buildArchivedBanner(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(12.r), border: Border.all(color: Colors.orange.withOpacity(0.3))),
      child: Center(child: Text("هذا الموظف مؤرشف حالياً", style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold, fontSize: 13.sp))),
    );
  }

  Widget _buildDateSelector(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(child: _buildDropdown<int>(
            value: selectedYear,
            items: DateHelper.getYearsRange(),
            onChanged: (val) => setState(() => selectedYear = val!),
            label: "السنة",
            theme: theme,
          )),
          SizedBox(width: 12.w),
          Expanded(child: _buildDropdown<int>(
            value: selectedMonth,
            items: List.generate(12, (index) => index + 1),
            itemLabel: (m) => DateHelper.getMonthName(m),
            onChanged: (val) => setState(() => selectedMonth = val!),
            label: "الشهر",
            theme: theme,
          )),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({required T value, required List<T> items, required ValueChanged<T?> onChanged, required String label, required ThemeData theme, String Function(T)? itemLabel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, borderRadius: BorderRadius.circular(10.r), border: Border.all(color: theme.dividerColor.withOpacity(0.2))),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              dropdownColor: theme.cardColor,
              icon: Icon(Icons.keyboard_arrow_down, color: theme.primaryColor),
              items: items.map((T item) => DropdownMenuItem<T>(value: item, child: Text(itemLabel != null ? itemLabel(item) : item.toString(), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id) {
    showDialog(context: context, builder: (d) => AlertDialog(
      title: const Text('حذف الموظف'),
      content: const Text('هل أنت متأكد من حذف الموظف نهائياً؟'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(d), child: const Text("إلغاء")),
        TextButton(onPressed: () { context.read<EmployeeDetailsBloc>().add(DeleteEmployeeEvent(id)); Navigator.pop(d); }, child: const Text("حذف", style: TextStyle(color: Colors.red))),
      ],
    ));
  }

  void _showArchiveConfirmation(BuildContext context, EmployeeEntity employee) {
    final bool willArchive = !employee.isArchived;
    showDialog(context: context, builder: (d) => AlertDialog(
      title: Text(willArchive ? 'أرشفة الموظف' : 'إلغاء الأرشفة'),
      content: Text(willArchive ? 'هل أنت متأكد من أرشفة الموظف ${employee.name}؟' : 'هل تريد إعادة تنشيط الموظف ${employee.name}؟'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(d), child: const Text("إلغاء")),
        TextButton(onPressed: () { context.read<EmployeeDetailsBloc>().add(ToggleArchiveEmployeeDetailEvent(employee.id, willArchive)); Navigator.pop(d); }, child: Text(willArchive ? "أرشفة" : "تنشيط", style: TextStyle(color: willArchive ? Colors.orange : Colors.green))),
      ],
    ));
  }
}

class _EmployeeHeader extends StatelessWidget {
  final EmployeeEntity employee;
  final ThemeData theme;
  const _EmployeeHeader(this.employee, this.theme);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 55.r, backgroundColor: theme.primaryColor.withOpacity(0.1), child: Icon(Icons.person, size: 60.sp, color: theme.primaryColor)),
        SizedBox(height: 16.h),
        Text(employee.name, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: theme.textTheme.bodyLarge?.color)),
        Text(employee.phoneNumber, style: TextStyle(fontSize: 16.sp, color: theme.primaryColor, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
          child: Text("الورشة: ${employee.workshopName}", style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold, fontSize: 12.sp)),
        ),
      ],
    );
  }
}

// class _PasswordSection extends StatefulWidget {
//   final EmployeeEntity employee;
//   final ThemeData theme;
//   const _PasswordSection(this.employee, this.theme);
//   @override
//   State<_PasswordSection> createState() => _PasswordSectionState();
// }

// class _PasswordSectionState extends State<_PasswordSection> {
//   bool _show = false;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//       decoration: BoxDecoration(color: widget.theme.cardColor, borderRadius: BorderRadius.circular(16.r), border: Border.all(color: widget.theme.dividerColor.withOpacity(0.1))),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.lock_outline_rounded, color: Colors.grey, size: 20.sp),
//             ],
//           ),
//           IconButton(icon: Icon(_show ? Icons.visibility_off : Icons.visibility, color: widget.theme.primaryColor, size: 22.sp), onPressed: () => setState(() => _show = !_show)),
//         ],
//       ),
//     );
//   }
// }

class _AttendanceStatsSection extends StatelessWidget {
  final EmployeeEntity employee;
  final ThemeData theme;
  const _AttendanceStatsSection(this.employee, this.theme);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.05), borderRadius: BorderRadius.circular(20.r), border: Border.all(color: theme.primaryColor.withOpacity(0.1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statCol("أيام الدوام", '${employee.daysAttended} يوم', theme),
          Container(width: 1, height: 40.h, color: theme.dividerColor.withOpacity(0.2)),
          _statCol("مستحقات معلقة", '${employee.unpaidBalance.toStringAsFixed(0)} ل.س', theme, color: Colors.red.shade700),
        ],
      ),
    );
  }
  Widget _statCol(String t, String v, ThemeData theme, {Color? color}) => Column(children: [Text(t, style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600, fontWeight: FontWeight.bold)), SizedBox(height: 4.h), Text(v, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: color ?? theme.textTheme.bodyLarge?.color))]);
}

class _WeeklyWorkSection extends StatelessWidget {
  final EmployeeEntity employee;
  final int selectedYear;
  final int selectedMonth;
  final ThemeData theme;

  const _WeeklyWorkSection({required this.employee, required this.selectedYear, required this.selectedMonth, required this.theme});

  @override
  Widget build(BuildContext context) {
    final filteredWeeks = employee.weeklyHistory.where((w) => w.month == selectedMonth && w.year == selectedYear).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("سجل المستحقات الأسبوعية", Icons.history_rounded, theme),
        SizedBox(height: 12.h),
        if (filteredWeeks.isEmpty)
          _buildEmptyState()
        else
          ...filteredWeeks.map((week) => _buildWeekExpandableCard(context, week)).toList(),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: theme.primaryColor),
        SizedBox(width: 8.w),
        Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildWeekExpandableCard(BuildContext context, WeeklyWorkHistory week) {
    final remaining = week.remainingAmount(employee.hourlyRate, employee.overtimeRate);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        iconColor: theme.primaryColor,
        title: Text('الأسبوع ${week.weekNumber}', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: theme.primaryColor)),
        subtitle: _buildStatusBadge(week),
        childrenPadding: EdgeInsets.all(16.w),
        children: [
          ...week.workshops.map((ws) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(ws.workshopName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: theme.textTheme.bodyLarge?.color)),
                  Text("نظامي: ${ws.regularHours} س | إضافي: ${ws.overtimeHours} س", style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                ]),
                Text("${ws.calculateValue(employee.hourlyRate, employee.overtimeRate).toStringAsFixed(0)} ل.س", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900, color: theme.textTheme.bodyLarge?.color)),
              ],
            ),
          )),
          const Divider(),
          if (week.amountPaid > 0) _amountRow("تم صرف سابقاً:", week.amountPaid, Colors.green),
          _amountRow("المبلغ المتبقي:", remaining, remaining > 0 ? Colors.red : Colors.green, isBold: true),
          
          if (!week.isPaid)
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r))),
                  onPressed: () => _showPaymentOptions(context, week.weekNumber, remaining),
                  child: Text("تأكيد صرف استحقاق", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _amountRow(String t, double v, Color c, {bool isBold = false}) => Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(t, style: TextStyle(fontSize: 13.sp, fontWeight: isBold ? FontWeight.w900 : FontWeight.bold, color: isBold ? theme.textTheme.bodyLarge?.color : Colors.grey.shade600)),
      Text("${v.toStringAsFixed(0)} ل.س", style: TextStyle(color: c, fontWeight: FontWeight.w900, fontSize: isBold ? 16.sp : 13.sp)),
    ]),
  );

  Widget _buildEmptyState() => Center(child: Padding(padding: EdgeInsets.all(30.h), child: Column(children: [Icon(Icons.event_busy_rounded, color: Colors.grey.shade300, size: 40.sp), SizedBox(height: 10.h), Text("لا توجد سجلات لهذا التاريخ", style: TextStyle(color: Colors.grey, fontSize: 13.sp, fontWeight: FontWeight.bold))])));

  Widget _buildStatusBadge(WeeklyWorkHistory week) {
    if (week.isPaid) return Text("تم الدفع بالكامل ✅", style: TextStyle(color: Colors.green.shade700, fontSize: 12.sp, fontWeight: FontWeight.w900));
    if (week.amountPaid > 0) return Text("دفعة جزئية ⚠️", style: TextStyle(color: Colors.orange.shade800, fontSize: 12.sp, fontWeight: FontWeight.w900));
    return Text("غير مدفوع ❌", style: TextStyle(color: Colors.red.shade700, fontSize: 12.sp, fontWeight: FontWeight.w900));
  }

  void _showPaymentOptions(BuildContext context, int weekNumber, double remaining) {
    showDialog(context: context, builder: (d) => AlertDialog(
      title: const Text("خيارات الصرف"),
      content: Text("المبلغ المتبقي للأسبوع $weekNumber هو ${remaining.toStringAsFixed(0)} ل.س."),
      actions: [
        TextButton(onPressed: () { Navigator.pop(d); _processPayment(context, weekNumber, remaining, isFull: true); }, child: const Text("دفع كامل", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
        TextButton(onPressed: () { Navigator.pop(d); _showPartialDialog(context, weekNumber, remaining); }, child: const Text("دفع جزئي")),
      ],
    ));
  }

  void _showPartialDialog(BuildContext context, int weekNumber, double remaining) {
    final c = TextEditingController();
    showDialog(context: context, builder: (d) => AlertDialog(
      title: const Text("دفع جزئي"),
      content: TextField(controller: c, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "المبلغ", hintText: "بحد أقصى ${remaining.toInt()}")),
      actions: [
        TextButton(onPressed: () => Navigator.pop(d), child: const Text("إلغاء")),
        ElevatedButton(onPressed: () {
          double a = double.tryParse(c.text) ?? 0;
          if (a > 0 && a <= remaining) { Navigator.pop(d); _processPayment(context, weekNumber, a, isFull: a == remaining); }
        }, child: const Text("تأكيد")),
      ],
    ));
  }

  void _processPayment(BuildContext context, int weekNumber, double amount, {required bool isFull}) {
    final state = context.read<EmployeeDetailsBloc>().state;
    if (state is EmployeeDetailsLoaded) {
      final emp = state.employee;
      context.read<EmployeeDetailsBloc>().add(ConfirmPaymentEvent(emp, weekNumber, amountPaid: amount, isFullPayment: isFull));
      context.read<NotificationBloc>().add(AdminSendNotificationEvent(title: "دفع مالي", body: "تم صرف ${amount.toInt()} ل.س للأسبوع $weekNumber", targetEmployeeId: int.tryParse(emp.id))); // تم التحويل هنا
    }
  }
}

class _RatesSection extends StatelessWidget {
  final EmployeeEntity employee;
  final ThemeData theme;
  const _RatesSection(this.employee, this.theme);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(20.r), border: Border.all(color: theme.dividerColor.withOpacity(0.1))),
      child: Column(children: [
        _rateRow("سعر الساعة العادية", employee.hourlyRate),
        SizedBox(height: 12.h),
        _rateRow("سعر الساعة الإضافية", employee.overtimeRate),
      ]),
    );
  }
  Widget _rateRow(String t, double v) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t, style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600, fontWeight: FontWeight.bold)), Text("${v.toInt()} ل.س", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15.sp, color: theme.textTheme.bodyLarge?.color))]);
}
