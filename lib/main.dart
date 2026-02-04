import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled8/common/helper/src/app_varibles.dart';
import 'package:untitled8/core/services/notification_service.dart';
import 'package:untitled8/core/theme/App%20theme/bloc/theme_bloc.dart';
import 'core/di/injection.dart';
import 'core/theme/theme.dart';
import 'core/utils/app_strings.dart';
import 'features/Attendance/presentation/bloc/Cubit_Attendance/attendance_cubit.dart';
import 'features/Attendance/presentation/bloc/attendance_bloc.dart';
import 'features/Notification/presentation/bloc/notification_bloc.dart';
import 'features/SplashScreen/presentation/page/splashScareen.dart';
import 'features/auth/presentation/bloc/login_Cubit/login_cubit.dart';
import 'features/home/presentation/bloc/Cubit_Button/button_cubit.dart';
import 'features/home/presentation/bloc/Cubit_Navigation/navigation_cubit.dart';
import 'features/home/presentation/bloc/Cubit_dropdown/dropdown_cubit.dart';
import 'features/home/presentation/bloc/cubit_active_unactive/active_unactive_cubit.dart';
import 'features/home/presentation/bloc/finance/finance_bloc.dart';
import 'features/profile/presentation/bloc/Profile/_profile_bloc.dart';
import 'features/admin/presentation/bloc/admin_dashboard/admin_dashboard_bloc.dart';
import 'features/admin/presentation/bloc/admin_profile/admin_profile_bloc.dart';
import 'features/admin/presentation/bloc/employees/employees_bloc.dart';
import 'features/admin/presentation/bloc/employee_details/employee_details_bloc.dart';
import 'features/admin/presentation/bloc/workshops/workshops_bloc.dart';
import 'features/loan/presentation/bloc/loan_bloc.dart';

// 🔹 إضافة مفتاح الملاحة العالمي للتحكم في التنقل بدون Context

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // Hive.registerAdapter(AttendanceRecordAdapter());
  // sl<SyncService>().init();

  await configureInjection();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase Initialize Error: $e");
  }

  await NotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ThemeBloc()..add(GetCurrentThemeEvent()),
            ),
            BlocProvider(create: (_) => sl<LoginCubit>()),
            BlocProvider(create: (_) => sl<AttendanceBloc>()),

            BlocProvider(create: (_) => sl<NavigationnCubit>()),
            BlocProvider(create: (_) => sl<DropdownCubit>()),
            BlocProvider(create: (_) => sl<ButtonCubit>()),
            BlocProvider(create: (_) => sl<ActiveUnactiveCubit>()),
            BlocProvider(create: (_) => sl<ProfileBloc>()),
            // BlocProvider(create: (_) => sl<AttendanceCubit>()),
            BlocProvider(create: (_) => sl<NotificationBloc>()),
            BlocProvider(create: (_) => sl<AdminDashboardBloc>()),
            BlocProvider(create: (_) => sl<AdminProfileBloc>()),
            BlocProvider(create: (_) => sl<EmployeesBloc>()),
            BlocProvider(create: (_) => sl<EmployeeDetailsBloc>()),
            BlocProvider(create: (_) => sl<WorkshopsBloc>()),
            BlocProvider(create: (_) => sl<FinanceBloc>()),
            BlocProvider(create: (_) => sl<LoanBloc>()),
          ],
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              ThemeData currentTheme = AppTheme.lightTheme;
              if (themeState is LoadedThemeState) {
                currentTheme = themeState.themeData;
              }

              return MaterialApp(
                navigatorKey: AppVariables.navigatorKey,
                debugShowCheckedModeBanner: false,
                title: AppStrings.appTitle,
                theme: currentTheme,
                locale: const Locale('ar', 'AE'),
                supportedLocales: const [Locale('ar', 'AE')],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],


                navigatorObservers: [BotToastNavigatorObserver()],
                builder: BotToastInit(),
                home: const Splashscareen(),
              );
            },
          ),
        );
      },
    );
  }
}
