import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/employee_entity.dart';
import '../../../domain/usecases/add_employee.dart';
import '../../../domain/usecases/get_all_employees.dart';
import '../../../domain/usecases/toggle_employee_archive.dart';
import 'employees_event.dart';
import 'employees_state.dart';

@injectable
class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final GetAllEmployeesUseCase getAllEmployeesUseCase;
  final AddEmployeeUseCase addEmployeeUseCase;
  final ToggleEmployeeArchiveUseCase toggleEmployeeArchiveUseCase;

  List<EmployeeEntity> _allEmployees = [];

  EmployeesBloc({
    required this.getAllEmployeesUseCase,
    required this.addEmployeeUseCase,
    required this.toggleEmployeeArchiveUseCase,
  }) : super(EmployeesInitial()) {
    on<LoadEmployeesEvent>(_onLoadEmployees);
    on<RefreshEmployeesEvent>(_onLoadEmployees);
    on<SearchEmployeesEvent>(_onSearchEmployees);
    on<AddEmployeeEvent>(_onAddEmployee);
    on<ToggleArchiveEmployeeEvent>(_onToggleArchiveEmployee);
  }

  Future<void> _onLoadEmployees(
    EmployeesEvent event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(EmployeesLoading());
    try {
      final employees = await getAllEmployeesUseCase();
      _allEmployees = employees;
      if (employees.isEmpty) {
        emit(EmployeesEmpty());
      } else {
        emit(EmployeesLoaded(employees));
      }
    } catch (e) {
      emit(EmployeesError('حدث خطأ أثناء تحميل الموظفين: ${e.toString()}'));
    }
  }

  Future<void> _onAddEmployee(
    AddEmployeeEvent event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(EmployeesLoading());
    try {
      await addEmployeeUseCase(event.employee);
      add(LoadEmployeesEvent());
    } catch (e) {
      emit(EmployeesError('فشل إضافة الموظف الجديد: ${e.toString()}'));
    }
  }

  Future<void> _onToggleArchiveEmployee(
    ToggleArchiveEmployeeEvent event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(EmployeesLoading());
    try {
      await toggleEmployeeArchiveUseCase(event.id, event.isArchived);
      add(LoadEmployeesEvent());
    } catch (e) {
      emit(EmployeesError('فشل تغيير حالة أرشفة الموظف: ${e.toString()}'));
    }
  }

  void _onSearchEmployees(
    SearchEmployeesEvent event,
    Emitter<EmployeesState> emit,
  ) {
    if (event.query.isEmpty) {
      if (_allEmployees.isEmpty) {
        emit(EmployeesEmpty());
      } else {
        emit(EmployeesLoaded(_allEmployees));
      }
      return;
    }

    final filteredEmployees = _allEmployees
        .where((employee) =>
            (employee.name).toLowerCase().contains(event.query.toLowerCase()) ||
            (employee.phoneNumber).contains(event.query))
        .toList();

    if (filteredEmployees.isEmpty) {
      emit(EmployeesEmpty());
    } else {
      emit(EmployeesLoaded(filteredEmployees));
    }
  }
}
