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
    context.read<DuesReportBloc>().add(LoadDuesReport());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// الإجماليات العامة
        _buildTotalsCard(),

        SizedBox(height: 16.h),

        /// ملخص الورشات
        if (widget.totals.workshopsSummary != null &&
            widget.totals.workshopsSummary!.isNotEmpty) ...[
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'ملخص الورشات',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: widget.theme.primaryColor,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          ...widget.totals.workshopsSummary!
              .map((ws) => _buildWorkshopSummaryCard(ws)),
        ],
      ],
    );
  }

  Widget _buildTotalsCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: widget.theme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: widget.theme.primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statCol(
                "عدد الساعات الاساسية",
                '${widget.totals.totalRegularHours?.toStringAsFixed(0) ?? 0} ساعة',
                widget.theme,
              ),
              _divider(),
              _statCol(
                "عدد الساعات الاضافية",
                '${widget.totals.totalOvertimeHours?.toStringAsFixed(0) ?? 0} ساعة',
                widget.theme,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statCol(
                "سعر الساعات الاساسية",
                '${widget.totals.totalRegularPay?.toStringAsFixed(1) ?? 0} \$',
                widget.theme,
              ),
              _divider(),
              _statCol(
                "سعر الساعات الاضافية",
                '${widget.totals.totalOvertimePay?.toStringAsFixed(1) ?? 0} \$',
                widget.theme,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(width: double.infinity, height: 1.h, color: widget.theme.dividerColor.withOpacity(0.2)),
          SizedBox(height: 10.h),

          /// المستحقات المتبقية
          BlocBuilder<DuesReportBloc, DuesReportState>(
            builder: (context, state) {
              if (state is DuesReportLoaded) {
                final employee = state.report.data.employees
                    .firstWhereOrNull((e) => e.id == widget.userId);
                if (employee == null) return const SizedBox.shrink();
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

  Widget _buildWorkshopSummaryCard(WorkshopSummary ws) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: widget.theme.primaryColor.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: widget.theme.primaryColor.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// اسم الورشة والموقع
          Row(
            children: [
              Icon(Icons.store_rounded, size: 18.sp, color: widget.theme.primaryColor),
              SizedBox(width: 6.w),
              Text(
                ws.workshop?.name ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: widget.theme.primaryColor,
                ),
              ),
            ],
          ),
          if (ws.workshop?.location != null) ...[
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14.sp, color: Colors.grey),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    ws.workshop!.location!,
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ],

          SizedBox(height: 12.h),
          Container(height: 1.h, color: widget.theme.dividerColor.withOpacity(0.2)),
          SizedBox(height: 12.h),

          /// الساعات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statCol(
                "ساعات أساسية",
                '${ws.totalRegularHours?.toStringAsFixed(0) ?? 0} ساعة',
                widget.theme,
              ),
              _divider(),
              _statCol(
                "ساعات إضافية",
                '${ws.totalOvertimeHours?.toStringAsFixed(0) ?? 0} ساعة',
                widget.theme,
              ),
            ],
          ),
          SizedBox(height: 10.h),

          /// الأجور
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statCol(
                "أجر أساسي",
                '${ws.totalRegularPay?.toStringAsFixed(1) ?? 0} \$',
                widget.theme,
              ),
              _divider(),
              _statCol(
                "أجر إضافي",
                '${ws.totalOvertimePay?.toStringAsFixed(1) ?? 0} \$',
                widget.theme,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(height: 1.h, color: widget.theme.dividerColor.withOpacity(0.2)),
          SizedBox(height: 10.h),

          /// الإجمالي
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _statCol(
                "إجمالي الورشة",
                '${ws.totalPay?.toStringAsFixed(1) ?? 0} \$',
                widget.theme,
                color: widget.theme.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 40.h,
    color: widget.theme.dividerColor.withOpacity(0.2),
  );

  Widget _statCol(String t, String v, ThemeData theme, {Color? color}) => Column(
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