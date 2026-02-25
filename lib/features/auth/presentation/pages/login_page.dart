import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:untitled8/core/utils/app_strings.dart';
import 'package:untitled8/features/admin/presentation/pages/AdminHomePage.dart';
import 'package:untitled8/features/home/presentation/page/main_page.dart';

import '../bloc/login_Cubit/login_cubit.dart';
import '../bloc/login_Cubit/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(

       backgroundColor: Colors.white12,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [const Color(0xFF121212), const Color(0xFF1E1E1E)]
                  : [const Color(0xFF121212), const Color(0xE0646363)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state.status == LoginStatus.success &&
                        state.user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message ?? 'تم بنجاح'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      final role = state.user!.userableType?.toLowerCase();

                      if (role == 'admin') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminHomePage(),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MainPage()),
                        );
                      }
                    }

                    if (state.status == LoginStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message ?? 'حدث خطأ'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state.status == LoginStatus.loading;
                    final loginCubit = context.read<LoginCubit>();

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 25.r,
                                    spreadRadius: 5.r,
                                    offset: Offset(0, 10.h),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 70.r,
                                backgroundColor: Colors.black,
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/image/log/logo.png',
                                    width: 120.r,
                                    height: 120.r,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 800.ms)
                            .scale(delay: 200.ms),

                        SizedBox(height: 30.h),
                        Text(
                          AppStrings.loginTitle,
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ).animate().slideY(begin: 0.3, end: 0),

                        SizedBox(height: 40.h),
                        Card(
                              elevation: 12,
                              color: theme.cardColor,
                              shadowColor: Colors.black45,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.r),
                                side: BorderSide(
                                  color: theme.dividerColor.withOpacity(0.1),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(24.w),
                                child: Column(
                                  children: [
                                    _buildInputField(
                                      controller: _usernameController,
                                      label: AppStrings.usernameLabel,
                                      icon: Icons.person_outline,
                                      theme: theme,
                                      enabled: !isLoading,
                                    ),
                                    SizedBox(height: 20.h),
                                    _buildInputField(
                                      controller: _passwordController,
                                      label: AppStrings.passwordLabel,
                                      icon: Icons.lock_outline,
                                      theme: theme,
                                      enabled: !isLoading,
                                      isPassword: true,
                                      isPasswordVisible:
                                          state.isPasswordVisible,
                                      onToggleVisibility:
                                          loginCubit.togglePasswordVisibility,
                                    ),
                                    SizedBox(height: 30.h),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50.h,
                                      child: ElevatedButton(
                                        onPressed: isLoading
                                            ? null
                                            : () {
                                                final email =
                                                    _usernameController.text
                                                        .trim();
                                                final password =
                                                    _passwordController.text;

                                                if (email.isEmpty ||
                                                    password.isEmpty) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        AppStrings
                                                            .fillAllFields,
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                  return;
                                                }
                                              print('sendddddd');
                                                loginCubit.login(
                                                  email: email,
                                                  password: password,
                                                );
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: theme.primaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15.r,
                                            ),
                                          ),
                                          elevation: 5,
                                        ),
                                        child: isLoading
                                            ? CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.w,
                                              )
                                            : Text(
                                                AppStrings.loginTitle,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 400.ms)
                            .slideY(begin: 0.2, end: 0),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ThemeData theme,
    required bool enabled,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: isPassword && !isPasswordVisible,
      style: TextStyle(
        fontSize: 14.sp,
        color: theme.textTheme.bodyLarge?.color,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 12.sp, color: theme.disabledColor),
        prefixIcon: Icon(icon, size: 22.sp, color: theme.primaryColor),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  size: 20.sp,
                  color: theme.disabledColor,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        filled: true,
        fillColor: theme.scaffoldBackgroundColor.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
        ),
      ),
    );
  }
}
