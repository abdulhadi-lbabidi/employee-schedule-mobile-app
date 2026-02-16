
 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showSnackBar(BuildContext context, String msg, Color color) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg, style: TextStyle(fontSize: 13.sp)),
      backgroundColor: color,
    ),
  );
}
