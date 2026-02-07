import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/common/helper/src/app_varibles.dart';
import 'package:untitled8/core/utils/date_helper.dart';
import 'package:untitled8/features/Attendance/presentation/bloc/attendance_bloc.dart';
import 'package:untitled8/features/home/presentation/page/widgets/CardAttendanceStatus.dart';
import 'package:untitled8/features/home/presentation/page/widgets/Card_Tod_record.dart';
import 'package:untitled8/features/home/presentation/page/widgets/Dropdown_example.dart';
import 'package:untitled8/features/home/presentation/page/widgets/button_on.dart';
import '../../../../core/di/injection.dart';
import '../../../Attendance/data/models/attendance_model.dart';
import '../../../Attendance/presentation/bloc/Cubit_Attendance/attendance_cubit.dart';
import '../../../Attendance/presentation/bloc/Cubit_Attendance/attendance_state.dart'
    hide AttendanceState;
import '../../../admin/presentation/bloc/workshops/workshops_bloc.dart';
import '../../../admin/presentation/bloc/workshops/workshops_event.dart';
import '../../../admin/presentation/bloc/workshops/workshops_state.dart';
import '../../../profile/presentation/bloc/Profile/_profile_bloc.dart';
import '../../../profile/presentation/bloc/Profile/_profile_event.dart';
import '../../../profile/presentation/bloc/Profile/_profile_state.dart';
import '../bloc/Cubit_Button/button_cubit.dart';
import '../bloc/Cubit_Button/button_state.dart';
import '../bloc/Cubit_dropdown/dropdown_cubit.dart';
import '../bloc/Cubit_dropdown/dropdown_state.dart';
import '../bloc/cubit_active_unactive/active_unactive_cubit.dart';
import '../bloc/cubit_active_unactive/active_unactive_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // context.read<AttendanceCubit>().loadAllRecords();
      context.read<WorkshopsBloc>().add(LoadWorkshopsEvent());
      context.read<DropdownCubit>().initDropDown();
      context.read<AttendanceBloc>().add(InitLocaleAttendanceEvent());
    });
  }

  // static const List<String> _arabicDays = [
  //   'الاثنين',
  //   'الثلاثاء',
  //   'الأربعاء',
  //   'الخميس',
  //   'الجمعة',
  //   'السبت',
  //   'الأحد',
  // ];

  // Map<String, dynamic> _getDateInfo(DateTime now) {
  //   final day = _arabicDays[now.weekday - 1];
  //   final date = DateFormat('dd/MM').format(now);
  //   final weekNumber = DateHelper.getWeekOfMonth(now);
  //   final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  //   final endOfWeek = now.add(Duration(days: 7 - now.weekday));
  //   final startDate = DateFormat('yyyy/MM/dd').format(startOfWeek);
  //   final endDate = DateFormat('yyyy/MM/dd').format(endOfWeek);
  //
  //   return {
  //     'day': day,
  //     'date': date,
  //     'weekNumber': weekNumber,
  //     'startDate': startDate,
  //     'endDate': endDate,
  //   };
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              _buildGreeting(theme)
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideX(begin: -0.2, end: 0, curve: Curves.easeOutQuad),

              SizedBox(height: 30.h),
              _buildStatusCard(theme)
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms)
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1, 1),
                    curve: Curves.elasticOut,
                  ),

              SizedBox(height: 30.h),
              _buildSectionTitle(
                "إجراءات سريعة",
                theme,
              ).animate().fadeIn(delay: 400.ms),

              SizedBox(height: 15.h),
              _buildAttendanceControls()
                  .animate()
                  .fadeIn(delay: 500.ms)
                  .slideY(begin: 0.1, end: 0),

              SizedBox(height: 35.h),
              _buildSectionTitle(
                "سجلات العمل اليوم",
                theme,
              ).animate().fadeIn(delay: 700.ms),

              SizedBox(height: 15.h),
              _buildTodayRecordsList(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أهلاً بك،',
          style: TextStyle(
            color: theme.disabledColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          AppVariables.user!.fullName!,
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: 28.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 4.h,
          width: 40.w,
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w900,
        color: theme.primaryColor.withOpacity(0.8),
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    return BlocBuilder<DropdownCubit, DropdownState>(
      builder: (context, state) {
        final isActive = context.read<DropdownCubit>().state.localeAttendanceModel != null;
        String timeText =
            '--:--';
        return Cardattendancestatus(
          statusText: isActive ? "نشط حالياً" : "غير نشط",
          isActive: isActive,
          checkInTime: timeText,
        );
      },
    );
  }

  Widget _buildAttendanceControls() {
    return BlocBuilder<ButtonCubit, ButtonState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: ButtonOnIn()),
                SizedBox(width: 12.w),
                Expanded(child: DropdownView()),
              ],
            ),
            SizedBox(height: 15.h),
            ButtonOut(),
          ],
        );
      },
    );
  }

  Widget _buildTodayRecordsList(ThemeData theme) {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {

        final records = state.localeTodayAttendanceList;


        if (records.isEmpty) {
          return _buildEmptyState(theme).animate().fadeIn(delay: 800.ms);
        }

        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: records.length,
          itemBuilder: (context, index) {
            final r = records[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: CardTodRecord(
                    day: r.date!.day.toString(),
                    checkIn: r.checkIn!,
                    checkOut: r.checkOut,
                    workshop: r.workshop!.name!,
                  )
                  .animate()
                  .fadeIn(delay: (800 + (index * 100)).ms, duration: 500.ms)
                  .slideX(begin: 0.1, end: 0),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(40.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.history_rounded,
            size: 50.sp,
            color: theme.disabledColor.withOpacity(0.2),
          ),
          SizedBox(height: 15.h),
          Text(
            "لا توجد سجلات لليوم",
            style: TextStyle(
              color: theme.disabledColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
