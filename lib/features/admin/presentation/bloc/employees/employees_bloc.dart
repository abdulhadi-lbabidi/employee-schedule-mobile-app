import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/features/admin/domain/usecases/get_all_archive_employee_use_case.dart';
import 'package:untitled8/features/admin/domain/usecases/restore_employee_archive_use_case.dart';
import '../../../data/models/employee model/employee_model.dart';
import '../../../domain/usecases/add_employee.dart';
import '../../../domain/usecases/get_all_employees.dart';
import '../../../domain/usecases/toggle_employee_archive.dart';
import 'employees_event.dart';
import 'employees_state.dart';

@injectable
class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final GetAllEmployeesUseCase getAllEmployeesUseCase;
  final GetAllArchiveEmployeeUseCase getAllEmployeesArchivedUseCase;
  final AddEmployeeUseCase addEmployeeUseCase;
  final ToggleEmployeeArchiveUseCase toggleEmployeeArchiveUseCase;
  final RestoreEmployeeArchiveUseCase restoreEmployeeArchiveUseCase;

  // تخزين القوائم الأصلية للبحث
  List<EmployeeModel> _allActiveEmployees = [];
  List<EmployeeModel> _allArchivedEmployees = [];

  EmployeesBloc(
    this.getAllEmployeesUseCase,
    this.addEmployeeUseCase,
    this.toggleEmployeeArchiveUseCase,
    this.getAllEmployeesArchivedUseCase,
    this.restoreEmployeeArchiveUseCase,
  ) : super(EmployeesState()) {
    on<GetAllEmployeeEvent>(_getAllEmployees);
    on<GetAllEmployeeArchivedEvent>(_getAllArchivedEmployees);
    on<SearchEmployeesEvent>(_onSearchEmployees);
    on<AddEmployeeEvent>(_onAddEmployee);
    on<ToggleArchiveEmployeeEvent>(_onToggleArchiveEmployee);
    on<RestoreArchiveEmployeeEvent>(_restoreArchiveEmployee);
  }

  Future<void> _getAllEmployees(
    GetAllEmployeeEvent event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(state.copyWith(employeesData: state.employeesData.setLoading()));
    final val = await getAllEmployeesUseCase();

    val.fold(
      (l) => emit(state.copyWith(employeesData: state.employeesData.setFaild(errorMessage: l.message))),
      (r) {
        _allActiveEmployees = r?.data ?? [];
        emit(state.copyWith(employeesData: state.employeesData.setSuccess(data: r)));
      },
    );
  }

  Future<void> _getAllArchivedEmployees(
    GetAllEmployeeArchivedEvent event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(state.copyWith(employeesArchivedData: state.employeesArchivedData.setLoading()));
    final val = await getAllEmployeesArchivedUseCase();

    val.fold(
      (l) => emit(state.copyWith(employeesArchivedData: state.employeesArchivedData.setFaild(errorMessage: l.message))),
      (r) {
        _allArchivedEmployees = r?.data ?? [];
        emit(state.copyWith(employeesArchivedData: state.employeesArchivedData.setSuccess(data: r)));
      },
    );
  }

  void _onSearchEmployees(SearchEmployeesEvent event, Emitter<EmployeesState> emit) {
    final query = event.query.toLowerCase();

    if (query.isEmpty) {
      // إعادة القوائم الأصلية عند مسح البحث
      emit(state.copyWith(
        employeesData: state.employeesData.copyWith(data: state.employeesData.data?.copyWith(data: _allActiveEmployees)),
        employeesArchivedData: state.employeesArchivedData.copyWith(data: state.employeesArchivedData.data?.copyWith(data: _allArchivedEmployees)),
      ));
      return;
    }

    // فلترة الموظفين النشطين
    final filteredActive = _allActiveEmployees.where((emp) {
      final name = emp.user?.fullName?.toLowerCase() ?? "";
      final phone = emp.user?.phoneNumber ?? "";
      return name.contains(query) || phone.contains(query);
    }).toList();

    // فلترة الموظفين مؤرشفين
    final filteredArchived = _allArchivedEmployees.where((emp) {
      final name = emp.user?.fullName?.toLowerCase() ?? "";
      final phone = emp.user?.phoneNumber ?? "";
      return name.contains(query) || phone.contains(query);
    }).toList();

    emit(state.copyWith(
      employeesData: state.employeesData.copyWith(data: state.employeesData.data?.copyWith(data: filteredActive)),
      employeesArchivedData: state.employeesArchivedData.copyWith(data: state.employeesArchivedData.data?.copyWith(data: filteredArchived)),
    ));
  }

  // ... (باقي الدوال add, toggle, restore تبقى كما هي)
  Future<void> _onAddEmployee(AddEmployeeEvent event, Emitter<EmployeesState> emit) async {
    emit(state.copyWith(addEmployeeData: state.addEmployeeData.setLoading()));
    final val = await addEmployeeUseCase(event.employee);
    val.fold(
      (l) => emit(state.copyWith(addEmployeeData: state.addEmployeeData.setFaild(errorMessage: l.message))),
      (r) {
        emit(state.copyWith(addEmployeeData: state.addEmployeeData.setSuccess()));
        add(GetAllEmployeeEvent());
      },
    );
  }

  Future<void> _onToggleArchiveEmployee(ToggleArchiveEmployeeEvent event, Emitter<EmployeesState> emit) async {
    emit(state.copyWith(setEmployeeArchivedData: state.setEmployeeArchivedData.setLoading()));
    final val = await toggleEmployeeArchiveUseCase(event.id);
    val.fold(
      (l) => emit(state.copyWith(setEmployeeArchivedData: state.setEmployeeArchivedData.setFaild(errorMessage: l.message))),
      (r) {
        add(GetAllEmployeeEvent());
        add(GetAllEmployeeArchivedEvent());
        emit(state.copyWith(setEmployeeArchivedData: state.setEmployeeArchivedData.setSuccess()));
      },
    );
  }

  Future<void> _restoreArchiveEmployee(RestoreArchiveEmployeeEvent event, Emitter<EmployeesState> emit) async {
    emit(state.copyWith(restoreEmployeeArchivedData: state.restoreEmployeeArchivedData.setLoading()));
    final val = await restoreEmployeeArchiveUseCase(event.id);
    val.fold(
      (l) => emit(state.copyWith(restoreEmployeeArchivedData: state.restoreEmployeeArchivedData.setFaild(errorMessage: l.message))),
      (r) {
        add(GetAllEmployeeEvent());
        add(GetAllEmployeeArchivedEvent());
        emit(state.copyWith(restoreEmployeeArchivedData: state.restoreEmployeeArchivedData.setSuccess()));
      },
    );
  }
}
