import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
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
  
 List<EmployeeModel>  _allEmployees=[];
  EmployeesBloc(
     this.getAllEmployeesUseCase,
     this.addEmployeeUseCase,
     this.toggleEmployeeArchiveUseCase,
  ) : super(EmployeesInitial()) {
    on<LoadEmployeesEvent>(_onLoadEmployees);
    on<RefreshEmployeesEvent>(_onLoadEmployees);
    on<SearchEmployeesEvent>(_onSearchEmployees);
    on<AddEmployeeEvent>(_onAddEmployee);
    on<ToggleArchiveEmployeeEvent>(_onToggleArchiveEmployee);
  }

  Future<void> _onLoadEmployees(
    EmployeesEvent event,
    Emitter<EmployeesState> emit,
  )
  async {
    emit(EmployeesLoading());
    final val = await getAllEmployeesUseCase();

    val.fold((l){
      emit(EmployeesError(l.message));


    }, (r){

      emit(EmployeesLoaded(r.data!));

    });

  }

  Future<void> _onAddEmployee(
    AddEmployeeEvent event,
    Emitter<EmployeesState> emit,
  )
  async {
    try {
      await addEmployeeUseCase(event.employee);
      add(LoadEmployeesEvent());
    } catch (e) {
      emit(EmployeesError('فشل إضافة الموظف الجديد'));
    }
  }

  Future<void> _onToggleArchiveEmployee(
    ToggleArchiveEmployeeEvent event,
    Emitter<EmployeesState> emit,
  )
  async {
    try {
      await toggleEmployeeArchiveUseCase(event.id, event.isArchived);
      add(LoadEmployeesEvent());
    } catch (e) {
      emit(EmployeesError('فشل تغيير حالة أرشفة الموظف'));
    }
  }

  void _onSearchEmployees(
    SearchEmployeesEvent event,
    Emitter<EmployeesState> emit,
  ) {
    if (event.query.isEmpty) {
      emit(EmployeesLoaded(_allEmployees));
      return;
    }

    final filteredEmployees = _allEmployees
        .where((employee) =>
            employee.user!.fullName!.toLowerCase().contains(event.query.toLowerCase()) ||
            employee.user!.phoneNumber!.contains(event.query))
        .toList();

    if (filteredEmployees.isEmpty) {
      emit(EmployeesEmpty());
    } else {
      emit(EmployeesLoaded(filteredEmployees));
    }
  }
}
