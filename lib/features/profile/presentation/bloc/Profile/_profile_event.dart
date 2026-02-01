import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfileInfo extends ProfileEvent {
  final String name;
  final String phone;

  UpdateProfileInfo({required this.name, required this.phone});

  @override
  List<Object?> get props => [name, phone];
}

class UpdateProfileImage extends ProfileEvent {
  final String imagePath;

  UpdateProfileImage(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}
