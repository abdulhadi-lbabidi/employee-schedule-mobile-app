import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:untitled8/features/admin/presentation/pages/AdminDashboardPage.dart';
import 'package:untitled8/features/admin/presentation/bloc/admin_dashboard/admin_dashboard_bloc.dart';
import 'package:untitled8/features/admin/presentation/bloc/admin_dashboard/admin_dashboard_state.dart';
import 'package:untitled8/features/admin/presentation/bloc/admin_dashboard/admin_dashboard_event.dart';
import 'package:untitled8/features/admin/domain/usecases/get_online_employees.dart';
import 'package:untitled8/features/admin/domain/usecases/get_all_employees.dart';
import 'package:untitled8/features/admin/domain/repositories/admin_repository.dart';
import 'package:untitled8/features/admin/domain/entities/employee_entity.dart';
import 'package:untitled8/features/admin/domain/entities/workshop_entity.dart';
import 'package:get_it/get_it.dart';

// محاكاة المستودع
class FakeAdminRepo implements AdminRepository {
  @override Future<List<EmployeeEntity>> getAllEmployees() async => [];
  @override Future<List<EmployeeEntity>> getOnlineEmployees() async => [];
  @override Future<EmployeeEntity> getEmployeeDetails(String id) => throw UnimplementedError();
  @override Future<void> addEmployee(EmployeeEntity employee) async {}
  @override Future<void> deleteEmployee(String id) async {}
  @override Future<void> confirmPayment({required String employeeId, required int weekNumber}) async {}
  @override Future<void> updateHourlyRate({required String employeeId, required double newRate}) async {}
  @override Future<void> updateOvertimeRate({required String employeeId, required double newRate}) async {}
  @override
  Future<void> toggleEmployeeArchive(String id, bool isArchived) async {
    return Future.value(); // Explicitly returning a completed Future<void>
  }
  
  @override Future<List<WorkshopEntity>> getWorkshops() async => [];
  
  @override 
  Future<void> addWorkshop({
    required String name,
    double? latitude,
    double? longitude,
    double radius = 200,
  }) async {}

  @override Future<void> deleteWorkshop(int id) async {}
  @override Future<void> toggleWorkshopArchive(String id, bool isArchived) async {}
}

// محاكاة الـ Bloc باستخدام implements لتجنب مشاكل on<Event>
class MockAdminDashboardBloc extends Bloc<AdminDashboardEvent, AdminDashboardState> implements AdminDashboardBloc {
  @override GetOnlineEmployeesUseCase get getOnlineEmployeesUseCase => throw UnimplementedError();
  @override GetAllEmployeesUseCase get getAllEmployeesUseCase => throw UnimplementedError();

  MockAdminDashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardEvent>((event, emit) {
      // تجاهل الأحداث لخدمة الاختبار يدوياً
    });
  }

  @override Future<void> close() async => super.close();

  void emitLoaded() {
    emit(DashboardLoaded(
      onlineEmployees: [],
      offlineEmployees: [],
      totalOperationalCost: 50000,
      workshopExpenses: {'ورشة أ': 20000, 'ورشة ب': 30000},
      weeklyAttendance: {'السبت': 5, 'الأحد': 10},
    ));
  }
}

void main() {
  final sl = GetIt.instance;

  setUp(() {
    sl.allowReassignment = true; // السماح بإعادة التسجيل للاختبار
    final mockBloc = MockAdminDashboardBloc();
    sl.registerSingleton<AdminDashboardBloc>(mockBloc);
  });

  testWidgets('اختبار وجود الرسوم البيانية والبطاقات في لوحة التحكم', (WidgetTester tester) async {
    final mockBloc = sl<AdminDashboardBloc>() as MockAdminDashboardBloc;

    // 1. بناء الواجهة
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) => const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: AdminDashboardPage(),
          ),
        ),
      ),
    );

    // 2. إصدار الحالة Loaded بعد البناء لضمان استماع الـ UI لها
    mockBloc.emitLoaded();
    
    // 3. ضخ عدة إطارات لمعالجة الحالة والأنيميشن
    await tester.pump(); 
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // 4. الفحص
    expect(find.textContaining("لوحة التحكم"), findsWidgets);
    expect(find.textContaining("إجمالي العمال"), findsWidgets);
    
    // التأكد من وجود الرسوم البيانية
    expect(find.byType(PieChart), findsWidgets);
    expect(find.byType(BarChart), findsWidgets);

    // القيمة المالية (50000 -> 50.0k)
    expect(find.text("50.0k"), findsWidgets);
  });
}
