import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Cardattendancestatus extends StatelessWidget {
  final String statusText;
  final String? checkInTime;
  final bool isActive;

  const Cardattendancestatus({
    super.key,
    required this.statusText,
    this.isActive = false,
    this.checkInTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isActive ? Colors.green.shade600 : theme.dividerColor.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "حالة الدوام",
                    style: TextStyle(
                      color: theme.disabledColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: isActive ? Colors.green.shade600 : theme.textTheme.bodyLarge?.color,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Container(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? Colors.green.withOpacity(0.1) : theme.disabledColor.withOpacity(0.1),
                ),
                child: Icon(
                  isActive ? Icons.bolt_rounded : Icons.pause_rounded,
                  color: isActive ? Colors.green.shade600 : theme.disabledColor,
                  size: 28.sp,
                ),
              ),
            ],
          ),

          if (checkInTime != null && checkInTime != '--:--')
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time_filled_rounded, color: theme.primaryColor, size: 16.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'وقت الحضور :',
                      style: TextStyle(
                        color: theme.disabledColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      checkInTime!,
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
