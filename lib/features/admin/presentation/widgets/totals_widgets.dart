import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/employee model/get_employee_details_hours_details_response.dart';

class TotalsWidget extends StatelessWidget {
  final Totals totals;
  final ThemeData theme;

  const TotalsWidget({super.key, required this.totals, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: theme.primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statCol(
                "عدد الساعات الاساسية",
                '${totals.totalRegularHours != null ? totals.totalRegularHours!.toStringAsFixed(0) : 0} ساعة',
                theme,
              ),
              Container(
                width: 1,
                height: 40.h,
                color: theme.dividerColor.withOpacity(0.2),
              ),
              _statCol(
                "عدد الساعات الاضافية",
                '${totals.totalOvertimeHours != null ? totals.totalOvertimeHours!.toStringAsFixed(0) : 0} ساعة',
                theme,

              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statCol(
                "سعر الساعات الاساسية",
                '${totals.totalRegularPay!= null ? totals.totalRegularPay!.toStringAsFixed(1) : 0}  ل.س',
                theme,
              ),
              Container(
                width: 1,
                height: 40.h,
                color: theme.dividerColor.withOpacity(0.2),
              ),
              _statCol(
                "سعر الساعات الاضافية",
                '${totals.totalOvertimePay != null ? totals.totalOvertimePay!.toStringAsFixed(1) : 0} ل.س',
                theme,

              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCol(String t, String v, ThemeData theme, {Color? color}) =>
      Column(
        children: [
          Text(
            t,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            v,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: color ?? theme.textTheme.bodyLarge?.color,
            ),
          ),
        ],
      );
}
