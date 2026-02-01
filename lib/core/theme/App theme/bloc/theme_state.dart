part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {}

class LoadedThemeState extends ThemeState {
  final ThemeData themeData;

  LoadedThemeState({required this.themeData});

  @override
  List<Object> get props => [themeData];
}
