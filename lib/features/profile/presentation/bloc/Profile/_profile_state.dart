import 'package:untitled8/core/data_state_model.dart';
import '../../../../auth/data/model/login_response.dart';

class ProfileState {
  final DataStateModel<LoginResponse?> profile;
  final DataStateModel<LoginResponse?> updateProfile;
  final DataStateModel<void> logOutData;

  ProfileState({
    this.profile = const DataStateModel.setDefultValue(defultValue: null),
    this.updateProfile = const DataStateModel.setDefultValue(defultValue: null),
    this.logOutData = const DataStateModel.setDefultValue(defultValue: null),
  });

  ProfileState copyWith({ DataStateModel<LoginResponse?>? profile,
    DataStateModel<LoginResponse?>? updateProfile,
    DataStateModel<void>? logOutData,

  }

      ) {
    return ProfileState(
        profile: profile ?? this.profile,
      updateProfile: updateProfile ?? this.updateProfile,
      logOutData: logOutData ?? this.logOutData,

    );
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
