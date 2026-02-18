import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../Notification/presentation/bloc/notification_bloc.dart';
import '../../../Notification/presentation/bloc/notification_event.dart';
import '../../data/models/employee model/get_employee_details_hours_details_response.dart';
import '../bloc/employee_details/employee_details_bloc.dart';
import '../bloc/employee_details/employee_details_event.dart';
import '../bloc/employee_details/employee_details_state.dart';
import '../bloc/employees/employees_bloc.dart';
import '../bloc/employees/employees_event.dart';
import '../bloc/employees/employees_state.dart';
import '../widgets/employee_build_date_selector.dart';
import '../widgets/totals_widgets.dart';
import '../widgets/week_details_widget.dart';
import 'EditEmployeePage.dart';
import 'EmployeesPage.dart';

class EmployeeDetailsPage extends StatefulWidget {
  final EmployeeModel employeeModel;
  final bool isArchived;

  const EmployeeDetailsPage({
    super.key,
    required this.employeeModel,
    required this.isArchived,
  });

  @override
  State<EmployeeDetailsPage> createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  late ValueNotifier<Week?> selectedWeek;
  late ValueNotifier<bool> isArchivedNotifier;

  @override
  void initState() {
    selectedWeek = ValueNotifier(null);
    isArchivedNotifier = ValueNotifier(widget.isArchived);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create:
          (_) =>
              sl<EmployeeDetailsBloc>()..add(
                LoadEmployeeDetailsHoursEvent(
                  widget.employeeModel.id.toString(),
                ),
              ),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            AppStrings.employeeDetailsTitle,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          centerTitle: true,
          actions: [
            BlocListener<EmployeesBloc, EmployeesState>(
              listener: (context, state) {
                state.restoreEmployeeArchivedData.listenerFunction(
                  onSuccess: () {
                    isArchivedNotifier.value = false;
                  },
                );
                state.setEmployeeArchivedData.listenerFunction(
                  onSuccess: () {
                    isArchivedNotifier.value = true;
                  },
                );
              },
              listenWhen:
                  (pre, cur) =>
                      (pre.setEmployeeArchivedData.status !=
                          cur.setEmployeeArchivedData.status) ||
                      (pre.restoreEmployeeArchivedData.status !=
                          cur.restoreEmployeeArchivedData.status),
              child: BlocBuilder<EmployeeDetailsBloc, EmployeeDetailsState>(
                builder: (context, state) {
                  if (state is EmployeeDetailsHoursLoaded) {
                    final employee = widget.employeeModel;
                    return Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: isArchivedNotifier,
                          builder: (context, value, child) {
                            return IconButton(
                              icon: Icon(
                                value
                                    ? Icons.unarchive_outlined
                                    : Icons.archive_outlined,
                                color: value ? Colors.green : Colors.orange,
                              ),
                              onPressed:
                                  () => _showArchiveConfirmation(
                                    context,
                                    widget.employeeModel,
                                    value,
                                  ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit_note_rounded,
                            size: 28.sp,
                            color: theme.primaryColor,
                          ),
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => EditEmployeePage(
                                        employee: widget.employeeModel,
                                      ),
                                ),
                              ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
                size: 24.sp,
              ),
              onPressed:
                  () => _showDeleteConfirmation(
                    context,
                    widget.employeeModel.id!.toString(),
                  ),
            ),
          ],
        ),
        body: BlocConsumer<EmployeeDetailsBloc, EmployeeDetailsState>(
          listener: (context, state) {
            if (state is EmployeeDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف الموظف بنجاح'),
                  backgroundColor: Colors.red,
                ),
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is EmployeeDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EmployeeDetailsHoursLoaded) {
              final employee = widget.employeeModel;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    _EmployeeHeader(employee, theme),
                    SizedBox(height: 24.h),

                    TotalsWidget(
                      theme: theme,
                      totals: state.employee.grandTotals!,
                    ),
                    SizedBox(height: 30.h),
                    EmployeeBuildDateSelector(
                      theme: theme,
                      selectedWeek: selectedWeek,
                      weeks: state.employee.weeks!,
                    ),
                    SizedBox(height: 30.h),
                    WeekDetailsWidget(
                      employee: employee,
                      theme: theme,
                      selectedWeek: selectedWeek,
                    ),
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

  Widget _buildArchivedBanner(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Center(
        child: Text(
          "هذا الموظف مؤرشف حالياً",
          style: TextStyle(
            color: Colors.orange.shade900,
            fontWeight: FontWeight.bold,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id) {
    showDialog(
      context: context,
      builder:
          (d) => AlertDialog(
            title: const Text('حذف الموظف'),
            content: const Text('هل أنت متأكد من حذف الموظف نهائياً؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(d),
                child: const Text("إلغاء"),
              ),
              TextButton(
                onPressed: () {
                  context.read<EmployeeDetailsBloc>().add(
                    DeleteEmployeeEvent(id),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EmployeesPage()),
                  );
                },
                child: const Text("حذف", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _showArchiveConfirmation(
    BuildContext context,
    EmployeeModel employee,
    bool isArchived,
  ) {
    final bool willArchive = !isArchived;
    showDialog(
      context: context,
      builder:
          (d) => AlertDialog(
            title: Text(willArchive ? 'أرشفة الموظف' : 'إلغاء الأرشفة'),
            content: Text(
              willArchive
                  ? 'هل أنت متأكد من أرشفة الموظف ${employee.user?.fullName ?? 'المستخدم'}؟'
                  : 'هل تريد إعادة تنشيط الموظف ${employee.user?.fullName ?? 'المستخدم'}؟',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(d),
                child: const Text("إلغاء"),
              ),
              TextButton(
                onPressed: () {
                  isArchived
                      ? context.read<EmployeesBloc>().add(
                        RestoreArchiveEmployeeEvent(employee.id.toString()),
                      )
                      : context.read<EmployeesBloc>().add(
                        ToggleArchiveEmployeeEvent(employee.id.toString()),
                      );

                  Navigator.pop(d);
                },
                child: Text(
                  willArchive ? "أرشفة" : "تنشيط",
                  style: TextStyle(
                    color: willArchive ? Colors.orange : Colors.green,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}

class _EmployeeHeader extends StatelessWidget {
  final EmployeeModel employee;
  final ThemeData theme;

  const _EmployeeHeader(this.employee, this.theme);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 55.r,
          backgroundColor: theme.primaryColor.withOpacity(0.1),
          child: Icon(Icons.person, size: 60.sp, color: theme.primaryColor),
        ),
        SizedBox(height: 16.h),
        Text(
          employee.user?.fullName ?? "",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        Text(
          employee.user?.phoneNumber ?? "",
          style: TextStyle(
            fontSize: 16.sp,
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        // Container(
        //   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        //   decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
        //   child: Text("الورشة: ${employee.workshopName}", style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold, fontSize: 12.sp)),
        // ),
      ],
    );
  }
}

// class _PasswordSection extends StatefulWidget {
//   final EmployeeModel employee;
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

class _WeeklyWorkSection extends StatelessWidget {
  final EmployeeModel employee;
  final int selectedWeek;

  final ThemeData theme;

  const _WeeklyWorkSection({
    required this.employee,
    required this.selectedWeek,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    // final filteredWeeks =
    //     employee.weeklyHistory
    //         .where((w) => w.month == selectedMonth && w.year == selectedYear)
    //         .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          "سجل المستحقات الأسبوعية",
          Icons.history_rounded,
          theme,
        ),
        SizedBox(height: 12.h),
        // if (filteredWeeks.isEmpty)
        //   _buildEmptyState()
        // else
        //   ...filteredWeeks
        //       .map((week) => _buildWeekExpandableCard(context, week))
        //       .toList(),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: theme.primaryColor),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Widget _buildWeekExpandableCard(
  //   BuildContext context,
  //   WeeklyWorkHistory week,
  // )
  // {
  //   final remaining = week.remainingAmount(
  //     employee.hourlyRate,
  //     employee.overtimeRate,
  //   );
  //
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 12.h),
  //     decoration: BoxDecoration(
  //       color: theme.cardColor,
  //       borderRadius: BorderRadius.circular(16.r),
  //       border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.04),
  //           blurRadius: 8,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: ExpansionTile(
  //       shape: const RoundedRectangleBorder(side: BorderSide.none),
  //       iconColor: theme.primaryColor,
  //       title: Text(
  //         'الأسبوع ${week.weekNumber}',
  //         style: TextStyle(
  //           fontSize: 16.sp,
  //           fontWeight: FontWeight.w900,
  //           color: theme.primaryColor,
  //         ),
  //       ),
  //       subtitle: _buildStatusBadge(week),
  //       childrenPadding: EdgeInsets.all(16.w),
  //       children: [
  //         ...week.workshops.map(
  //           (ws) => Padding(
  //             padding: EdgeInsets.only(bottom: 12.h),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       ws.workshopName,
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 14.sp,
  //                         color: theme.textTheme.bodyLarge?.color,
  //                       ),
  //                     ),
  //                     Text(
  //                       "نظامي: ${ws.regularHours} س | إضافي: ${ws.overtimeHours} س",
  //                       style: TextStyle(
  //                         fontSize: 11.sp,
  //                         color: Colors.grey.shade600,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Text(
  //                   "${ws.calculateValue(employee.hourlyRate, employee.overtimeRate).toStringAsFixed(0)} ل.س",
  //                   style: TextStyle(
  //                     fontSize: 14.sp,
  //                     fontWeight: FontWeight.w900,
  //                     color: theme.textTheme.bodyLarge?.color,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         const Divider(),
  //         if (week.amountPaid > 0)
  //           _amountRow("تم صرف سابقاً:", week.amountPaid, Colors.green),
  //         _amountRow(
  //           "المبلغ المتبقي:",
  //           remaining,
  //           remaining > 0 ? Colors.red : Colors.green,
  //           isBold: true,
  //         ),
  //
  //         if (!week.isPaid)
  //           Padding(
  //             padding: EdgeInsets.only(top: 15.h),
  //             child: SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: theme.primaryColor,
  //                   foregroundColor: Colors.white,
  //                   elevation: 0,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(12.r),
  //                   ),
  //                 ),
  //                 onPressed:
  //                     () => _showPaymentOptions(
  //                       context,
  //                       week.weekNumber,
  //                       remaining,
  //                     ),
  //                 child: Text(
  //                   "تأكيد صرف استحقاق",
  //                   style: TextStyle(
  //                     fontSize: 13.sp,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Widget _amountRow(String t, double v, Color c, {bool isBold = false}) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
                color:
                    isBold
                        ? theme.textTheme.bodyLarge?.color
                        : Colors.grey.shade600,
              ),
            ),
            Text(
              "${v.toStringAsFixed(0)}\$",
              style: TextStyle(
                color: c,
                fontWeight: FontWeight.w900,
                fontSize: isBold ? 16.sp : 13.sp,
              ),
            ),
          ],
        ),
      );

  Widget _buildEmptyState() => Center(
    child: Padding(
      padding: EdgeInsets.all(30.h),
      child: Column(
        children: [
          Icon(
            Icons.event_busy_rounded,
            color: Colors.grey.shade300,
            size: 40.sp,
          ),
          SizedBox(height: 10.h),
          Text(
            "لا توجد سجلات لهذا التاريخ",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );

  // Widget _buildStatusBadge(WeeklyWorkHistory week) {
  //   if (week.isPaid)
  //     return Text(
  //       "تم الدفع بالكامل ✅",
  //       style: TextStyle(
  //         color: Colors.green.shade700,
  //         fontSize: 12.sp,
  //         fontWeight: FontWeight.w900,
  //       ),
  //     );
  //   if (week.amountPaid > 0)
  //     return Text(
  //       "دفعة جزئية ⚠️",
  //       style: TextStyle(
  //         color: Colors.orange.shade800,
  //         fontSize: 12.sp,
  //         fontWeight: FontWeight.w900,
  //       ),
  //     );
  //   return Text(
  //     "غير مدفوع ❌",
  //     style: TextStyle(
  //       color: Colors.red.shade700,
  //       fontSize: 12.sp,
  //       fontWeight: FontWeight.w900,
  //     ),
  //   );
  // }

  void _showPaymentOptions(
    BuildContext context,
    int weekNumber,
    double remaining,
  ) {
    showDialog(
      context: context,
      builder:
          (d) => AlertDialog(
            title: const Text("خيارات الصرف"),
            content: Text(
              "المبلغ المتبقي للأسبوع $weekNumber هو ${remaining.toStringAsFixed(0)} \$",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(d);
                  _processPayment(context, weekNumber, remaining, isFull: true);
                },
                child: const Text(
                  "دفع كامل",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(d);
                  _showPartialDialog(context, weekNumber, remaining);
                },
                child: const Text("دفع جزئي"),
              ),
            ],
          ),
    );
  }

  void _showPartialDialog(
    BuildContext context,
    int weekNumber,
    double remaining,
  ) {
    final c = TextEditingController();
    showDialog(
      context: context,
      builder:
          (d) => AlertDialog(
            title: const Text("دفع جزئي"),
            content: TextField(
              controller: c,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "المبلغ",
                hintText: "بحد أقصى ${remaining.toInt()}",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(d),
                child: const Text("إلغاء"),
              ),
              ElevatedButton(
                onPressed: () {
                  double a = double.tryParse(c.text) ?? 0;
                  if (a > 0 && a <= remaining) {
                    Navigator.pop(d);
                    _processPayment(
                      context,
                      weekNumber,
                      a,
                      isFull: a == remaining,
                    );
                  }
                },
                child: const Text("تأكيد"),
              ),
            ],
          ),
    );
  }

  void _processPayment(
    BuildContext context,
    int weekNumber,
    double amount, {
    required bool isFull,
  }) {
    final state = context.read<EmployeeDetailsBloc>().state;
    if (state is EmployeeDetailsLoaded) {
      final emp = state.employee;
      context.read<EmployeeDetailsBloc>().add(
        ConfirmPaymentEvent(
          emp,
          weekNumber,
          amountPaid: amount,
          isFullPayment: isFull,
        ),
      );
      context.read<NotificationBloc>().add(
        AdminSendNotificationEvent(
          title: "دفع مالي",
          body: "تم صرف ${amount.toInt()} \$ للأسبوع $weekNumber",
          targetEmployeeId: emp.user!.id,
        ),
      );
    }
  }
}
