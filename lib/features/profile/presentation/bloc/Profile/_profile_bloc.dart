import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Attendance/presentation/bloc/Cubit_Attendance/attendance_cubit.dart';
import '../../../../auth/data/repository/login_repo.dart';
import '../../../data/models/profile_model.dart';
import '_profile_event.dart';
import '_profile_state.dart';

import 'package:injectable/injectable.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;
  String? _cachedImagePath; // 🔹 لحفظ مسار الصورة محلياً

  ProfileBloc(
    this.authRepository,
  ) : super(ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileImage>(_onUpdateProfileImage); // 🔹 معالجة حدث تحديث الصورة
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

  // 🔹 معالجة حدث تحديث الصورة
  Future<void> _onUpdateProfileImage(
    UpdateProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    _cachedImagePath = event.imagePath;
    add(
      LoadProfile(),
    ); // إعادة تحميل الملف الشخصي لتحديث الواجهة بالصورة الجديدة
  }
}
