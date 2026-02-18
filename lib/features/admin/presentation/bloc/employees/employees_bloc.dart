import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/features/admin/domain/usecases/get_all_archive_employee_use_case.dart';
import 'package:untitled8/features/admin/domain/usecases/restore_employee_archive_use_case.dart';
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
  )
  async {
    emit(state.copyWith(employeesData: state.employeesData.setLoading()));
    final val = await getAllEmployeesUseCase();

    val.fold(
      (l) {
        emit(
          state.copyWith(
            employeesData: state.employeesData.setFaild(
              errorMessage: l.message,
            ),
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            employeesData: state.employeesData.setSuccess(data: r),
          ),
        );
      },
    );
  }

  Future<void> _getAllArchivedEmployees(
    GetAllEmployeeArchivedEvent event,
    Emitter<EmployeesState> emit,
  )
  async {
    emit(
      state.copyWith(
        employeesArchivedData: state.employeesArchivedData.setLoading(),
      ),
    );
    final val = await getAllEmployeesArchivedUseCase();

    val.fold(
      (l) {
        emit(
          state.copyWith(
            employeesArchivedData: state.employeesArchivedData.setFaild(
              errorMessage: l.message,
            ),
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            employeesArchivedData: state.employeesArchivedData.setSuccess(
              data: r,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAddEmployee(
    AddEmployeeEvent event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(state.copyWith(addEmployeeData: state.addEmployeeData.setLoading()));
    final val = await addEmployeeUseCase(event.employee);

    val.fold(
      (l) {
        emit(
          state.copyWith(
            addEmployeeData: state.addEmployeeData.setFaild(
              errorMessage: l.message,
            ),
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(addEmployeeData: state.addEmployeeData.setSuccess()),
        );
      },
    );
  }

  Future<void> _onToggleArchiveEmployee(
    ToggleArchiveEmployeeEvent event,
    Emitter<EmployeesState> emit,
  )
  async {
    emit(
      state.copyWith(
        setEmployeeArchivedData: state.setEmployeeArchivedData.setLoading(),
      ),
    );
    final val = await toggleEmployeeArchiveUseCase(event.id);

    val.fold(
      (l) {
        emit(
          state.copyWith(
            setEmployeeArchivedData: state.setEmployeeArchivedData.setFaild(
              errorMessage: l.message,
            ),
          ),
        );
      },
      (r) {
        final employee = state.employeesData.data!.data!.firstWhere(
          (e) => e.id.toString() == event.id,
        );

        final fromEmployee = List.of(
          state.employeesData.data!.data!
            ..removeWhere((e) => e.id == employee.id),
        );

        final addToArchive = List.of(
          state.employeesArchivedData.data!.data!..add(employee),
        );

        emit(
          state.copyWith(
            setEmployeeArchivedData: state.setEmployeeArchivedData.setSuccess(),
            employeesData: state.employeesData.copyWith(
              data: state.employeesData.data!.copyWith(data: fromEmployee),
            ),
            employeesArchivedData: state.employeesArchivedData.copyWith(
              data: state.employeesArchivedData.data!.copyWith(
                data: addToArchive,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _restoreArchiveEmployee(
    RestoreArchiveEmployeeEvent event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(
      state.copyWith(
        restoreEmployeeArchivedData:
            state.restoreEmployeeArchivedData.setLoading(),
      ),
    );
    final val = await restoreEmployeeArchiveUseCase(event.id);

    val.fold(
      (l) {
        emit(
          state.copyWith(
            restoreEmployeeArchivedData: state.restoreEmployeeArchivedData
                .setFaild(errorMessage: l.message),
          ),
        );
      },
      (r) {
        final workshop = state.employeesArchivedData.data!.data!.firstWhere(
          (e) => e.id.toString() == event.id,
        );

        final fromArchive = List.of(
          state.employeesArchivedData.data!.data!
            ..removeWhere((e) => e.id == workshop.id),
        );

        final addToWorkshops = List.of(
          state.employeesData.data!.data!..add(workshop),
        );

        emit(
          state.copyWith(
            restoreEmployeeArchivedData:
                state.restoreEmployeeArchivedData.setSuccess(),
            employeesData: state.employeesData.copyWith(
              data: state.employeesData.data!.copyWith(data: addToWorkshops),
            ),
            employeesArchivedData: state.employeesArchivedData.copyWith(
              data: state.employeesArchivedData.data!.copyWith(
                data: fromArchive,
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSearchEmployees(
    SearchEmployeesEvent event,
    Emitter<EmployeesState> emit,
  ) {
    // if (event.query.isEmpty) {
    //   emit(EmployeesLoaded(_allEmployees));
    //   return;
    // }
    //
    // final filteredEmployees =
    //     _allEmployees
    //         .where(
    //           (employee) =>
    //               employee.user!.fullName!.toLowerCase().contains(
    //                 event.query.toLowerCase(),
    //               ) ||
    //               employee.user!.phoneNumber!.contains(event.query),
    //         )
    //         .toList();
    //
    // if (filteredEmployees.isEmpty) {
    //   emit(EmployeesEmpty());
    // } else {
    //   emit(EmployeesLoaded(filteredEmployees));
    // }
  }
}
