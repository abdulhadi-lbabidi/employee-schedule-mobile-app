import 'package:equatable/equatable.dart';
import 'package:untitled8/core/data_state_model.dart';
import 'package:untitled8/features/auth/data/repository/login_repo.dart';
import '../../../../auth/data/model/login_response.dart';
import '../../../data/models/profile_model.dart';

class ProfileState {
  final DataStateModel<LoginResponse?> profile;

  ProfileState({
    this.profile = const DataStateModel.setDefultValue(defultValue: null),
  });

  ProfileState copyWith({DataStateModel<LoginResponse?>? profile}) {
    return ProfileState(profile: profile ?? this.profile);
  }
}

// final ProfileModel profile;
//
// // 🔹 إضافة حقول الإحصائيات الجديدة
// final double totalHours;
// final int activeDays;
// final String lastWorkshop;
//
// const ProfileLoaded({
// required this.profile,
// this.totalHours = 0.0,
// this.activeDays = 0,
// this.lastWorkshop = "غير محدد",
// });
