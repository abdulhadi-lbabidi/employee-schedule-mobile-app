import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled8/core/unified_api/base_api.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // 🔹 إضافة
import '../../../../../common/helper/src/app_varibles.dart';
import '../../../../../common/helper/src/helper_func.dart';
import '../../../../../core/di/injection.dart';
import '../../../data/repository/login_repo.dart';
import 'login_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository repository;

  LoginCubit({required this.repository}) : super(const LoginState.initial());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> login({
    required String email,
    required String password,
  })
  async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await repository.login(email: email, password: password);
    result.fold(
      (failure) {

        emit(state.copyWith(
        status: LoginStatus.failure,
        message: failure.message,
      ));
      },
      (response) async {
        print('success');

        if (response.token != null && response.user != null) {
          emit(state.copyWith(
            status: LoginStatus.success,
            user: response.user,
            message: 'تم تسجيل الدخول بنجاح',
          ));
          print(response.token);
          print(response.user);
          print(response.role);
          AppVariables.token = response.token;
          AppVariables.user = response.user!;
          AppVariables.role = response.role;
          sl<BaseApi>().resetHeader();

          // 🔹 الحصول على رمز FCM وإرساله إلى الخادم
          final fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null) {
            await repository.updateFCMToken(fcmToken);
            print("FCM Token updated: $fcmToken");
          } else {
            print("FCM Token is null, cannot update.");
          }

        } else {
          // هذا الجزء يتعامل مع حالة الفشل حيث يعود response ولكنه null token/user
          emit(state.copyWith(
            status: LoginStatus.failure,
            message: response.status == 401 ? 'بيانات الاعتماد غير صحيحة' : 'فشل تسجيل الدخول',
          ));
        }
      },
    );
  }

  Future<void> logout() async {
    // 🔹 حذف رمز FCM من الخادم عند تسجيل الخروج
    await repository.deleteFCMToken();
    print("FCM Token deleted from backend.");

    await repository.logout();
    emit(const LoginState.initial());
    HelperFunc.logout();
  }
}
