import 'package:flutter/material.dart';
import '../theme.dart';

enum Apptheme {
  light("Light Mode"),
  dark("Dark Mode");

  const Apptheme(this.name);
  final String name;
}

final appThemeData = {
  Apptheme.light: AppTheme.lightTheme,
  Apptheme.dark: AppTheme.darkTheme,
};
