
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../common/helper/src/app_varibles.dart';
import '../../../admin/presentation/bloc/workshops/workshops_bloc.dart';
import '../../../admin/presentation/bloc/workshops/workshops_state.dart';
import '../../data/models/attendance_model.dart';
import '../page/attrndance_page.dart';
import 'table_cells_widget.dart';


class BuildAttendanceTableWidget extends StatelessWidget {
 final List<AttendanceModel> records;
 final ThemeData theme;

  const BuildAttendanceTableWidget({super.key, required this.records, required this.theme});

  @override
  Widget build(BuildContext context) {
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
                    children: [
                      TableCellsWidget(text:  "اليوم", isHeader: true,theme: theme),
                      TableCellsWidget(text:"الورشة", isHeader: true,theme: theme),
                      TableCellsWidget(text:"دخول", isHeader: true,theme: theme),
                      TableCellsWidget(text:"خروج", isHeader: true,theme: theme),
                      TableCellsWidget(text:"ساعات", isHeader: true,theme: theme),
                      TableCellsWidget(text:"أساسي", isHeader: true,theme: theme),
                      TableCellsWidget(text:"إضافي", isHeader: true,theme: theme),
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
                        TableCellsWidget(text:  workshopName, theme: theme),
                        TableCellsWidget(
                          text:  extractHoursAndMinutes(r.checkIn.toString()),
                          theme: theme,
                        ),
                        TableCellsWidget(
                          text:   extractHoursAndMinutes(r.checkOut.toString()),
                          theme: theme,
                        ),
                        TableCellsWidget(
                          text: calculateHoursDifference(
                            r.checkIn,
                            r.checkOut,
                          ).toStringAsFixed(2), // أضفنا هذه الدالة لتحديد رقمين فقط بعد الفاصلة
                          theme: theme,
                          isBold: true,
                        ),
                        TableCellsWidget(
                          text: "\$${earnings['basicEarnings']}",
                          theme: theme,
                          isEarnings: true,
                        ),
                        TableCellsWidget(
                          text:   "\$${earnings['overtimeEarnings']}",
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
}





Widget _buildDayCell(AttendanceModel r, DayType type, ThemeData theme) {
  final label = DayTypeHelper.getLabel(type);

  // 1. استخراج اسم اليوم باللغة العربية
  // 'EEEE' تعطي اسم اليوم كاملاً، و 'ar' للغة العربية
  String dayName = DateFormat('EEEE', 'ar').format(r.date ?? DateTime.now());

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
                      text: dayName, // عرض اسم اليوم هنا (الأربعاء مثلاً)
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp, // صغرنا الخط قليلاً ليتناسب مع الكلمة الطويلة
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    if (label.isNotEmpty)
                      TextSpan(
                        text: label,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: type == DayType.festival
                              ? Colors.redAccent
                              : theme.disabledColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
              // عرض التاريخ الرقمي تحت الاسم بشكل أصغر (اختياري)
              Text(
                "${r.date!.day}/${r.date!.month}",
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


class EarningsCalculator {
  static Map<String, double> calculateEarnings({
    required double totalHours,
    required double hourlyRate, // هناhourlyRate تعني "أجر الـ 8 ساعات"
    required double overtimeRate, // سعر الساعة الإضافية الواحدة
    DayType dayType = DayType.normal,
  }) {
    // 1. تحديد المعامل (ضعف الأجر يوم الجمعة 2.0)
    double multiplier = 1.0;
    if (dayType == DayType.holiday || dayType == DayType.festival) {
      multiplier = 2.0;
    }

    // 2. حساب الأساسي (على اعتبار أن الـ hourlyRate هي أجر الـ 8 ساعات كاملة)
    // المعادلة: (الساعات الفعلية / 8) * أجر النوبة الثابت
    double basic;
    if (totalHours <= PricingConfig.BASIC_HOURS) {
      // إذا عمل أقل من أو يساوي 8 ساعات، يأخذ نسبة من المبلغ
      basic = (totalHours / PricingConfig.BASIC_HOURS) * hourlyRate;
    } else {
      // إذا تجاوز الـ 8، الأساسي يتوقف عند أجر النوبة الكامل (مثلاً الـ 10$)
      basic = hourlyRate;
    }

    // 3. حساب الإضافي (هنا الإضافي يُحسب بالساعة)
    double overtime = 0.0;
    if (totalHours > PricingConfig.BASIC_HOURS) {
      double overtimeHours = totalHours - PricingConfig.BASIC_HOURS;
      overtime = overtimeHours * overtimeRate;
    }

    // 4. تطبيق المضاعفة على الإجمالي (الأساسي والإضافي)
    basic *= multiplier;
    overtime *= multiplier;

    return {
      'basicEarnings': double.parse(basic.toStringAsFixed(2)),
      'overtimeEarnings': double.parse(overtime.toStringAsFixed(2)),
      'totalEarnings': double.parse((basic + overtime).toStringAsFixed(2)),
    };
  }
}
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
