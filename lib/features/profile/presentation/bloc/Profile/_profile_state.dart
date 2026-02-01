import 'package:equatable/equatable.dart';
import '../../../data/models/profile_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  
  // 🔹 إضافة حقول الإحصائيات الجديدة
  final double totalHours;
  final int activeDays;
  final String lastWorkshop;

  const ProfileLoaded({
    required this.profile,
    this.totalHours = 0.0,
    this.activeDays = 0,
    this.lastWorkshop = "غير محدد",
  });

  @override
  List<Object?> get props => [profile, totalHours, activeDays, lastWorkshop];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
  @override
  List<Object?> get props => [message];
}
