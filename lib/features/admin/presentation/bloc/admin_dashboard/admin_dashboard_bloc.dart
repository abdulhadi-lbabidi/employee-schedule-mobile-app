import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/core/unified_api/failures.dart';
import 'package:untitled8/features/admin/domain/entities/employee_entity.dart';
import '../../../domain/usecases/get_online_employees.dart';
import '../../../domain/usecases/get_all_employees.dart';
import 'admin_dashboard_event.dart';
import 'admin_dashboard_state.dart';

@injectable
class AdminDashboardBloc extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final GetOnlineEmployeesUseCase getOnlineEmployeesUseCase;
  final GetAllEmployeesUseCase getAllEmployeesUseCase;

  AdminDashboardBloc(this.getOnlineEmployeesUseCase, this.getAllEmployeesUseCase) : super(DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(LoadDashboardEvent event, Emitter<AdminDashboardState> emit) async {
    emit(DashboardLoading());
    try {
      // 1. جلب كافة البيانات بالتوازي
      final results = await Future.wait([
        getAllEmployeesUseCase(),
        getOnlineEmployeesUseCase(),
      ]);

      // 2. التحقق من نتائج الـ Use Cases
      final allEmployeesResult = results[0] as Either<Failure, List<EmployeeEntity>>;
      final onlineEmployeesResult = results[1] as Either<Failure, List<EmployeeEntity>>;

      // 3. التعامل مع النتائج باستخدام .fold
      allEmployeesResult.fold(
        (failure) {
          // في حال فشل جلب كل الموظفين، نصدر حالة خطأ
          emit(DashboardError('فشل في تحميل بيانات الموظفين: ${failure.message}'));
        },
        (allEmployees) {
          onlineEmployeesResult.fold(
            (failure) {
              // في حال فشل جلب الموظفين المتصلين، نصدر حالة خطأ
              emit(DashboardError('فشل في تحميل الموظفين النشطين: ${failure.message}'));
            },
            (onlineEmployees) {
              // 4. في حال نجاح كل العمليات، يتم حساب الإحصائيات
              final offlineEmployees = allEmployees.where((e) => !onlineEmployees.any((online) => online.id == e.id)).toList();

              double totalCost = 0;
              Map<String, double> workshopStats = {};
              Map<String, int> attendanceTrends = {
                'السبت': 0, 'الأحد': 0, 'الاثنين': 0, 'الثلاثاء': 0, 'الأربعاء': 0, 'الخميس': 0, 'الجمعة': 0
              };

              // for (var emp in allEmployees) {
              //   // حساب المصاريف والورشات
              //   for (var week in emp.weeklyHistory) {
              //     if (!week.isPaid) {
              //       for (var ws in week.workshops) {
              //         double val = ws.calculateValue(emp.hourlyRate, emp.overtimeRate);
              //         totalCost += val;
              //         workshopStats[ws.workshopName] = (workshopStats[ws.workshopName] ?? 0) + val;
              //       }
              //     }
              //   }
              // }

              // 5. إصدار حالة النجاح مع البيانات المحسوبة
              emit(DashboardLoaded(
                onlineEmployees: onlineEmployees,
                offlineEmployees: offlineEmployees,
                totalOperationalCost: totalCost,
                workshopExpenses: workshopStats,
                weeklyAttendance: attendanceTrends,
              ));
            },
          );
        },
      );
    } catch (e) {
      // هذا الجزء سيلتقط أي أخطاء غير متوقعة
      emit(DashboardError('فشل في تحديث لوحة الإحصائيات'));
    }
  }
}
