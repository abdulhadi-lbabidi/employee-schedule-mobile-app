
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TableCellsWidget extends StatelessWidget {
  final String text;
  final bool isHeader;
  final bool isEarnings;
  final bool isBold;
  final ThemeData? theme;

  const TableCellsWidget({super.key, required this.text,  this.isHeader=false,  this.isEarnings=false,  this.isBold=false, this.theme});

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

