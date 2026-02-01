import '../../../data/model/login_response.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState {
  final LoginStatus status;
  final User? user;
  final LoginResponse? rols;
  final String? message;
  final bool isPasswordVisible;

  const LoginState({
    required this.status,
    this.user,
    this.message,
    required this.isPasswordVisible,
    this.rols,
  });

  /// الحالة الابتدائية
  const LoginState.initial()
    : status = LoginStatus.initial,
      user = null,
      rols = null,
      message = null,
      isPasswordVisible = false;

  LoginState copyWith({
    LoginStatus? status,
    User? user,
    LoginResponse? rols,
    String? message,
    bool? isPasswordVisible,
  }) {
    return LoginState(
      status: status ?? this.status,
      user: user ?? this.user,
      rols: rols ?? this.rols,
      message: message ?? this.message,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}
