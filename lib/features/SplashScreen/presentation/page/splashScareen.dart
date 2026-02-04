import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled8/common/helper/src/app_varibles.dart';
import 'package:untitled8/features/auth/presentation/bloc/auth_state.dart';

import '../../../../core/di/injection.dart';
import '../../../admin/presentation/pages/AdminHomePage.dart';
import '../../../auth/presentation/bloc/login_Cubit/login_cubit.dart';

import '../../../auth/presentation/bloc/login_Cubit/login_state.dart' show AuthSuccess, LoginStatus, LoginState;
import '../../../auth/presentation/pages/login_page.dart';
import '../../../home/presentation/page/main_page.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import 'onBoarding.dart';

class Splashscareen extends StatefulWidget {
  const Splashscareen({super.key});

  @override
  State<Splashscareen> createState() => _SplashscareenState();
}

class _SplashscareenState extends State<Splashscareen> {
 late final OnboardingBloc onboardingBloc;

  @override
  void initState() {

    onboardingBloc =  sl<OnboardingBloc>();
    Future.delayed(const Duration(seconds: 5)).then((value) {
      onboardingBloc.add(CheckSplashStatus()) ;
    });


    super.initState();

    // _handleNavigation();
  }

  @override
  void dispose() {

    onboardingBloc.close();
    // TODO: implement dispose
    super.dispose();
  }

  // Future<void> _handleNavigation() async {
  //   await Future.delayed(const Duration(seconds: 5));
  //
  //   if (!mounted) return;
  //
  //   final prefs = await SharedPreferences.getInstance();
  //   final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  //
  //   if (isFirstTime) {
  //     _fadeNavigate(const OnboardingPage());
  //     return;
  //   }
  //
  //   final loginCubit = context.read<LoginCubit>();
  //   final state = loginCubit.state;
  //
  //   // ✅ استخدام role مباشرة
  //   if (state.status == LoginStatus.success) {
  //     _navigateToHome(state);
  //   } else {
  //     _fadeNavigate(const LoginPage());
  //   }
  // }

  void _fadeNavigate(Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 1900),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    // جعل حجم اللوجو متجاوباً
    final double logoSize = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      body: BlocListener<OnboardingBloc, OnboardingState>(
        bloc: onboardingBloc,
        listenWhen:
            (previous, current) =>
        previous.splashStatus != current.splashStatus,
        listener: (context, state) {
          if (state.splashStatus == SplashStatus.isAuth) {
            AppVariables.role=='employee'?
            _fadeNavigate(MainPage())
                : _fadeNavigate(AdminHomePage())
            ;

          }
          else if (state.splashStatus == SplashStatus.unauthorized) {
            if(AppVariables.isFirstTime){
              _fadeNavigate(OnboardingPage());

            }else{
              _fadeNavigate(LoginPage());

            }


          }
        },
  child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 42, 38, 38),
              Color.fromARGB(255, 79, 77, 77),
            ],
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/image/gif/logogif.gif',
            width: logoSize > 400 ? 400 : logoSize, // حد أقصى للحجم
            height: logoSize > 400 ? 400 : logoSize,
            fit: BoxFit.contain,
          ).animate().fade(duration: 1500.ms).scale(delay: 500.ms),
        ),
      ),
),
    );
  }
}
