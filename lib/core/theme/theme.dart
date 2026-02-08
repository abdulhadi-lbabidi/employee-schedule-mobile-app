import 'package:flutter/material.dart';

class AppTheme {
  // ألوان مشتركة
  static const Color primaryColor = Color(0xFF273085);
  static const Color accentColor = Color(0xFF2196F3);

  //  1. الثيم الفاتح (للمدير)
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0.5,
      centerTitle: true,
      iconTheme: IconThemeData(color: primaryColor),
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      onSurface: Colors.black87,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
    ),
  );

  // 🔹 2. الثيم الغامق (للموظف) - تم تحسين التباين
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueAccent, // استخدام درجة أفتح قليلاً في الوضع الليلي
    scaffoldBackgroundColor: const Color(0xFF2B2D30), // أسود مريح للعين
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFF1E1E1E),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      surface: const Color(0xFF1E1E1E),
      onSurface: Colors.white, // ضمان أن النص على الأسطح أبيض
      primary: Colors.blueAccent,
    ),
    // 🔹 تحديد ألوان النصوص بشكل صريح لضمان الوضوح
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Colors.white), // نصوص عريضة بيضاء
      bodyMedium: TextStyle(color: Color(0xFFE0E0E0)), // نصوص متوسطة رمادي فاتح جداً
      bodySmall: TextStyle(color: Colors.white70),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );
}

// المرجع الافتراضي
final ThemeData appTheme = AppTheme.lightTheme;
