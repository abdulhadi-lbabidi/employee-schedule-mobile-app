import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_strings.dart';
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
          create: (_) => sl<EmployeeDetailsBloc>()
            ..add(LoadEmployeeDetailsHoursEvent(widget.employeeModel.id.toString())),
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
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        AppStrings.employeeDetailsTitle,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: theme.primaryColor),
      ),
      actions: [
        _buildActionMenu(context),
      ],
    );
  }

  // استخدام PopupMenuButton بدلاً من رص الأيقونات بجانب بعضها لتحسين المساحة
  Widget _buildActionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, color: Theme.of(context).primaryColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      onSelected: (value) => _handleMenuAction(context, value),
      itemBuilder: (context) => [
        _buildPopupItem("تعديل", Icons.edit_note_rounded, Colors.blue, "edit"),
        _buildPopupItem(
            isArchivedNotifier.value ? "إلغاء الأرشفة" : "أرشفة الموظف",
            isArchivedNotifier.value ? Icons.unarchive : Icons.archive,
            Colors.orange,
            "archive"),
        const PopupMenuDivider(),
        _buildPopupItem("حذف نهائي", Icons.delete_forever_rounded, Colors.red, "delete"),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupItem(String title, IconData icon, Color color, String value) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(width: 10.w),
          Text(title, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String value) {
    if (value == "edit") {
      Navigator.push(context, MaterialPageRoute(builder: (_) => EditEmployeePage(employee: widget.employeeModel)));
    } else if (value == "archive") {
      _showArchiveConfirmation(context, widget.employeeModel, isArchivedNotifier.value);
    } else if (value == "delete") {
      _showDeleteConfirmation(context, widget.employeeModel.id!.toString());
    }
  }

  Widget _buildBody(BuildContext context, ThemeData theme) {
    return BlocListener<EmployeesBloc, EmployeesState>(
      listener: (context, state) {
        state.setEmployeeArchivedData.listenerFunction(
          onSuccess: () {
            context.read<EmployeesBloc>().add(GetAllEmployeeEvent());
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت العملية بنجاح'), backgroundColor: Colors.green));
          },
          onFailed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.setEmployeeArchivedData.errorMessage), backgroundColor: Colors.red)),
        );
      },
      child: BlocBuilder<EmployeeDetailsBloc, EmployeeDetailsState>(
        builder: (context, state) {
          if (state is EmployeeDetailsLoading) return const Center(child: CircularProgressIndicator());
          if (state is EmployeeDetailsHoursLoaded) {
            return RefreshIndicator(
              onRefresh: () async => context.read<EmployeeDetailsBloc>().add(LoadEmployeeDetailsHoursEvent(widget.employeeModel.id.toString())),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: isArchivedNotifier,
                      builder: (context, isArchived, _) => isArchived ? _buildArchivedBanner(theme) : SizedBox(height: 10.h),
                    ),
                    _EmployeeHeader(widget.employeeModel, theme),
                    SizedBox(height: 20.h),
                    TotalsWidget(theme: theme, totals: state.employee.grandTotals!),
                    SizedBox(height: 25.h),
                    _buildSectionTitle(context, "سجل العمل والأسابيع", Icons.calendar_month_rounded),
                    SizedBox(height: 10.h),
                    EmployeeBuildDateSelector(theme: theme, selectedWeek: selectedWeek, weeks: state.employee.weeks!),
                    SizedBox(height: 20.h),
                    WeekDetailsWidget(employee: widget.employeeModel, theme: theme, selectedWeek: selectedWeek),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text("لا توجد بيانات حالياً"));
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
          child: Icon(icon, size: 18.sp, color: Theme.of(context).primaryColor),
        ),
        SizedBox(width: 10.w),
        Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildArchivedBanner(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      margin: EdgeInsets.only(bottom: 20.h, top: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.orange.shade800, Colors.orange.shade500]),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.white),
          SizedBox(width: 10.w),
          Text("هذا الحساب مؤرشف وغير نشط حالياً", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.sp)),
        ],
      ),
    );
  }

  // دوال الـ Dialog تبقى كما هي مع تحسين بسيط في الشكل
  void _showDeleteConfirmation(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (d) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: const Text('حذف الموظف'),
        content: const Text('سيتم حذف كافة سجلات الموظف، هل أنت متأكد؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: const Text("رجوع")),
          ElevatedButton(
            onPressed: () {
              context.read<EmployeeDetailsBloc>().add(DeleteEmployeeEvent(id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))),
            child: const Text("تأكيد الحذف", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showArchiveConfirmation(BuildContext context, EmployeeModel employee, bool isArchived) {
    final bool willArchive = !isArchived;
    showDialog(
      context: context,
      builder: (d) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(willArchive ? 'أرشفة الحساب' : 'تنشيط الحساب'),
        content: Text(willArchive ? 'هل تريد نقل الموظف إلى الأرشيف؟' : 'سيتم إعادة الموظف لقائمة العمل النشطة، هل تود المتابعة؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: const Text("إلغاء")),
          ElevatedButton(
            onPressed: () {
              context.read<EmployeesBloc>().add(
                isArchived ? RestoreArchiveEmployeeEvent(employee.id.toString()) : ToggleArchiveEmployeeEvent(employee.id.toString()),
              );
              Navigator.pop(d);
            },
            style: ElevatedButton.styleFrom(backgroundColor: willArchive ? Colors.orange : Colors.green),
            child: Text(willArchive ? "أرشفة" : "تنشيط", style: const TextStyle(color: Colors.white)),
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: theme.primaryColor.withOpacity(0.2), width: 2)),
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  child: Icon(Icons.person_rounded, size: 55.sp, color: theme.primaryColor),
                ),
              ),
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                child: Icon(Icons.check, color: Colors.white, size: 12.sp),
              )
            ],
          ),
          SizedBox(height: 15.h),
          Text(
            employee.user?.fullName ?? "اسم الموظف غير معروف",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: theme.textTheme.bodyLarge?.color),
          ),
          SizedBox(height: 5.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.08), borderRadius: BorderRadius.circular(20.r)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.phone_rounded, size: 14.sp, color: theme.primaryColor),
                SizedBox(width: 6.w),
                Text(employee.user?.phoneNumber ?? "لا يوجد هاتف", style: TextStyle(fontSize: 14.sp, color: theme.primaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}