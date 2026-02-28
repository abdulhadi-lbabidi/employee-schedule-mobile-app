import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collection/collection.dart';

import '../../../payments/presentation/bloc/dues-report/dues_report_bloc.dart';
import '../../../payments/presentation/bloc/dues-report/dues_report_event.dart';
import '../../../payments/presentation/bloc/dues-report/dues_report_state.dart';
import '../../data/models/employee model/get_employee_details_hours_details_response.dart';

class TotalsWidget extends StatefulWidget {
  final Totals totals;
  final int userId;
  final ThemeData theme;

  const TotalsWidget({
    super.key,
    required this.totals,
    required this.userId,
    required this.theme,
  });

  @override
  State<TotalsWidget> createState() => _TotalsWidgetState();
}

class _TotalsWidgetState extends State<TotalsWidget> {
  @override
  void initState() {
    super.initState();
    // جلب البيانات عند أول دخول
    context.read<DuesReportBloc>().add(LoadDuesReport());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: widget.theme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: widget.theme.primaryColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          /// الصف الأول
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statCol(
                "عدد الساعات الاساسية",
                '${widget.totals.totalRegularHours != null ? widget.totals.totalRegularHours!.toStringAsFixed(0) : 0} ساعة',
                widget.theme,
              ),
              Container(
                width: 1,
                height: 40.h,
                color: widget.theme.dividerColor.withOpacity(0.2),
              ),
              _statCol(
                "عدد الساعات الاضافية",
                '${widget.totals.totalOvertimeHours != null ? widget.totals.totalOvertimeHours!.toStringAsFixed(0) : 0} ساعة',
                widget.theme,
              ),
            ],
          ),

          /// الصف الثاني
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statCol(
                "سعر الساعات الاساسية",
                '${widget.totals.totalRegularPay != null ? widget.totals.totalRegularPay!.toStringAsFixed(1) : 0} \$',
                widget.theme,
              ),
              Container(
                width: 1,
                height: 40.h,
                color: widget.theme.dividerColor.withOpacity(0.2),
              ),
              _statCol(
                "سعر الساعات الاضافية",
                '${widget.totals.totalOvertimePay != null ? widget.totals.totalOvertimePay!.toStringAsFixed(1) : 0} \$',
                widget.theme,
              ),
            ],
          ),

          SizedBox(height: 10.h),
          Container(
            width: 400.w,
            height: 1.h,
            color: widget.theme.dividerColor.withOpacity(0.2),
          ),
          SizedBox(height: 10.h),

          /// المستحقات المتبقية
          BlocBuilder<DuesReportBloc, DuesReportState>(
            builder: (context, state) {
              if (state is DuesReportLoaded) {
                final report = state.report;

                final employee =
                report.data.employees.firstWhereOrNull(
                      (e) => e.id == widget.userId,
                );

                if (employee == null) {
                  return const SizedBox.shrink();
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _statCol(
                      "إجمالي المستحقات المتبقية",
                      '${employee.remainingDue?.toStringAsFixed(1) ?? 0} \$',
                      widget.theme,
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
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