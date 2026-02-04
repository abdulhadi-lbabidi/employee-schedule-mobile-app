import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled8/core/unified_api/base_api.dart';
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
    print('before send');
print(email);
print(password);
    final result = await repository.login(email: email, password: password);
    print('after send');
    result.fold(
      (failure) {
        print('failure');

        emit(state.copyWith(
        status: LoginStatus.failure,
        message: failure.message,
      ));
      },
      (response) {
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

  // Future<void> register({
  //   required String username,
  //   required String password,
  //   required String email,
  //   required String fullName,
  //   String role = 'employee',
  // }) async
  // {
  //   emit(state.copyWith(status: LoginStatus.loading));
  //
  //   final result = await repository.register(
  //     username: username,
  //     password: password,
  //     email: email,
  //     fullName: fullName,
  //     role: role,
  //   );
  //
  //   result.fold(
  //     (failure) => emit(state.copyWith(
  //       status: LoginStatus.failure,
  //       message: failure.message,
  //     )),
  //     (response) {
  //       if (response.token != null && response.user != null) {
  //         emit(state.copyWith(
  //           status: LoginStatus.success,
  //           user: response.user,
  //           message: 'تم إنشاء الحساب بنجاح',
  //         ));
  //       } else {
  //         emit(state.copyWith(
  //           status: LoginStatus.failure,
  //           message: 'فشل إنشاء الحساب',
  //         ));
  //       }
  //     },
  //   );
  // }

  // Future<void> checkAuthStatus() async {
  //   final token = await repository.getToken();
  //   if (token == null) {
  //     emit(const LoginState.initial());
  //     return;
  //   }
  //
  //   emit(state.copyWith(status: LoginStatus.loading));
  //   final isLoggedIn = await repository.isLoggedIn();
  //
  //   if (isLoggedIn) {
  //     final user = await repository.getCurrentUser();
  //     if (user != null) {
  //       emit(state.copyWith(
  //         status: LoginStatus.success,
  //         user: user,
  //         message: 'مرحباً بك مجدداً',
  //       ));
  //     } else {
  //       emit(const LoginState.initial());
  //     }
  //   } else {
  //     await repository.logout();
  //     emit(const LoginState.initial());
  //   }
  // }

  Future<void> logout() async {
    await repository.logout();
    emit(const LoginState.initial());
    HelperFunc.logout();
  }
}
