import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:intl/intl.dart';



class CardTodRecord extends StatelessWidget {
  final String day;
  final String checkIn;
  final String? checkOut;
  final String workshop;

  const CardTodRecord({
    super.key,
    required this.day,
    required this.checkIn,
    required this.checkOut,
    required this.workshop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // اليوم
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  workshop,
                  style: TextStyle(
                    color: theme.disabledColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ساعة الدخول
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.login_rounded,
                    size: 14.sp,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  formatTime(checkIn),
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ساعة الخروج
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    size: 14.sp,
                    color: Colors.redAccent,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  formatTime(checkOut),
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
String formatTime(String? time) {
  if (time == null || time.isEmpty) return "00:00";

  try {
    // إذا كان الوقت بصيغة DateTime كامل
    if (time.contains('-')) {
      final dt = DateTime.parse(time);
      return "${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
    } else {
      // إذا كان الوقت فقط "08:00:00"
      final parts = time.split(':');
      if (parts.length >= 2) {
        return "${parts[0].padLeft(2,'0')}:${parts[1].padLeft(2,'0')}";
      } else {
        return "00:00";
      }
    }
  } catch (_) {
    return "00:00";
  }
}
