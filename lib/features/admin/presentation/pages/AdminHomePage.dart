import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/injection.dart';
import '../../../loan/presentation/bloc/loan_bloc.dart';
import '../../../loan/presentation/pages/admin_loan_page.dart';
import '../bloc/employees/employees_bloc.dart';
import '../bloc/employees/employees_event.dart';
import '../bloc/workshops/workshops_bloc.dart';
import '../bloc/workshops/workshops_event.dart';


import 'AdminDashboardPage.dart';
import 'EmployeesPage.dart';
import 'AdminFinancePage.dart';
import 'WorkshopsPage.dart';
import 'AdminNotificationsPage.dart'; 

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AdminDashboardPage(),
    const EmployeesPage(),
    const AdminFinancePage(),
    const AdminLoanPage(),
    const WorkshopsPage(),
    const AdminNotificationsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<EmployeesBloc>()..add(LoadEmployeesEvent())),
        BlocProvider(create: (_) => sl<WorkshopsBloc>()..add(LoadWorkshopsEvent())),
        BlocProvider(create: (_) => sl<LoanBloc>()),
      ],
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12.sp,
          unselectedFontSize: 10.sp,
          iconSize: 22.sp,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'الموظفون',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: 'المالية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.money_outlined),
              activeIcon: Icon(Icons.money),
              label: 'السلف',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.warehouse_outlined),
              activeIcon: Icon(Icons.warehouse),
              label: 'الورشات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              activeIcon: Icon(Icons.notifications),
              label: 'التنبيهات',
            ),
          ],
        ),
      ),
    );
  }
}
