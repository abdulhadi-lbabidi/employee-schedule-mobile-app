import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/get_dashboard_data_usecase.dart';
import 'admin_dashboard_event.dart';
import 'admin_dashboard_state.dart';

@injectable
class AdminDashboardBloc extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final GetDashboardDataUsecase dashboardDataUsecase;

  AdminDashboardBloc(this.dashboardDataUsecase) : super(DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
      LoadDashboardEvent event,
      Emitter<AdminDashboardState> emit,
      ) async {
    emit(DashboardLoading());

    final response = await dashboardDataUsecase();
    response.fold(
          (failure) => emit(DashboardError(failure.message)),
          (data) => emit(DashboardLoadedFromApi(dashboardData: data)),
    );
  }
}