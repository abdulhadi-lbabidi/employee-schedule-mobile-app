part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentThemeEvent extends ThemeEvent {}

class ThemechacgedEvent extends ThemeEvent {
  final Apptheme theme;
  const ThemechacgedEvent({required this.theme});

  @override
  List<Object> get props => [theme];
}

class ToggleThemeEvent extends ThemeEvent {}
