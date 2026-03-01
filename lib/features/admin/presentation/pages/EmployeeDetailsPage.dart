import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/toast.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../Notification/domain/usecases/send_notification_use_case.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<EmployeesBloc>()),
        BlocProvider(
          create: (_) =>
          sl<EmployeeDetailsBloc>()..add(
            LoadEmployeeDetailsHoursEvent(
              widget.employeeModel.id.toString(),
            ),
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(context, theme),
        body: _buildBody(context, theme),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
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
        IconButton(
          icon: const Icon(Icons.edit_note_rounded, color: Colors.blueAccent),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditEmployeePage(employee: widget.employeeModel),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () => _showDeleteConfirmation(
            context,
            widget.employeeModel.id!.toString(),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme) {
    return BlocConsumer<EmployeeDetailsBloc, EmployeeDetailsState>(
      builder: (context, state) {
        if (state is EmployeeDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is EmployeeDetailsHoursLoaded) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: isArchivedNotifier,
                  builder: (context, isArchived, _) =>
                  isArchived
                      ? _buildArchivedBanner(theme)
                      : const SizedBox.shrink(),
                ),
                _EmployeeHeader(
                  widget.employeeModel,
                  theme,
                  fullNameOverride: state.employee.fullName,
                ),
                SizedBox(height: 24.h),
                TotalsWidget(
                  theme: theme,
                  totals: state.employee.grandTotals!,
                  userId: state.employee.employeeId!,
                ),
                SizedBox(height: 30.h),
                EmployeeBuildDateSelector(
                  theme: theme,
                  selectedWeek: selectedWeek,
                  weeks: state.employee.weeks!,
                ),
                SizedBox(height: 30.h),
                WeekDetailsWidget(
                  employee: widget.employeeModel,
                  theme: theme,
                  selectedWeek: selectedWeek,
                ),
                SizedBox(height: 40.h),
              ],
            ),
          );
        }
        return const Center(child: Text("لا توجد بيانات"));
      },
      listener: (context, state) {
        if (state is EmployeeDeleted) {
          Navigator.pop(context);
        }
        if (state is EmployeeDetailsError) {
          Toaster.showText(text: state.message);
        }
      },
      listenWhen: (pre, cur) =>
      (pre is EmployeeDetailsLoading || cur is EmployeeDetailsError) ||
          (pre is EmployeeDetailsLoading || cur is EmployeeDeleted),
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
      builder: (d) => AlertDialog(
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
              Navigator.pop(context);
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
      builder: (d) => AlertDialog(
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
              context.read<EmployeesBloc>().add(
                isArchived
                    ? RestoreArchiveEmployeeEvent(employee.id.toString())
                    : ToggleArchiveEmployeeEvent(employee.id.toString()),
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
  final String? fullNameOverride;

  const _EmployeeHeader(
      this.employee,
      this.theme, {
        this.fullNameOverride,
      });

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
          fullNameOverride ?? employee.user?.fullName ?? "",
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
      ],
    );
  }
}

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          "سجل المستحقات الأسبوعية",
          Icons.history_rounded,
          theme,
        ),
        SizedBox(height: 12.h),
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
                color: isBold
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

  void _showPaymentOptions(
      BuildContext context,
      int weekNumber,
      double remaining,
      ) {
    showDialog(
      context: context,
      builder: (d) => AlertDialog(
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
      builder: (d) => AlertDialog(
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
        SendNotificationsEvent(
          params: SendNotificationParams(
            body: "تم صرف ${amount.toInt()} \$ للأسبوع $weekNumber",
            title: "دفع مالي",
            targetEmployeeId: emp.user!.id,
          ),
        ),
      );
    }
  }
}