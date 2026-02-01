import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/admin_profile_entity.dart';

// الأحداث (Events)
abstract class AdminProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}
class LoadAdminProfileEvent extends AdminProfileEvent {}

// الحالات (States)
abstract class AdminProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}
class AdminProfileInitial extends AdminProfileState {}
class AdminProfileLoading extends AdminProfileState {}
class AdminProfileLoaded extends AdminProfileState {
  final AdminProfileEntity profile;
  AdminProfileLoaded(this.profile);
  @override
  List<Object?> get props => [profile];
}
class AdminProfileError extends AdminProfileState {
  final String message;
  AdminProfileError(this.message);
}

// الـ Bloc
class AdminProfileBloc extends Bloc<AdminProfileEvent, AdminProfileState> {
  AdminProfileBloc() : super(AdminProfileInitial()) {
    on<LoadAdminProfileEvent>((event, emit) async {
      emit(AdminProfileLoading());
      try {
        // بيانات وهمية احترافية للمدير (Mock Data)
        await Future.delayed(const Duration(milliseconds: 800));
        const profile = AdminProfileEntity(
          id: "ADMIN-001",
          fullName: "عبد الفتاح حموي",
          email: "admin@nouh-agency.com",
          phoneNumber: "0933112233",
          position: "المدير العام (CEO)",
          department: "مجلس الإدارة",
        );
        emit(AdminProfileLoaded(profile));
      } catch (e) {
        emit(AdminProfileError("فشل تحميل بيانات المدير"));
      }
    });
  }
}
