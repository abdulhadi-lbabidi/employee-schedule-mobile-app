import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled8/features/employee/domain/entities/employee_summary_entity.dart';
// Added UseCase import
import '../../../domain/usecases/get_employee_summary_usecase.dart';
import 'employee_summary_event.dart';
import 'employee_summary_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class EmployeeSummaryBloc extends Bloc<EmployeeSummaryEvent, EmployeeSummaryState> {
  final GetEmployeeSummaryUseCase getEmployeeSummaryUseCase;

  EmployeeSummaryBloc({required this.getEmployeeSummaryUseCase}) : super(EmployeeSummaryInitial()) {
    on<LoadEmployeeSummaryEvent>(_onLoadEmployeeSummary);
  }

  Future<void> _onLoadEmployeeSummary(
    LoadEmployeeSummaryEvent event,
    Emitter<EmployeeSummaryState> emit,
  ) async {
    emit(EmployeeSummaryLoading());
    final result = await getEmployeeSummaryUseCase(event.employeeId);

    result.fold(
      (failure) => emit(EmployeeSummaryError(failure.message)),
      (summary) => emit(EmployeeSummaryLoaded(summary)),
    );
  }
}
