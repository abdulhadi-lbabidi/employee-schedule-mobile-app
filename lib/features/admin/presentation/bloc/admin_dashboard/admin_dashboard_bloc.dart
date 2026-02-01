import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_online_employees.dart';
import '../../../domain/usecases/get_all_employees.dart';
import 'admin_dashboard_event.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardBloc extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final GetOnlineEmployeesUseCase getOnlineEmployeesUseCase;
  final GetAllEmployeesUseCase getAllEmployeesUseCase; // 🔹 إضافة جلب الكل للحسابات

  AdminDashboardBloc(this.getOnlineEmployeesUseCase, this.getAllEmployeesUseCase) : super(DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(LoadDashboardEvent event, Emitter<AdminDashboardState> emit) async {
    emit(DashboardLoading());
    try {
      // 1. جلب كافة البيانات بالتوازي لتحسين الأداء
      final results = await Future.wait([
        getAllEmployeesUseCase(),
        getOnlineEmployeesUseCase(),
      ]);

      final allEmployees = results[0];
      final onlineEmployees = results[1];
      
      final offlineEmployees = allEmployees.where((e) => !onlineEmployees.contains(e)).toList();

      // 2. محرك الحسابات الإحصائية
      double totalCost = 0;
      Map<String, double> workshopStats = {};
      Map<String, int> attendanceTrends = {
        'السبت': 0, 'الأحد': 0, 'الاثنين': 0, 'الثلاثاء': 0, 'الأربعاء': 0, 'الخميس': 0, 'الجمعة': 0
      };

      for (var emp in allEmployees) {
        // حساب المصاريف والورشات
        for (var week in emp.weeklyHistory) {
          if (!week.isPaid) {
            for (var ws in week.workshops) {
              double val = ws.calculateValue(emp.hourlyRate, emp.overtimeRate);
              totalCost += val;
              workshopStats[ws.workshopName] = (workshopStats[ws.workshopName] ?? 0) + val;
            }
          }
        }
        
        // ✅ تم إزالة الجزء الخاطئ الذي كان يحاول استخدام forEach على double
      }

      emit(DashboardLoaded(
        onlineEmployees: onlineEmployees,
        offlineEmployees: offlineEmployees,
        totalOperationalCost: totalCost,
        workshopExpenses: workshopStats,
        weeklyAttendance: attendanceTrends,
      ));
    } catch (e) {
      emit(DashboardError('فشل في تحديث لوحة الإحصائيات'));
    }
  }
}
