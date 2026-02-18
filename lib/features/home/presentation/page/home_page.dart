import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:untitled8/common/helper/src/app_varibles.dart';
import 'package:untitled8/features/Attendance/presentation/bloc/attendance_bloc.dart';
import 'package:untitled8/features/home/presentation/page/widgets/CardAttendanceStatus.dart';
import 'package:untitled8/features/home/presentation/page/widgets/Card_Tod_record.dart';
import 'package:untitled8/features/home/presentation/page/widgets/Dropdown_example.dart';
import 'package:untitled8/features/home/presentation/page/widgets/button_on.dart';
import '../../../admin/presentation/bloc/workshops/workshops_bloc.dart';
import '../../../admin/presentation/bloc/workshops/workshops_event.dart';
import '../bloc/Cubit_Button/button_cubit.dart';
import '../bloc/Cubit_Button/button_state.dart';
import '../bloc/Cubit_dropdown/dropdown_cubit.dart';
import '../bloc/Cubit_dropdown/dropdown_state.dart';

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
      context.read<WorkshopsBloc>().add(GetAllWorkShopEvent());
      context.read<DropdownCubit>().initDropDown();
      context.read<AttendanceBloc>().add(InitLocaleAttendanceEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // إضافة AppBar بسيط يعطي طابعاً رسمياً
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0, // إخفاء البار مع الاحتفاظ بخصائصه
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme),

                SizedBox(height: 30.h),

                _buildStatusSection(theme),

                SizedBox(height: 35.h),
                _buildSectionTitle("إجراءات سريعة", Icons.flash_on_rounded, theme),

                SizedBox(height: 15.h),
                _buildAttendanceControls(theme),

                SizedBox(height: 40.h),
                _buildSectionTitle("سجلات العمل اليوم", Icons.history_toggle_off_rounded, theme),

                SizedBox(height: 15.h),
                _buildTodayRecordsList(theme),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أهلاً بك،',
              style: TextStyle(
                color: theme.disabledColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              AppVariables.user?.fullName ?? 'المستخدم',
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        // إضافة أيقونة ملف شخصي أو تنبيهات تعطي شكلاً أجمل

      ],
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildStatusSection(ThemeData theme) {
    return BlocBuilder<DropdownCubit, DropdownState>(
      builder: (context, state) {
        final isActive = state.localeAttendanceModel != null;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.r),
            boxShadow: [
              BoxShadow(
                color: (isActive ? Colors.green : theme.primaryColor).withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Cardattendancestatus(
            statusText: isActive ? "نشط حالياً" : "غير نشط",
            isActive: isActive,
            checkInTime: '--:--',
          ),
        );
      },
    ).animate().fadeIn(delay: 200.ms).scale(curve: Curves.easeOutBack);
  }

  Widget _buildSectionTitle(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: theme.primaryColor),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
            color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceControls(ThemeData theme) {
    return BlocBuilder<ButtonCubit, ButtonState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: theme.cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: ButtonOnIn()),
                  SizedBox(width: 12.w),
                  Expanded(child: DropdownView()),
                ],
              ),
              SizedBox(height: 12.h),
              ButtonOut(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTodayRecordsList(ThemeData theme) {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        final records = state.localeTodayAttendanceList;

        if (records.isEmpty) {
          return _buildEmptyState(theme);
        }

        return ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: records.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final r = records[index];
            String dayName = DateFormat('EEEE', 'ar').format(r.date ?? DateTime.now());

            return CardTodRecord(
              day: dayName,
              checkIn: r.checkIn!,
              checkOut: r.checkOut,
              workshop: r.workshop?.name ?? 'ورشة غير معروفة',
            )
                .animate()
                .fadeIn(delay: (300 + (index * 100)).ms)
                .slideX(begin: 0.1, end: 0);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05), style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: theme.disabledColor.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.calendar_today_rounded, size: 40.sp, color: theme.disabledColor.withOpacity(0.3)),
          ),
          SizedBox(height: 15.h),
          Text(
            "لا توجد سجلات مسجلة اليوم",
            style: TextStyle(
              color: theme.disabledColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}