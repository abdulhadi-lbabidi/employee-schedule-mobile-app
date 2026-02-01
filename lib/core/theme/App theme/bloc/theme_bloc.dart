import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../Theme_cach_helper.dart';
import '../apptheme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final cacheHelper = ThemeCachHelper();

  ThemeBloc() : super(ThemeInitial()) {
    on<ThemeEvent>((event, emit) async {
      if (event is GetCurrentThemeEvent) {
        final themeIndex = await cacheHelper.getCachThemeIndex();
        final theme = Apptheme.values[themeIndex];
        emit(LoadedThemeState(themeData: appThemeData[theme]!));
      } else if (event is ThemechacgedEvent) {
        final themeIndex = event.theme.index;
        await cacheHelper.cachThemeIndex(themeIndex);
        emit(LoadedThemeState(themeData: appThemeData[event.theme]!));
      } else if (event is ToggleThemeEvent) {
        final themeIndex = await cacheHelper.getCachThemeIndex();
        final newTheme = themeIndex == Apptheme.light.index ? Apptheme.dark : Apptheme.light;
        await cacheHelper.cachThemeIndex(newTheme.index);
        emit(LoadedThemeState(themeData: appThemeData[newTheme]!));
      }
    });
  }
}
