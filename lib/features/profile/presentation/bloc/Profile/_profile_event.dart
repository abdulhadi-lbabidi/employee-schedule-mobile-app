import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}
class LogOutEvent extends ProfileEvent {}
class ResetUpdateStatus extends ProfileEvent {}

class UpdateProfileInfo extends ProfileEvent {
  final String name;
  final String phone;

  UpdateProfileInfo({required this.name, required this.phone});

  @override
  List<Object?> get props => [name, phone];
}

class UpdateProfileImage extends ProfileEvent {
  final File imagePath;

  UpdateProfileImage(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class UpdatePasswordEvent extends ProfileEvent {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  UpdatePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword, confirmPassword];
}
