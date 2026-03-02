import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/features/admin/presentation/widgets/workshop_card.dart';

import '../../data/models/employee model/get_employee_details_hours_details_response.dart';

class WorkshopsSummaryList extends StatelessWidget {
  final ThemeData theme;
  final List<WorkshopSummary> workshops;

  const WorkshopsSummaryList({
    super.key,
    required this.theme,
    required this.workshops,
  });

  @override
  Widget build(BuildContext context) {
    if (workshops.isEmpty) {
      return _emptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(theme),
        SizedBox(height: 12.h),
        SizedBox(
          height: 130.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: workshops.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              return WorkshopCard(
                workshop: workshops[index],
                theme: theme,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _title(ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.workspaces_outline,
            size: 18.sp, color: theme.primaryColor),
        SizedBox(width: 8.w),
        Text(
          "ملخص الورشات",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: Text(
          "لا توجد ورشات",
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}