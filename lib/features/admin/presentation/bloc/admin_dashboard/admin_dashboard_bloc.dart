import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
import '../../../domain/usecases/get_online_employees.dart';
import '../../../domain/usecases/get_all_employees.dart';
import 'admin_dashboard_event.dart';
import 'admin_dashboard_state.dart';

@injectable
class AdminDashboardBloc extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final GetOnlineEmployeesUseCase getOnlineEmployeesUseCase;
  final GetAllEmployeesUseCase getAllEmployeesUseCase; // 🔹 إضافة جلب الكل للحسابات

  AdminDashboardBloc(this.getOnlineEmployeesUseCase, this.getAllEmployeesUseCase) : super(DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
      LoadDashboardEvent event,
      Emitter<AdminDashboardState> emit,
      ) async {
    emit(DashboardLoading());


      final allEmployeesEither =await getAllEmployeesUseCase();
      final onlineEmployeesEither =await getOnlineEmployeesUseCase();

      late final List<EmployeeModel> allEmployees;
      late final List<EmployeeModel> onlineEmployees;

      // 1. الدخول إلى Right
      allEmployeesEither.fold(
            (failure) => emit(DashboardError(failure.message)),
            (response) => allEmployees = response.data!,
      );

      onlineEmployeesEither.fold(
            (failure) => emit(DashboardError(failure.message)),
            (response) => onlineEmployees = response.data!,
      );

      // 2. حساب الموظفين غير المتصلين
      final offlineEmployees = allEmployees
          .where((e) => !onlineEmployees.any((o) => o.id == e.id))
          .toList();

      // 3. محرك الحسابات الإحصائية
      double totalCost = 0;
      final Map<String, double> workshopStats = {};
      final Map<String, int> attendanceTrends = {
        'السبت': 0,
        'الأحد': 0,
        'الاثنين': 0,
        'الثلاثاء': 0,
        'الأربعاء': 0,
        'الخميس': 0,
        'الجمعة': 0,
      };
      //
      // for (final emp in allEmployees) {
      //   for (final week in emp.) {
      //     if (!week.isPaid) {
      //       for (final ws in week.workshops) {
      //         final value =
      //         ws.calculateValue(emp.hourlyRate, emp.overtimeRate);
      //
      //         totalCost += value;
      //         workshopStats[ws.workshopName] =
      //             (workshopStats[ws.workshopName] ?? 0) + value;
      //       }
      //     }
      //   }
      // }

      emit(DashboardLoaded(
        onlineEmployees: onlineEmployees,
        offlineEmployees: offlineEmployees,
        totalOperationalCost: totalCost,
        workshopExpenses: workshopStats,
        weeklyAttendance: attendanceTrends,
      ));

  }


}
