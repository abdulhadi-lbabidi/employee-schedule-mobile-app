import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:intl/intl.dart';
import 'package:untitled8/features/admin/data/models/workshop_models/workshop_model.g.dart';
import 'package:untitled8/features/admin/presentation/bloc/workshops/workshops_state.dart';
import '../../../../core/widgets/cached_network_image_with_auth.dart';
import '../../data/models/workshop_models/get_workshop_employees_details_response.dart';
import '../bloc/employees/employees_bloc.dart';
import '../bloc/employees/employees_event.dart';
import '../bloc/workshops/workshops_bloc.dart';
import '../bloc/workshops/workshops_event.dart';
import '../widgets/map_picker_widget.dart';
import 'EmployeeDetailsPage.dart';

class WorkshopDetailsPage extends StatefulWidget {
  final WorkshopModel workshop;

  const WorkshopDetailsPage({super.key, required this.workshop});

  @override
  State<WorkshopDetailsPage> createState() => _WorkshopDetailsPageState();
}

class _WorkshopDetailsPageState extends State<WorkshopDetailsPage> {
  @override
  void initState() {
    context.read<WorkshopsBloc>().add(
      GetWorkShopEmployeeDetailsEvent(id: widget.workshop.id!),
    );

    // TODO: implement initState
    super.initState();
  }

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
              child: BlocConsumer<WorkshopsBloc, WorkshopsState>(
                builder: (context, state) {
                  return state.getWorkshopEmployeeDetailsData.builder(
                    onSuccess: (r) {
                      final workshopEmployees = r!.employees!;

                      double totalBasicHours = 0;
                      double totalOTHours = 0;
                      double totalFinancialCost = 0;

                      for (var emp in workshopEmployees) {
                        totalBasicHours += emp.totalRegularHours ?? 0;
                        totalOTHours += emp.totalOvertimeHours ?? 0;
                        totalFinancialCost +=
                            (emp.totalRegularHours ?? 0) +
                            (emp.totalOvertimeHours ?? 0);
                      }

                      return Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFinancialAndWorkStats(
                              context,
                              totalBasicHours,
                              totalOTHours,
                              totalFinancialCost,
                              theme,
                            ),
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

                            workshopEmployees.isEmpty
                                ? _buildEmptyState(theme)
                                : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: workshopEmployees.length,
                                  itemBuilder: (context, index) {
                                    final emp = workshopEmployees[index];

                                    return _buildEmployeeCard(
                                      context,
                                      emp,
                                      emp.totalRegularHours!,
                                      emp.totalOvertimeHours!,
                                      index,
                                      theme,
                                    );
                                  },
                                ),
                            SizedBox(height: 30.h),
                            _buildDeleteButton(context, theme),
                          ],
                        ),
                      );
                    },
                    loadingWidget: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(80),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    failedWidget: const SizedBox.shrink(),
                  );
                },
                listener: (context,state){
                  state.deleteWorkshopData.listenerFunction(onSuccess: (){
                    Navigator.pop(context);
                  });

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
          widget.workshop.name!,
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
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
          onPressed: () {},
          // onPressed: () => _exportAttendance(context),
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
              if (widget.workshop.location != null)
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MapPickerWidget(
                              initialLocation: latlong.LatLng(
                                widget.workshop.latitude!,
                                widget.workshop.longitude!,
                              ),
                              initialRadius: widget.workshop.radiusInMeters!,
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
                    child: Icon(
                      Icons.place_outlined,
                      color: theme.primaryColor,
                      size: 24.sp,
                    ),
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
              _infoMini(
                Icons.timer_rounded,
                Colors.blue,
                "ساعات أساسية",
                "${basic.toStringAsFixed(0)} س",
                theme,
              ),
              _infoMini(
                Icons.more_time_rounded,
                Colors.orange,
                "ساعات إضافية",
                "${ot.toStringAsFixed(0)} س",
                theme,
              ),
              // _infoMini(
              //   Icons.sensors_rounded,
              //   Colors.teal,
              //   "نشطون حالياً",
              //  '500',
              //   theme,
              // ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _infoMini(
    IconData icon,
    Color color,
    String label,
    String val,
    ThemeData theme,
  ) {
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
          style: TextStyle(
            fontSize: 9.sp,
            color: theme.disabledColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeCard(
    BuildContext context,
    EmployeeElement emp,
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
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => EmployeeDetailsPage(
                      employeeModel: emp.employee!,
                    ),
              ),
            ),
        leading: CircleAvatar(
          backgroundColor: theme.disabledColor.withOpacity(0.1),
          child:
              emp.employee?.user?.profileImageUrl == null
                  ? Icon(Icons.person_rounded, color: theme.disabledColor)
                  : CachedNetworkImageWithAuth(
                    imageUrl: emp.employee!.user!.profileImageUrl!,
                  ),
        ),
        title: Text(
          emp.employee?.user?.fullName ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: Text(
          "ساعات الورشة: ${total.toStringAsFixed(1)} ساعة ",
          style: TextStyle(
            fontSize: 11.sp,
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
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
            builder:
                (d) => AlertDialog(
                  backgroundColor: theme.cardColor,
                  title: Text(
                    "حذف الورشة",
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  content: Text(
                    "هل أنت متأكد من حذف ورشة '${widget.workshop.name}'؟ سيؤدي ذلك لإزالة ارتباط العمال بها.",
                    style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(d),
                      child: const Text("إلغاء"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        context.read<WorkshopsBloc>().add(
                          DeleteWorkshopEvent(widget.workshop.id!),
                        );
                        Navigator.pop(d);

                      },
                      child: const Text(
                        "تأكيد الحذف",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
          );
        },
        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
        label: const Text(
          "حذف الورشة نهائياً",
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
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
          style: TextStyle(
            color: theme.disabledColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// void _exportAttendance(BuildContext context) async { // 🔹 تم إضافة async
//   final repo = sl<AttendanceRepository>();
//   final employees = (context.read<EmployeesBloc>().state as EmployeesLoaded).employees;
//   final workshopId = int.tryParse(workshop.id) ?? 0;
//   final records = await repo.getFilteredRecords(workshopNumber: workshopId); // 🔹 تم إضافة await
//
//   if (records.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("لا توجد سجلات حضور لهذه الورشة لتصديرها")));
//     return;
//   }
//
//   PdfReportService.generateAttendanceReport(workshopName: workshop.name, records: records, allEmployees: employees);
// }
