import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:untitled8/common/helper/src/app_varibles.dart';
import 'package:untitled8/core/data_state_model.dart';
import 'package:untitled8/core/utils/date_helper.dart';
import 'package:untitled8/features/Attendance/data/models/attendance_model.dart';
import 'package:untitled8/features/Attendance/domin/use_cases/get_employee_attendance_use_case.dart';
import 'package:untitled8/features/Attendance/presentation/bloc/attendance_bloc.dart';
import '../../../admin/presentation/bloc/workshops/workshops_bloc.dart';
import '../../../admin/presentation/bloc/workshops/workshops_state.dart';
import '../../data/models/get_attendance_response.dart';

class PricingConfig {
  static const double BASIC_HOURS = 8.0;
}

enum DayType { normal, holiday, festival }

class DayTypeHelper {
  static DayType getDayType(DateTime date) {
    if (date.weekday == DateTime.friday) return DayType.holiday;
    if (date.month == 1 && date.day == 1) return DayType.festival;
    return DayType.normal;
  }

  static Color getColor(DayType type) {
    switch (type) {
      case DayType.normal:
        return Colors.transparent;
      case DayType.holiday:
        return Colors.white24.withOpacity(0.1);
      case DayType.festival:
        return Colors.redAccent.withOpacity(0.2);
    }
  }

  static String getLabel(DayType type) {
    switch (type) {
      case DayType.normal:
        return "";
      case DayType.holiday:
        return " (عطلة)";
      case DayType.festival:
        return " (عيد)";
    }
  }
}

class _WeeklyGroupingResult {
  final Map<int, List<AttendanceModel>> grouped;

  _WeeklyGroupingResult(this.grouped);
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;
  final bool isEarnings;
  final bool isBold;
  final ThemeData? theme;

  const _TableCell(
    this.text, {
    this.isHeader = false,
    this.isEarnings = false,
    this.isBold = false,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = theme ?? Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight:
              isHeader || isEarnings || isBold
                  ? FontWeight.w900
                  : FontWeight.normal,
          fontSize: isHeader ? 10.sp : 11.sp,
          color:
              isHeader
                  ? currentTheme.primaryColor
                  : (isEarnings
                      ? Colors.green
                      : currentTheme.textTheme.bodyLarge?.color),
        ),
      ),
    );
  }
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
          BlocBuilder<AttendanceBloc, AttendanceState>(
            builder: (context, state) {
              return state.syncAttendanceData.status == BlocStatus.init
                  ? TextButton.icon(
                    onPressed: () {
                      final isEnable =
                          state.getAllAttendanceData.data?.any(
                            (week) =>
                                week.attendances?.any(
                                  (e) => e.status?.toLowerCase() == "pending",
                                ) ??
                                false,
                          ) ??
                          false;
                      print(AppVariables.localeAttendance?.toJson());
                      final isNotEnd = AppVariables.localeAttendance != null;
                      if ((isNotEnd && isEnable)) {
                        _showSnackBar(
                          context,
                          'الرجاء انهاء المناوبة اولا',
                          Colors.red,
                        );
                      } else if (isEnable) {
                        context.read<AttendanceBloc>().add(
                          SyncAttendanceEvent(),
                        );
                      } else {
                        _showSnackBar(
                          context,
                          'لايوجد ساعات لرفعها',
                          Colors.orange,
                        );
                      }
                    },
                    icon: Icon(
                      Icons.sync_rounded,
                      color: theme.primaryColor,
                      size: 20.sp,
                    ),
                    label: Text(
                      "مزامنة البيانات",
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  : state.syncAttendanceData.builder(
                    onSuccess: (_) {
                      return TextButton.icon(
                        onPressed: () {
                          if (state.getAllAttendanceData.data?.any(
                                (week) =>
                                    week.attendances?.any(
                                      (e) =>
                                          e.status?.toLowerCase() == "pending",
                                    ) ??
                                    false,
                              ) ??
                              false) {
                            context.read<AttendanceBloc>().add(
                              SyncAttendanceEvent(),
                            );
                          } else {
                            _showSnackBar(
                              context,
                              'لايوجد ساعات لرفعها',
                              Colors.orange,
                            );
                          }
                        },
                        icon: Icon(
                          Icons.sync_rounded,
                          color: theme.primaryColor,
                          size: 20.sp,
                        ),
                        label: Text(
                          "مزامنة البيانات",
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    loadingWidget: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "جاري المزامنة...",
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    failedWidget: TextButton.icon(
                      onPressed:
                          () => context.read<AttendanceBloc>().add(
                            SyncAttendanceEvent(),
                          ),
                      icon: Icon(
                        Icons.sync_rounded,
                        color: theme.primaryColor,
                        size: 20.sp,
                      ),
                      label: Text(
                        "مزامنة البيانات",
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
            },
          ),
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
              onChanged:
                  (val) {
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
          _buildQuickStats(theme)
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


  Widget _buildQuickStats(ThemeData theme) {
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
      child: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _statItem(
                "الساعات المنجزة",
                state.totalHours == null ? '0' : state.totalHours.toString(),
                Icons.timer_outlined,
                theme,
              ),
              _statItem(
                "إجمالي المستحقات",
                state.totalSalery == null ? '0' : state.totalSalery.toString(),

                Icons.account_balance_wallet_outlined,
                theme,
              ),
            ],
          );
        },
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
            trailing: Text(
              "\$${getWeekSallery(totalWeekExtraHours: records.totalRegularHours!, totalWeekHours: records.totalOvertimeHours!)}",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w900,
                fontSize: 15.sp,
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 16.h),
              child: _buildAttendanceTable(
                records.attendances!,
                theme,
              ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0),
            ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTable(List<AttendanceModel> records, ThemeData theme) {
    return BlocBuilder<WorkshopsBloc, WorkshopsState>(
      builder: (context, workshopState) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FixedColumnWidth(100.w),
                  1: FixedColumnWidth(100.w),
                  2: FixedColumnWidth(70.w),
                  3: FixedColumnWidth(70.w),
                  4: FixedColumnWidth(70.w),
                  5: FixedColumnWidth(80.w),
                  6: FixedColumnWidth(80.w),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                    ),
                    children: const [
                      _TableCell("اليوم", isHeader: true),
                      _TableCell("الورشة", isHeader: true),
                      _TableCell("دخول", isHeader: true),
                      _TableCell("خروج", isHeader: true),
                      _TableCell("ساعات", isHeader: true),
                      _TableCell("أساسي", isHeader: true),
                      _TableCell("إضافي", isHeader: true),
                    ],
                  ),
                  ...records.map((r) {
                    final date = r.date ?? DateTime.now(); // 🔹 استخدام Getter
                    final dayType = DayTypeHelper.getDayType(date);
                    final earnings = EarningsCalculator.calculateEarnings(
                      totalHours: calculateHoursDifference(
                        r.checkIn,
                        r.checkOut,
                      ),
                      hourlyRate: AppVariables.user!.userable!.hourlyRate!,
                      overtimeRate: AppVariables.user!.userable!.overtimeRate!,
                      dayType: dayType,
                    );

                    String workshopName = r.workshop!.name!;

                    return TableRow(
                      decoration: BoxDecoration(
                        color: DayTypeHelper.getColor(dayType),
                        border: Border(
                          bottom: BorderSide(
                            color: theme.dividerColor.withOpacity(0.05),
                          ),
                        ),
                      ),
                      children: [
                        _buildDayCell(r, dayType, theme),
                        _TableCell(workshopName, theme: theme),
                        _TableCell(
                          extractHoursAndMinutes(r.checkIn.toString()),
                          theme: theme,
                        ),
                        _TableCell(
                          extractHoursAndMinutes(r.checkOut.toString()),
                          theme: theme,
                        ),
                        _TableCell(
                          calculateHoursDifference(
                            r.checkIn,
                            r.checkOut,
                          ).toString(),
                          theme: theme,
                          isBold: true,
                        ),
                        _TableCell(
                          "\$${earnings['basicEarnings']}",
                          theme: theme,
                          isEarnings: true,
                        ),
                        _TableCell(
                          "\$${earnings['overtimeEarnings']}",
                          theme: theme,
                          isEarnings: true,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDayCell(AttendanceModel r, DayType type, ThemeData theme) {
    final label = DayTypeHelper.getLabel(type);

    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: r.date!.day.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      if (label.isNotEmpty)
                        TextSpan(
                          text: label,
                          style: TextStyle(
                            fontSize: 9.sp,
                            color:
                                type == DayType.festival
                                    ? Colors.redAccent
                                    : theme.disabledColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  r.date!.day.toString(),
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: theme.disabledColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildSyncIcon(r.status!, theme),
        ],
      ),
    );
  }

  Widget _buildSyncIcon(String status, ThemeData theme) {
    IconData icon;
    Color color;

    switch (status) {
      case 'synced':
        icon = Icons.cloud_done_rounded;
        color = Colors.green;
        break;
      case 'pending':
        icon = Icons.cloud_upload_rounded;
        color = Colors.orange;
        break;
      case 'error':
        icon = Icons.error_outline_rounded;
        color = Colors.red;
        break;
      default:
        icon = Icons.cloud_done_rounded;
        color = Colors.green;
    }

    return Icon(icon, size: 13.sp, color: color);
  }
}

class EarningsCalculator {
  static Map<String, double> calculateEarnings({
    required double totalHours,
    required double hourlyRate,
    required double overtimeRate,
    DayType dayType = DayType.normal,
  }) {
    double multiplier = 1.0;
    if (dayType == DayType.holiday) multiplier = 1.5;
    if (dayType == DayType.festival) multiplier = 2.0;

    double basic =
        totalHours <= PricingConfig.BASIC_HOURS
            ? (totalHours / PricingConfig.BASIC_HOURS) *
                (PricingConfig.BASIC_HOURS * hourlyRate)
            : (PricingConfig.BASIC_HOURS * hourlyRate);

    double overtime =
        totalHours > PricingConfig.BASIC_HOURS
            ? (totalHours - PricingConfig.BASIC_HOURS) * overtimeRate
            : 0.0;

    basic *= multiplier;
    overtime *= multiplier;

    return {
      'basicEarnings': double.parse(basic.toStringAsFixed(2)),
      'overtimeEarnings': double.parse(overtime.toStringAsFixed(2)),
      'totalEarnings': double.parse((basic + overtime).toStringAsFixed(2)),
    };
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

void _showSnackBar(BuildContext context, String msg, Color color) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg, style: TextStyle(fontSize: 13.sp)),
      backgroundColor: color,
    ),
  );
}

String formatWeek(DateTime start, DateTime end) {
  final formatter = DateFormat('M/d'); // يوم/شهر
  return '${formatter.format(start)} إلى ${formatter.format(end)}';
}

double getWeekSallery({
  required int totalWeekHours,
  required int totalWeekExtraHours,
}) {
  return ((totalWeekHours / 8) * AppVariables.user!.userable!.hourlyRate!) +
      (totalWeekExtraHours * AppVariables.user!.userable!.overtimeRate!);

}
