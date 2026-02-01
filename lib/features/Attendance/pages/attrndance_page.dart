import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:untitled8/core/utils/date_helper.dart';
import '../../Attendance/pages/bloc/Cubit_Attendance/attendance_cubit.dart';
import '../../Attendance/pages/bloc/Cubit_Attendance/attendance_state.dart';
import '../../admin/presentation/bloc/workshops/workshops_bloc.dart';
import '../../admin/presentation/bloc/workshops/workshops_state.dart';
import '../../profile/presentation/bloc/Profile/_profile_bloc.dart';
import '../../profile/presentation/bloc/Profile/_profile_state.dart';
import '../data/models/attendance_record.dart';
import 'package:intl/intl.dart';

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
      case DayType.normal: return Colors.transparent;
      case DayType.holiday: return Colors.white24.withOpacity(0.1);
      case DayType.festival: return Colors.redAccent.withOpacity(0.2);
    }
  }

  static String getLabel(DayType type) {
    switch (type) {
      case DayType.normal: return "";
      case DayType.holiday: return " (عطلة)";
      case DayType.festival: return " (عيد)";
    }
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

    double basic = totalHours <= PricingConfig.BASIC_HOURS
        ? (totalHours / PricingConfig.BASIC_HOURS) * (PricingConfig.BASIC_HOURS * hourlyRate)
        : (PricingConfig.BASIC_HOURS * hourlyRate);

    double overtime = totalHours > PricingConfig.BASIC_HOURS
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
      context.read<AttendanceCubit>().syncData();
      context.read<AttendanceCubit>().loadAllRecords();
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
        title: Text("سجل العمل ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: theme.primaryColor)),
        centerTitle: true,
        actions: [
          BlocBuilder<AttendanceCubit, AttendanceState>(
            builder: (context, state) {
              if (state.isSyncing) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("جاري المزامنة...", style: TextStyle(color: theme.primaryColor, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                    SizedBox(width: 5.w),
                    const Center(child: Padding(padding: EdgeInsets.all(12.0), child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator.adaptive(strokeWidth: 2)))),
                  ],
                );
              }
              return TextButton.icon(
                onPressed: () => context.read<AttendanceCubit>().syncData(),
                icon: Icon(Icons.sync_rounded, color: theme.primaryColor, size: 20.sp),
                label: Text("مزامنة البيانات", style: TextStyle(color: theme.primaryColor, fontSize: 11.sp, fontWeight: FontWeight.bold)),
              );
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          double hourlyRate = 3000.0; 
          double overtimeRate = 4500.0;

          if (profileState is ProfileLoaded) {
            hourlyRate = profileState.profile.user?.userable?.hourlyRate?.toDouble() ?? 3000.0;
            overtimeRate = profileState.profile.user?.userable?.overtimeRate?.toDouble() ?? 4500.0;
          }

          return BlocBuilder<AttendanceCubit, AttendanceState>(
            builder: (context, state) {
              final filteredRecords = state.records.where((record) {
                final date = record.checkInTime ?? DateTime.now(); // 🔹 تم استخدام Getter
                return date.year == selectedYear && date.month == selectedMonth;
              }).toList();

              return Column(
                children: [
                  _buildDateSelector(theme),
                  Expanded(
                    child: filteredRecords.isEmpty
                      ? _buildEmptyState(theme)
                      : _buildRecordsList(filteredRecords, theme, hourlyRate, overtimeRate),
                  ),
                ],
              );
            },
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
        border: Border(bottom: BorderSide(color: theme.dividerColor.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildDropdown<int>(
              theme: theme,
              value: selectedYear,
              items: DateHelper.getYearsRange(),
              onChanged: (val) => setState(() { selectedYear = val!; expandedWeeks.clear(); }),
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
              onChanged: (val) => setState(() { selectedMonth = val!; expandedWeeks.clear(); }),
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
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.primaryColor, size: 20.sp),
          isExpanded: true,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemLabel != null ? itemLabel(item) : item.toString(),
                style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 13.sp, fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildRecordsList(List<AttendanceRecord> records, ThemeData theme, double hourlyRate, double overtimeRate) {
    final weeklyResult = _groupRecordsByWeeks(records);
    final weeklyData = weeklyResult.grouped;
    final sortedWeeks = weeklyData.keys.toList()..sort((a, b) => b.compareTo(a));

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildQuickStats(records, theme, hourlyRate, overtimeRate)
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), curve: Curves.easeOutBack),
          SizedBox(height: 20.h),
          ...sortedWeeks.asMap().entries.map((entry) {
            final index = entry.key;
            final weekNumber = entry.value;
            final weekRecords = weeklyData[weekNumber]!;
            weekRecords.sort((a, b) => (b.checkInTime ?? DateTime(0)).compareTo(a.checkInTime ?? DateTime(0))); // 🔹 استخدام Getter

            return _buildWeekSection(context, weekNumber, weekRecords, theme, hourlyRate, overtimeRate)
                .animate()
                .fadeIn(delay: (200 + (index * 100)).ms, duration: 500.ms)
                .slideX(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
          }).toList(),
        ],
      ),
    );
  }

  _WeeklyGroupingResult _groupRecordsByWeeks(List<AttendanceRecord> records) {
    Map<int, List<AttendanceRecord>> grouped = {};
    for (var record in records) {
      final date = record.checkInTime ?? DateTime.now(); // 🔹 استخدام Getter
      final weekNum = DateHelper.getWeekOfMonth(date);
      grouped.putIfAbsent(weekNum, () => []).add(record);
    }
    return _WeeklyGroupingResult(grouped);
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.calendar_today_outlined, size: 60.sp, color: theme.disabledColor.withOpacity(0.2)),
      SizedBox(height: 16.h),
      Text('لا توجد سجلات لهذا الشهر', style: TextStyle(color: theme.disabledColor, fontSize: 15.sp, fontWeight: FontWeight.bold)),
    ])).animate().fadeIn();
  }

  Widget _buildQuickStats(List<AttendanceRecord> records, ThemeData theme, double hourlyRate, double overtimeRate) {
    Duration totalHours = Duration.zero;
    double totalEarnings = 0;

    for (var r in records) {
      if (r.workDuration != null) {
        totalHours += r.workDuration!;
        final date = r.checkInTime ?? DateTime.now(); // 🔹 استخدام Getter
        final dayType = DayTypeHelper.getDayType(date);
        final earnings = EarningsCalculator.calculateEarnings(
          totalHours: r.workDuration!.inMinutes / 60.0,
          hourlyRate: hourlyRate,
          overtimeRate: overtimeRate,
          dayType: dayType,
        );
        totalEarnings += earnings['totalEarnings']!;
      }
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [BoxShadow(color: theme.primaryColor.withOpacity(0.25), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem("الساعات المنجزة", "${totalHours.inHours}:${(totalHours.inMinutes % 60).toString().padLeft(2, '0')}", Icons.timer_outlined, theme),
          _statItem("إجمالي المستحقات", "\$${totalEarnings.toStringAsFixed(2)}", Icons.account_balance_wallet_outlined, theme),
        ],
      ),
    );
  }

  Widget _statItem(String title, String value, IconData icon, ThemeData theme) {
    return Column(children: [
      Icon(icon, color: Colors.white, size: 24.sp).animate(onPlay: (controller) => controller.repeat(reverse: true)).moveY(begin: -2, end: 2, duration: 2.seconds),
      SizedBox(height: 8.h),
      Text(value, style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w900)),
      Text(title, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11.sp, fontWeight: FontWeight.bold)),
    ]);
  }

  Widget _buildWeekSection(BuildContext context, int weekNumber, List<AttendanceRecord> records, ThemeData theme, double hourlyRate, double overtimeRate) {
    final isExpanded = expandedWeeks[weekNumber] ?? false;
    double weeklyEarnings = 0;

    for (var r in records) {
      if (r.workDuration != null) {
        final date = r.checkInTime ?? DateTime.now(); // 🔹 استخدام Getter
        final dayType = DayTypeHelper.getDayType(date);
        final earnings = EarningsCalculator.calculateEarnings(
          totalHours: r.workDuration!.inMinutes / 60.0,
          hourlyRate: hourlyRate,
          overtimeRate: overtimeRate,
          dayType: dayType,
        );
        weeklyEarnings += earnings['totalEarnings']!;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () => setState(() => expandedWeeks[weekNumber] = !isExpanded),
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            leading: CircleAvatar(
              radius: 18.r,
              backgroundColor: isExpanded ? theme.primaryColor : theme.disabledColor.withOpacity(0.1),
              child: Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: Colors.white, size: 18.sp),
            ),
            title: Text("الأسبوع $weekNumber", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp, color: theme.primaryColor)),
            subtitle: Text("${DateHelper.getMonthName(selectedMonth)} - $selectedYear", style: TextStyle(color: theme.disabledColor, fontSize: 11.sp, fontWeight: FontWeight.bold)),
            trailing: Text("\$${weeklyEarnings.toStringAsFixed(2)}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w900, fontSize: 15.sp)),
          ),
          if (isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 16.h),
              child: _buildAttendanceTable(records, theme, hourlyRate, overtimeRate).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0)
            ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTable(List<AttendanceRecord> records, ThemeData theme, double hourlyRate, double overtimeRate) {
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
                    decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.1)),
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
                    final date = r.checkInTime ?? DateTime.now(); // 🔹 استخدام Getter
                    final dayType = DayTypeHelper.getDayType(date);
                    final earnings = EarningsCalculator.calculateEarnings(
                      totalHours: (r.workDuration?.inMinutes ?? 0) / 60.0,
                      hourlyRate: hourlyRate,
                      overtimeRate: overtimeRate,
                      dayType: dayType,
                    );
                    
                    String workshopName = 'W${r.workshopNumber}';
                    if (workshopState is WorkshopsLoaded) {
                      try {
                        workshopName = workshopState.workshops.firstWhere((w) => w.id == r.workshopNumber.toString()).name;
                      } catch (_) {}
                    }
                    
                    return TableRow(
                      decoration: BoxDecoration(
                        color: DayTypeHelper.getColor(dayType), 
                        border: Border(bottom: BorderSide(color: theme.dividerColor.withOpacity(0.05))),
                      ),
                      children: [
                        _buildDayCell(r, dayType, theme),
                        _TableCell(workshopName, theme: theme),
                        _TableCell(r.checkInFormatted, theme: theme),
                        _TableCell(r.checkOutFormatted, theme: theme),
                        _TableCell(r.hoursFormatted, theme: theme, isBold: true),
                        _TableCell("\$${earnings['basicEarnings']}", theme: theme, isEarnings: true),
                        _TableCell("\$${earnings['overtimeEarnings']}", theme: theme, isEarnings: true),
                      ]
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

  Widget _buildDayCell(AttendanceRecord r, DayType type, ThemeData theme) {
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
                      TextSpan(text: r.day, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.sp, color: theme.textTheme.bodyLarge?.color)),
                      if (label.isNotEmpty)
                        TextSpan(text: label, style: TextStyle(fontSize: 9.sp, color: type == DayType.festival ? Colors.redAccent : theme.disabledColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Text(r.date, style: TextStyle(fontSize: 8.sp, color: theme.disabledColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          _buildSyncIcon(r.syncStatus, theme),
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
        icon = Icons.cloud_off_rounded;
        color = theme.disabledColor;
    }

    return Icon(icon, size: 13.sp, color: color);
  }
}

class _WeeklyGroupingResult {
  final Map<int, List<AttendanceRecord>> grouped;
  _WeeklyGroupingResult(this.grouped);
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;
  final bool isEarnings;
  final bool isBold;
  final ThemeData? theme;
  const _TableCell(this.text, {this.isHeader = false, this.isEarnings = false, this.isBold = false, this.theme});
  @override
  Widget build(BuildContext context) {
    final currentTheme = theme ?? Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w), 
      child: Text(
        text, 
        textAlign: TextAlign.center, 
        style: TextStyle(
          fontWeight: isHeader || isEarnings || isBold ? FontWeight.w900 : FontWeight.normal, 
          fontSize: isHeader ? 10.sp : 11.sp, 
          color: isHeader ? currentTheme.primaryColor : (isEarnings ? Colors.green : currentTheme.textTheme.bodyLarge?.color)
        )
      )
    );
  }
}
