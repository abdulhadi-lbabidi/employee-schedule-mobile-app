import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/employee model/employee_model.dart';
import '../../data/models/employee model/get_employee_details_hours_details_response.dart';

class WeekDetailsWidget extends StatelessWidget {
  final EmployeeModel employee;
  final ThemeData theme;
  final ValueNotifier<Week?> selectedWeek;

  const WeekDetailsWidget({
    super.key,
    required this.employee,
    required this.theme,
    required this.selectedWeek,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedWeek,
      builder: (context, value, child) {
        return selectedWeek.value == null
            ? SizedBox()
            : Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
              ),
              child: Column(
                children:
                    value!.workshops!
                        .map(
                          (e) => Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent, // يلغي الخط الافتراضي
                            ),
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.zero,
                              childrenPadding: EdgeInsets.symmetric(horizontal: 16),

                              title: Text("اسم الورشة : ${e.workshop!.name}"),
                              leading: Icon(Icons.work),

                              children: [

                                /// هذا هو الـ Divider الوحيد
                                Divider(height: 1),

                                SizedBox(height: 12.h),

                                _rateRow(
                                  "عدد الساعات الاساسية",
                                  e.totalRegularHours!,
                                  hour: 'ساعة',
                                ),

                                SizedBox(height: 12.h),

                                _rateRow(
                                  "عدد الساعات الاضافية",
                                  e.totalOvertimeHours!,
                                  hour: 'ساعة',
                                ),

                                SizedBox(height: 12.h),

                                _rateRow(
                                  "سعر الساعات الاساسية",
                                  e.regularPay!,
                                ),

                                SizedBox(height: 12.h),

                                _rateRow(
                                  "سعر الساعات الاضافية",
                                  e.overtimePay!,
                                ),
                              ],
                            ),
                          )

                    )
                        .toList(),
              ),
            );
      },
    );
  }

  Widget _rateRow(String t, double v, {String? hour}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        t,
        style: TextStyle(
          fontSize: 13.sp,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "${v.toInt()} ${hour??'\$'}",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 15.sp,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
    ],
  );


}
