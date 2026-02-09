import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled8/common/helper/src/app_varibles.dart';
import 'package:untitled8/common/helper/src/helper_func.dart';
import 'package:untitled8/features/profile/domain/usecases/update_password_usecase.dart';
import 'package:untitled8/features/profile/domain/usecases/update_profile_info_usecase.dart'; // 🔹 إضافة
import '../../../../auth/data/repository/login_repo.dart';
import '_profile_event.dart';
import '_profile_state.dart';

import 'package:injectable/injectable.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;
  final UpdatePasswordUseCase updatePasswordUseCase;
  final UpdateProfileInfoUseCase updateProfileInfoUseCase; // 🔹 إضافة

  ProfileBloc(
    this.authRepository,
    this.updatePasswordUseCase,
    this.updateProfileInfoUseCase, // 🔹 إضافة
  ) : super(ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileImage>(_onUpdateProfileImage);
    on<LogOutEvent>(_logOut);
    on<UpdatePasswordEvent>(_onUpdatePassword);
    on<UpdateProfileInfo>(_onUpdateProfileInfo); // 🔹 إضافة
  }

  Future<void> _onUpdateProfileInfo(UpdateProfileInfo event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(updateProfile: state.updateProfile.setLoading()));
    
    final params = {
      'full_name': event.name,
      'phone_number': event.phone,
    };

    final val = await updateProfileInfoUseCase(params);

    val.fold(
      (l) => emit(state.copyWith(updateProfile: state.updateProfile.setFaild(errorMessage: l.message))),
      (r) {
        AppVariables.user = r; // تحديث المستخدم في الكاش
        emit(state.copyWith(updateProfile: state.updateProfile.setSuccess(data: null))); // تم النجاح
      },
    );
  }

  // ... (باقي الدوال كما هي)
   Future<void> _logOut(LogOutEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(logOutData: state.logOutData.setLoading()));
    final val = await authRepository.logout();
    val.fold(
      (l) => emit(state.copyWith(logOutData: state.logOutData.setFaild(errorMessage: l.message))),
      (r) {
        emit(state.copyWith(logOutData: state.logOutData.setSuccess()));
        HelperFunc.logout();
      },
    );
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(profile: state.profile.setLoading()));
    final val = await authRepository.getCurrentUser();
    val.fold(
      (l) => emit(state.copyWith(profile: state.profile.setFaild(errorMessage: l.message))),
      (r) => emit(state.copyWith(profile: state.profile.setSuccess(data: r))),
    );
  }

  Future<void> _onUpdatePassword(UpdatePasswordEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(updateProfile: state.updateProfile.setLoading()));
    
    final params = {
      'old_password': event.oldPassword,
      'password': event.newPassword,
      'password_confirmation': event.confirmPassword,
    };

    final val = await updatePasswordUseCase(params);

    val.fold(
      (l) => emit(state.copyWith(updateProfile: state.updateProfile.setFaild(errorMessage: l.message))),
      (r) {
        // تحديث معلومات المستخدم في الـ AppVariables إذا لزم الأمر
        AppVariables.user = r;
        emit(state.copyWith(updateProfile: state.updateProfile.setSuccess(data: null))); // تم النجاح
      },
    );
  }

  Future<void> _onUpdateProfileImage(UpdateProfileImage event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(updateProfile: state.updateProfile.setLoading()));
    final val = await authRepository.updateProfile(event.imagePath);
    val.fold(
      (l) => emit(state.copyWith(updateProfile: state.updateProfile.setFaild(errorMessage: l.message))),
      (r) {
        emit(state.copyWith(
          updateProfile: state.updateProfile.setSuccess(data: r),
          profile: state.profile.copyWith(
            data: state.profile.data!.copyWith(
              user: state.profile.data!.user!.copyWith(
                profileImageUrl: r.user!.profileImageUrl,
              ),
            ),
          ),
        ));
      },
    );
  }
}
