import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:intl/intl.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
import '../../../../core/services/pdf_report_service.dart';
import '../../../Attendance/presentation/bloc/Cubit_Attendance/attendance_cubit.dart';
import '../bloc/employees/employees_bloc.dart';
import '../bloc/employees/employees_event.dart';
import '../bloc/employees/employees_state.dart';
import '../bloc/workshops/workshops_bloc.dart';
import '../bloc/workshops/workshops_event.dart';
import '../../domain/entities/workshop_entity.dart';
import '../widgets/map_picker_widget.dart';
import 'EmployeeDetailsPage.dart';

class WorkshopDetailsPage extends StatelessWidget {
  final WorkshopEntity workshop;

  const WorkshopDetailsPage({super.key, required this.workshop});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: context.read<EmployeesBloc>()..add(LoadEmployeesEvent()),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(context, theme),
            SliverToBoxAdapter(
              child: BlocBuilder<EmployeesBloc, EmployeesState>(
                builder: (context, state) {
                  if (state is EmployeesLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(80),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state is EmployeesLoaded) {
                    final workshopEmployees = state.employees
                        .where((emp) => emp.workshops!.any((ws) => ws.name== workshop.name) )
                        .toList();
                    final onlineCount = workshopEmployees
                        .where((e) => e.isOnline!)
                        .length;

                    double totalBasicHours = 0;
                    double totalOTHours = 0;
                    double totalFinancialCost = 0;
                    //
                    // for (var emp in workshopEmployees) {
                    //     for (var week in emp.weeklyHistory!) {
                    //     for (var ws in week.workshops) {
                    //       if (ws.workshopName == workshop.name) {
                    //         totalBasicHours += ws.regularHours;
                    //         totalOTHours += ws.overtimeHours;
                    //         totalFinancialCost += ws.calculateValue(
                    //           emp.hourlyRate,
                    //           emp.overtimeRate,
                    //         );
                    //       }
                    //     }
                    //   }
                    // }

                    return Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // _buildFinancialAndWorkStats(
                          //   context,
                          //   totalBasicHours,
                          //   totalOTHours,
                          //   totalFinancialCost,
                          //   onlineCount,
                          //   theme,
                          // ),
                          SizedBox(height: 30.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'القوة العاملة الحالية',
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                              Text(
                                "${workshopEmployees.length} موظف",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: theme.disabledColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),

                          if (workshopEmployees.isEmpty)
                            _buildEmptyState(theme),
                          // else
                          //   ListView.builder(
                          //     padding: EdgeInsets.zero,
                          //     shrinkWrap: true,
                          //     physics: const NeverScrollableScrollPhysics(),
                          //     itemCount: workshopEmployees.length,
                          //     itemBuilder: (context, index) {
                          //       final emp = workshopEmployees[index];
                          //       double regHours = 0;
                          //       double otHours = 0;
                          //       for (var w in emp.weeklyHistory!) {
                          //         for (var ws in w.workshops) {
                          //           if (ws.workshopName == workshop.name) {
                          //             regHours += ws.regularHours;
                          //             otHours += ws.overtimeHours;
                          //           }
                          //         }
                          //       }
                          //       return _buildEmployeeCard(
                          //         context,
                          //         emp,
                          //         regHours,
                          //         otHours,
                          //         index,
                          //         theme,
                          //       );
                          //     },
                          //   ),
                          SizedBox(height: 30.h),
                          _buildDeleteButton(context, theme),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 150.h,
      pinned: true,
      backgroundColor: theme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          workshop.name!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
            ),
          ),
          child: Icon(
            Icons.architecture_rounded,
            size: 100.sp,
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
          onPressed: () => _exportAttendance(context),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildFinancialAndWorkStats(
    BuildContext context,
    double basic,
    double ot,
    double cost,
    int online,
    ThemeData theme,
  ) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.green,
                      size: 26.sp,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "إجمالي الميزانية المستحقة",
                        style: TextStyle(
                          color: theme.disabledColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${NumberFormat.decimalPattern().format(cost)} ل.س",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (workshop.hasLocation)
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapPickerWidget(
                          initialLocation: latlong.LatLng(workshop.latitude!, workshop.longitude!),
                          initialRadius: workshop.radiusInMeters,
                        ),
                      ),
                    );
                  },
                  icon: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Icons.place_outlined, color: theme.primaryColor, size: 24.sp),
                  ),
                ),
            ],
          ),
          SizedBox(height: 20.h),
          Divider(height: 1, color: theme.dividerColor.withOpacity(0.1)),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoMini(Icons.timer_rounded, Colors.blue, "ساعات أساسية", "${basic.toStringAsFixed(0)} س", theme),
              _infoMini(Icons.more_time_rounded, Colors.orange, "ساعات إضافية", "${ot.toStringAsFixed(0)} س", theme),
              _infoMini(Icons.sensors_rounded, Colors.teal, "نشطون حالياً", online.toString(), theme),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _infoMini(IconData icon, Color color, String label, String val, ThemeData theme) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18.sp),
        SizedBox(height: 4.h),
        Text(
          val,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 14.sp,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 9.sp, color: theme.disabledColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildEmployeeCard(
    BuildContext context,
    EmployeeModel emp,
    double regHours,
    double otHours,
    int index,
    ThemeData theme,
  ) {
    final total = regHours + otHours;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10.r),
        ],
      ),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EmployeeDetailsPage(employeeId: emp.id.toString()),
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: emp.isOnline!
              ? Colors.green.withOpacity(0.1)
              : theme.disabledColor.withOpacity(0.1),
          child: Icon(
            Icons.person_rounded,
            color: emp.isOnline! ? Colors.green : theme.disabledColor,
          ),
        ),
        title: Text(
          emp.user?.fullName??'',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: theme.textTheme.bodyLarge?.color),
        ),
        subtitle: Text(
          "ساعات الورشة: ${total.toStringAsFixed(1)} ساعة ",
          style: TextStyle(fontSize: 11.sp, color: theme.primaryColor, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14.sp,
          color: theme.disabledColor.withOpacity(0.5),
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildDeleteButton(BuildContext context, ThemeData theme) {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (d) => AlertDialog(
              backgroundColor: theme.cardColor,
              title: Text("حذف الورشة", style: TextStyle(color: theme.colorScheme.error)),
              content: Text(
                "هل أنت متأكد من حذف ورشة '${workshop.name}'؟ سيؤدي ذلك لإزالة ارتباط العمال بها.",
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(d), child: const Text("إلغاء")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    context.read<WorkshopsBloc>().add(DeleteWorkshopEvent(workshop.id!));
                    Navigator.pop(d);
                    Navigator.pop(context);
                  },
                  child: const Text("تأكيد الحذف", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
        label: const Text(
          "حذف الورشة نهائياً",
          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Text(
          "لا يوجد عمال مسجلين حالياً",
          style: TextStyle(color: theme.disabledColor, fontSize: 13.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  void _exportAttendance(BuildContext context) async {
    final cubit = context.read<AttendanceCubit>(); // استخدم Cubit مباشرة
    final employees = (context.read<EmployeesBloc>().state as EmployeesLoaded).employees;
    final workshopId = workshop.id ?? 0;

    // احصل على السجلات من Cubit باستخدام الدالة المدمجة
    final records = await cubit.getFilteredRecords(workshopNumber: workshopId); // 🔹 Cubit method

    if (records.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("لا توجد سجلات حضور لهذه الورشة لتصديرها"))
      );
      return;
    }

    PdfReportService.generateAttendanceReport(
        workshopName: workshop.name!,
        records: records,
        allEmployees: employees
    );
  }

}
