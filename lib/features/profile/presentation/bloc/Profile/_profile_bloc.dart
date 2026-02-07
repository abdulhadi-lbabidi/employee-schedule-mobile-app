import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled8/common/helper/src/app_varibles.dart';
import 'package:untitled8/common/helper/src/helper_func.dart';
import '../../../../auth/data/repository/login_repo.dart';
import '_profile_event.dart';
import '_profile_state.dart';

import 'package:injectable/injectable.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;

  ProfileBloc(this.authRepository) : super(ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileImage>(_onUpdateProfileImage); // 🔹 معالجة حدث تحديث الصورة
    on<LogOutEvent>(_logOut); // 🔹 معالجة حدث تحديث الصورة
  }

  Future<void> _logOut(LogOutEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(logOutData: state.logOutData.setLoading()));

    final val = await authRepository.logout();

    val.fold(
      (l) {
        emit(
          state.copyWith(
            logOutData: state.logOutData.setFaild(errorMessage: l.message),
          ),
        );
      },
      (r) async {
        emit(state.copyWith(logOutData: state.logOutData.setSuccess()));

        HelperFunc.logout();
      },
    );
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(profile: state.profile.setLoading()));

    final val = await authRepository.getCurrentUser();

    val.fold(
      (l) {
        emit(
          state.copyWith(
            profile: state.profile.setFaild(errorMessage: l.message),
          ),
        );
      },
      (r) async {
        emit(state.copyWith(profile: state.profile.setSuccess(data: r)));
      },
    );
  }

  Future<void> _onUpdateProfileImage(
    UpdateProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(updateProfile: state.updateProfile.setLoading()));

    final val = await authRepository.updateProfile(event.imagePath);

    val.fold(
      (l) {
        emit(
          state.copyWith(
            updateProfile: state.updateProfile.setFaild(
              errorMessage: l.message,
            ),
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            updateProfile: state.updateProfile.setSuccess(data: r),
            profile: state.profile.copyWith(
              data: state.profile.data!.copyWith(
                user: state.profile.data!.user!.copyWith(
                  profileImageUrl:
                      r.user!.profileImageUrl,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
