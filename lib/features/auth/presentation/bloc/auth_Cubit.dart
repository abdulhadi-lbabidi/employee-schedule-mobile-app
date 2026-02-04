import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/login_repo.dart';
import 'auth_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthRepository repository}) : super(AuthInitial());

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(
      PasswordVisibilityState(
        isPasswordVisible: _isPasswordVisible,
        isConfirmPasswordVisible: _isConfirmPasswordVisible,
      ),
    );
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    emit(
      PasswordVisibilityState(
        isPasswordVisible: _isPasswordVisible,
        isConfirmPasswordVisible: _isConfirmPasswordVisible,
      ),
    );
  }

  void resetState() {
    emit(AuthInitial());
  }

  Future<void> login(String username, String password) async {
    // التحقق من الحقول
    if (username.isEmpty) {
      emit(AuthError('الرجاء إدخال اسم المستخدم'));
      return;
    }

    if (password.isEmpty) {
      emit(AuthError('الرجاء إدخال كلمة المرور'));
      return;
    }

    if (password.length < 8) {
      emit(AuthError('يجب أن تكون كلمة المرور 8 أحرف على الأقل'));
      return;
    }

    emit(AuthLoading());

    try {
      // محاكاة عملية تسجيل الدخول
      await Future.delayed(const Duration(seconds: 2));

      // هنا يمكنك إرسال البيانات للباك إند
      print('Login - Username: $username');
      print('Login - Password: $password');

      emit(AuthSuccess('تم تسجيل الدخول بنجاح'));
    } catch (e) {
      emit(AuthError('حدث خطأ أثناء تسجيل الدخول'));
    }
  }

  Future<void> signUp(
    String username,
    String password,
    String confirmPassword,
  ) async {
    // التحقق من الحقول
    if (username.isEmpty) {
      emit(AuthError('الرجاء إدخال اسم المستخدم'));
      return;
    }

    if (password.isEmpty) {
      emit(AuthError('الرجاء إدخال كلمة المرور'));
      return;
    }

    if (password.length < 8) {
      emit(AuthError('يجب أن تكون كلمة المرور 8 أحرف على الأقل'));
      return;
    }

    if (confirmPassword.isEmpty) {
      emit(AuthError('الرجاء تأكيد كلمة المرور'));
      return;
    }

    if (password != confirmPassword) {
      emit(AuthError('كلمة المرور غير متطابقة'));
      return;
    }

    emit(AuthLoading());

    try {
      // محاكاة عملية إنشاء الحساب
      await Future.delayed(const Duration(seconds: 2));

      // هنا يمكنك إرسال البيانات للباك إند
      print('SignUp - Username: $username');
      print('SignUp - Password: $password');

      emit(AuthSuccess('تم إنشاء الحساب بنجاح'));
    } catch (e) {
      emit(AuthError('حدث خطأ أثناء إنشاء الحساب'));
    }
  }
}
