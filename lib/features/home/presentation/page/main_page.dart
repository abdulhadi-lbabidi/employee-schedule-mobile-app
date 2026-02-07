import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/common/helper/src/app_varibles.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/App theme/bloc/theme_bloc.dart';
import '../../../Attendance/presentation/page/attrndance_page.dart';
import '../../../Notification/presentation/pages/notifications_page.dart';
import '../../../admin/presentation/bloc/workshops/workshops_bloc.dart';
import '../../../loan/presentation/pages/employee_loan_page.dart';
import '../../../profile/presentation/bloc/Profile/_profile_bloc.dart';
import '../../../profile/presentation/bloc/Profile/_profile_event.dart';
import '../../../profile/presentation/bloc/Profile/_profile_state.dart';
import '../../../profile/presentation/pages/profie_page.dart';

import '../bloc/Cubit_Navigation/navigation_cubit.dart';
import 'home_page.dart';
import 'EmployeeFinancePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _HomePageState();
}

class _HomePageState extends State<MainPage> {
  final List<Widget> pages = [
    const HomePage(),
    const AttendanceHistoryPage(),
    const NotificationsPage(),
    const EmployeeFinancePage(),
    const EmployeeLoanPage(),
  ];

  @override
  void initState() {

    super.initState();
    // context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    // التصحيح: استدعاء fetchWorkshops بدلاً من getWorkshops
    context.read<WorkshopsBloc>().getWorkshopsUseCase();
    // onPressed: () => context.read<WorkshopsBloc>().add(LoadWorkshopsEvent()),
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            theme.brightness == Brightness.dark
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            color: theme.primaryColor,
          ),
          onPressed: () {
            context.read<ThemeBloc>().add(ToggleThemeEvent());
          },
        ),
        title: Text(
          'Nouh Agency',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
        ),
        actions: [
          GestureDetector(
            onTap:
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => ProfilePage(),
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(left: 10.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blueAccent.withOpacity(0.5),
                  width: 1.5.r,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.21),
                    blurRadius: 7.r,
                    spreadRadius: 1.r,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 14.r,
                backgroundColor: Colors.white.withOpacity(0.05),
                // backgroundImage: NetworkImage(imageUrl),
                child:
                AppVariables.user!.profileImageUrl == null
                    ? Icon(
                  Icons.person_rounded,
                  color: Colors.blueAccent,
                  size: 22.sp,
                )
                    : Image.network( AppVariables.user!.profileImageUrl),
              ),
            ),
          ).animate().fadeIn(duration: 500.ms).scale(delay: 100.ms),
          SizedBox(width: 15.w),
        ],
      ),
      body: BlocBuilder<NavigationnCubit, int>(
        builder: (context, currentPageIndex) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: pages[currentPageIndex],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<NavigationnCubit, int>(
        builder: (context, currentPageIndex) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10.r,
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: currentPageIndex,
              onTap:
                  (index) => context.read<NavigationnCubit>().navigateTo(index),
              backgroundColor: theme.cardColor,
              selectedItemColor: theme.primaryColor,
              unselectedItemColor: theme.disabledColor,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 12.sp,
              unselectedFontSize: 10.sp,
              iconSize: 22.sp,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_rounded),
                  label: 'السجل',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_active_rounded),
                  label: 'التنبيهات',
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet_rounded),
                  label: 'المالية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.money_rounded),
                  label: 'السلف',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
