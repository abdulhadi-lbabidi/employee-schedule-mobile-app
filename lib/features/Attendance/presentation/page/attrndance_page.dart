import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:untitled8/common/helper/src/app_varibles.dart';
import 'package:untitled8/core/utils/date_helper.dart';
import 'package:untitled8/features/Attendance/data/models/attendance_model.dart';
import 'package:untitled8/features/Attendance/domin/use_cases/get_employee_attendance_use_case.dart';
import 'package:untitled8/features/Attendance/presentation/bloc/attendance_bloc.dart';
import '../../data/models/get_attendance_response.dart';
import '../widget/build_attendance_table_widget.dart';
import '../widget/sync_widget.dart';

class PricingConfig {
  static const double BASIC_HOURS = 8.0;
}

enum DayType { normal, holiday, festival }



class _WeeklyGroupingResult {
  final Map<int, List<AttendanceModel>> grouped;

  _WeeklyGroupingResult(this.grouped);
}

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({super.key});

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  Map<int, bool> expandedWeeks = {};
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AttendanceBloc>().add(
        GetAllAttendanceEvent(
          params: GetEmployeeAttendanceParams(month: selectedMonth),
        ),
      );
      // context.read<AttendanceCubit>().loadAllRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "سجل العمل ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: theme.primaryColor,
          ),
        ),
        centerTitle: true,
        actions: [
          SyncWidget(theme: theme),
          SizedBox(width: 8.w),
        ],
      ),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildDateSelector(theme),
              Expanded(
                child: state.getAllAttendanceData.builder(
                  onSuccess: (_) {
                    return state.getAllAttendanceData.data!.isEmpty
                        ? _buildEmptyState(theme)
                        : _buildRecordsList(
                          state.getAllAttendanceData.data!,
                          theme,
                        );
                  },
                  onTapRetry: () {
                    context.read<AttendanceBloc>().add(
                      GetAllAttendanceEvent(
                        params: GetEmployeeAttendanceParams(
                          month: selectedMonth,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateSelector(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildDropdown<int>(
              theme: theme,
              value: selectedYear,
              items: DateHelper.getYearsRange(),
              onChanged:
                  (val) => setState(() {
                    selectedYear = val!;
                    expandedWeeks.clear();
                  }),
              label: "السنة",
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 3,
            child: _buildDropdown<int>(
              theme: theme,
              value: selectedMonth,
              items: List.generate(12, (index) => index + 1),
              itemLabel: (m) => DateHelper.getMonthName(m),
              onChanged: (val) {
                setState(() {
                  selectedMonth = val!;
                  expandedWeeks.clear();
                });

                context.read<AttendanceBloc>().add(
                  GetAllAttendanceEvent(
                    params: GetEmployeeAttendanceParams(month: selectedMonth),
                  ),
                );
              },
              label: "الشهر",
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0);
  }

  Widget _buildDropdown<T>({
    required ThemeData theme,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    String? label,
    String Function(T)? itemLabel,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          dropdownColor: theme.cardColor,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: theme.primaryColor,
            size: 20.sp,
          ),
          isExpanded: true,
          items:
              items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    itemLabel != null ? itemLabel(item) : item.toString(),
                    style: TextStyle(
                      color: theme.textTheme.bodyLarge?.color,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildRecordsList(
    List<GetAttendanceResponse> records,
    ThemeData theme,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildQuickStats(theme, records)
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                curve: Curves.easeOutBack,
              ),

          SizedBox(height: 20.h),

          ...records.map(
            (e) => _buildWeekSection(context, e.weekOfMonth ?? 1, e, theme),
          ),
        ],
      ),
    );
  }

  _WeeklyGroupingResult _groupRecordsByWeeks(List<AttendanceModel> records) {
    Map<int, List<AttendanceModel>> grouped = {};
    for (var record in records) {
      final date = record.date ?? DateTime.now(); // 🔹 استخدام Getter
      final weekNum = DateHelper.getWeekOfMonth(date);
      grouped.putIfAbsent(weekNum, () => []).add(record);
    }
    return _WeeklyGroupingResult(grouped);
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 60.sp,
            color: theme.disabledColor.withOpacity(0.2),
          ),
          SizedBox(height: 16.h),
          Text(
            'لا توجد سجلات لهذا الشهر',
            style: TextStyle(
              color: theme.disabledColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildQuickStats(ThemeData theme, List<GetAttendanceResponse> records) {
    // 1. تعريف متغيرات المجموع وتصفيرها
    double actualTotalHours = 0.0;
    double actualTotalSalery = 0.0;

    // 2. الحلقة التكرارية لجمع الساعات والمستحقات من كل أسبوع
    for (var week in records) {
      if (week.attendances != null) {
        for (var day in week.attendances!) {
          // حساب الساعات لهذا اليوم بدقة
          double dayHours = calculateHoursDifference(day.checkIn, day.checkOut);
          actualTotalHours += dayHours;

          // حساب مستحقات هذا اليوم بناءً على المنطق البرمجي الخاص بك
          final dayType = DayTypeHelper.getDayType(day.date ?? DateTime.now());
          final earnings = EarningsCalculator.calculateEarnings(
            totalHours: dayHours,
            hourlyRate: AppVariables.user!.userable!.hourlyRate!,
            overtimeRate: AppVariables.user!.userable!.overtimeRate!,
            dayType: dayType,
          );
          actualTotalSalery += (earnings['totalEarnings'] ?? 0);
        }
      }
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem(
            "الساعات المنجزة",
            actualTotalHours.toStringAsFixed(2), // عرض الساعات برقمين بعد الفاصلة
            Icons.timer_outlined,
            theme,
          ),
          _statItem(
            " \$إجمالي المستحقات",
            actualTotalSalery.toStringAsFixed(2), // عرض المبالغ برقمين بعد الفاصلة
            Icons.account_balance_wallet_outlined,
            theme,
          ),
        ],
      ),
    );
  }

  Widget _statItem(String title, String value, IconData icon, ThemeData theme) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24.sp)
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveY(begin: -2, end: 2, duration: 2.seconds),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildWeekSection(
    BuildContext context,
    int weekNumber,
    GetAttendanceResponse records,
    ThemeData theme,
  ) {
    final isExpanded = expandedWeeks[weekNumber] ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            onTap:
                () => setState(() => expandedWeeks[weekNumber] = !isExpanded),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 8.h,
            ),
            leading: CircleAvatar(
              radius: 18.r,
              backgroundColor:
                  isExpanded
                      ? theme.primaryColor
                      : theme.disabledColor.withOpacity(0.1),
              child: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
            title: Text(
              "الأسبوع $weekNumber",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: theme.primaryColor,
              ),
            ),
            subtitle: Text(
              formatWeek(records.startDate!, records.endDate!),
              style: TextStyle(
                color: theme.disabledColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            // داخل كلاس _AttendanceHistoryPageState ابحث عن ListTile في دالة _buildWeekSection

            trailing: Builder(
                builder: (context) {
                  // حساب المجموع الكلي لهذا الأسبوع بناءً على سجلات الحضور
                  double totalWeekEarnings = 0;

                  for (var r in records.attendances ?? []) {
                    final dayType = DayTypeHelper.getDayType(r.date ?? DateTime.now());
                    final earnings = EarningsCalculator.calculateEarnings(
                      totalHours: calculateHoursDifference(r.checkIn, r.checkOut),
                      hourlyRate: AppVariables.user!.userable!.hourlyRate!,
                      overtimeRate: AppVariables.user!.userable!.overtimeRate!,
                      dayType: dayType,
                    );
                    totalWeekEarnings += (earnings['totalEarnings'] ?? 0);
                  }

                  return Text(
                    "\$${totalWeekEarnings.toStringAsFixed(1)}",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w900,
                      fontSize: 15.sp,
                    ),
                  );
                }
            ),
          ),
          if (isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 16.h),
              child: BuildAttendanceTableWidget(
                records: records.attendances!,
                theme: theme,
              ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0),
            ),
        ],
      ),
    );
  }
}



double calculateHoursDifference(dynamic start, dynamic end) {
  if (start == null || end == null) return 0;

  DateTime? parse(dynamic value) {
    try {
      if (value is DateTime) return value;

      if (value is String) {
        // حالة تاريخ كامل مثل: 2026-02-04 08:00:00
        if (value.contains('-')) {
          return DateTime.tryParse(value);
        }

        // حالة وقت فقط: HH:mm أو HH:mm:ss
        final parts = value.split(':');
        if (parts.length < 2) return null;

        final now = DateTime.now();
        return DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
          parts.length > 2 ? int.parse(parts[2]) : 0,
        );
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  final startDate = parse(start);
  final endDate = parse(end);

  if (startDate == null || endDate == null) return 0;

  final diff = endDate.difference(startDate);

  return diff.inMinutes <= 0 ? 0 : diff.inMinutes / 60;
}

String extractHoursAndMinutes(String? value) {
  if (value == null || value.isEmpty) return '0';

  try {
    // وقت فقط HH:mm:ss
    if (!value.contains('-')) {
      final parts = value.split(':');
      if (parts.length < 2) return '0';
      return '${parts[0]}:${parts[1]}';
    }

    // DateTime كامل كنص
    final dateTime = DateTime.tryParse(value);
    if (dateTime == null) return '0';

    final h = dateTime.hour.toString().padLeft(2, '0');
    final m = dateTime.minute.toString().padLeft(2, '0');

    return '$h:$m';
  } catch (_) {
    return '0';
  }
}

String formatWeek(DateTime start, DateTime end) {
  final formatter = DateFormat('M/d'); // يوم/شهر
  return '${formatter.format(start)} إلى ${formatter.format(end)}';
}

double getWeekSallery({
  required double totalWeekHours,
  required double totalWeekExtraHours,
})
{
  return double.parse(
    ((((totalWeekHours / 8) * AppVariables.user!.userable!.hourlyRate!) +
            (totalWeekExtraHours * AppVariables.user!.userable!.overtimeRate!)))
        .toStringAsFixed(1),
  );
}
