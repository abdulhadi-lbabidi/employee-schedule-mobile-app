import '../../../data/models/get_dashboard_data.dart';

abstract class AdminDashboardState {}

class DashboardInitial extends AdminDashboardState {}
class DashboardLoading extends AdminDashboardState {}
class DashboardError extends AdminDashboardState {
  final String message;
  DashboardError(this.message);
}
class DashboardLoadedFromApi extends AdminDashboardState {
  final GetDashboardData dashboardData;
  DashboardLoadedFromApi({required this.dashboardData});
}