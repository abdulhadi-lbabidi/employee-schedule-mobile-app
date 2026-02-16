import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/features/admin/domain/usecases/get_all_archived_workshop_use_case.dart';
import 'package:untitled8/features/admin/domain/usecases/get_workshop_employee_details_use_case.dart';
import 'package:untitled8/features/admin/domain/usecases/restore_workshop_use_case.dart';
import '../../../../../core/di/injection.dart';
import '../../../data/datasources/workshop_locale_data_source.dart';
import '../../../domain/usecases/add_workshop.dart';
import '../../../domain/usecases/get_all_workshop_use_case.dart';
import '../../../domain/usecases/delete_workshop.dart';
import '../../../domain/usecases/toggle_workshop_archive.dart';
import 'workshops_event.dart';
import 'workshops_state.dart';

@injectable
class WorkshopsBloc extends Bloc<WorkshopsEvent, WorkshopsState> {
  final GetAllWorkshopUseCase getWorkshopsUseCase;
  final GetAllArchivedWorkshopUseCase getAllArchivedWorkshopUseCase;
  final GetWorkshopEmployeeDetailsUseCase getWorkshopEmployeeDetailsUseCase;
  final AddWorkshopUseCase addWorkshopUseCase;
  final DeleteWorkshopUseCase deleteWorkshopUseCase;
  final ToggleWorkshopArchiveUseCase toggleWorkshopArchiveUseCase;
  final RestoreWorkshopUseCase restoreWorkshopUseCase;

  WorkshopsBloc(
    this.getWorkshopsUseCase,
    this.addWorkshopUseCase,
    this.deleteWorkshopUseCase,
    this.toggleWorkshopArchiveUseCase,
    this.getWorkshopEmployeeDetailsUseCase,
    this.restoreWorkshopUseCase,
    this.getAllArchivedWorkshopUseCase,
  ) : super(WorkshopsState()) {
    on<GetAllWorkShopEvent>(_getAll);
    on<GetWorkShopEmployeeDetailsEvent>(_getWorkshopEmployeeDetails);
    // on<FetchWorkshopsEvent>(_onLoadWorkshops);

    on<AddWorkshopEvent>(_onAddWorkshop);
    on<DeleteWorkshopEvent>(_onDeleteWorkshop);
    on<ToggleArchiveWorkshopEvent>(_onToggleArchiveWorkshop);
    on<RestoreArchiveWorkshopEvent>(_restore);
    on<GetAllArchivedWorkShopEvent>(_getArchived);
  }

  Future<void> _restore(
    RestoreArchiveWorkshopEvent event,
    Emitter<WorkshopsState> emit,
  )
  async {
    emit(
      state.copyWith(restoreArchiveData: state.restoreArchiveData.setLoading()),
    );
    final result = await restoreWorkshopUseCase(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          restoreArchiveData: state.restoreArchiveData.setFaild(
            errorMessage: failure.message,
          ),
        ),
      ),
      (workshops) {
        final workshop = state.getAllArchivedWorkshopData.data!.data!.firstWhere(
          (e) => e.id.toString() == event.id,
        );

        final fromArchive = List.of(
          state.getAllArchivedWorkshopData.data!.data!
            ..removeWhere((e) => e.id == workshop.id),
        );

        final addToWorkshops = List.of(
          state.getAllWorkshopData.data!.data!..add(workshop),
        );

        emit(
          state.copyWith(
            restoreArchiveData: state.restoreArchiveData.setSuccess(),
            getAllWorkshopData: state.getAllWorkshopData.copyWith(
              data: state.getAllWorkshopData.data!.copyWith(
                data: addToWorkshops,
              ),
            ),
            getAllArchivedWorkshopData: state.getAllArchivedWorkshopData
                .copyWith(
                  data: state.getAllWorkshopData.data!.copyWith(
                    data: fromArchive,
                  ),
                ),
          ),
        );
      },
    );
  }

  Future<void> _getAll(
    WorkshopsEvent event,
    Emitter<WorkshopsState> emit,
  ) async {
    emit(
      state.copyWith(getAllWorkshopData: state.getAllWorkshopData.setLoading()),
    );
    final result = await getWorkshopsUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          getAllWorkshopData: state.getAllWorkshopData.setFaild(
            errorMessage: failure.message,
          ),
        ),
      ),
      (workshops) {
        emit(
          state.copyWith(
            getAllWorkshopData: state.getAllWorkshopData.setSuccess(
              data: workshops,
            ),
          ),
        );
        sl<WorkshopLocaleDataSource>().setLocaleWorkShop(workshops);
      },
    );
  }

  Future<void> _getArchived(
    GetAllArchivedWorkShopEvent event,
    Emitter<WorkshopsState> emit,
  ) async {
    emit(
      state.copyWith(
        getAllArchivedWorkshopData:
            state.getAllArchivedWorkshopData.setLoading(),
      ),
    );
    final result = await getAllArchivedWorkshopUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          getAllArchivedWorkshopData: state.getAllArchivedWorkshopData.setFaild(
            errorMessage: failure.message,
          ),
        ),
      ),
      (workshops) {
        emit(
          state.copyWith(
            getAllArchivedWorkshopData: state.getAllArchivedWorkshopData
                .setSuccess(data: workshops),
          ),
        );
        sl<WorkshopLocaleDataSource>().setLocaleWorkShop(workshops);
      },
    );
  }

  Future<void> _getWorkshopEmployeeDetails(
    GetWorkShopEmployeeDetailsEvent event,
    Emitter<WorkshopsState> emit,
  ) async {
    emit(
      state.copyWith(
        getWorkshopEmployeeDetailsData:
            state.getWorkshopEmployeeDetailsData.setLoading(),
      ),
    );
    final result = await getWorkshopEmployeeDetailsUseCase(event.id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          getWorkshopEmployeeDetailsData: state.getWorkshopEmployeeDetailsData
              .setFaild(errorMessage: failure.message),
        ),
      ),
      (workshops) {
        emit(
          state.copyWith(
            getWorkshopEmployeeDetailsData: state.getWorkshopEmployeeDetailsData
                .setSuccess(data: workshops),
          ),
        );
      },
    );
  }

  Future<void> _onAddWorkshop(
    AddWorkshopEvent event,
    Emitter<WorkshopsState> emit,
  ) async {
    emit(state.copyWith(addWorkshopData: state.addWorkshopData.setLoading()));
    final result = await addWorkshopUseCase(event.params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          addWorkshopData: state.addWorkshopData.setFaild(
            errorMessage: failure.message,
          ),
        ),
      ),
      (workshops) {
        emit(
          state.copyWith(addWorkshopData: state.addWorkshopData.setSuccess()),
        );
      },
    );
  }

  Future<void> _onDeleteWorkshop(
    DeleteWorkshopEvent event,
    Emitter<WorkshopsState> emit,
  ) async {
    emit(
      state.copyWith(deleteWorkshopData: state.deleteWorkshopData.setLoading()),
    );
    final result = await deleteWorkshopUseCase(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          deleteWorkshopData: state.deleteWorkshopData.setFaild(
            errorMessage: failure.message,
          ),
        ),
      ),
      (workshops) {
        emit(
          state.copyWith(
            deleteWorkshopData: state.deleteWorkshopData.setSuccess(),
          ),
        );
      },
    );
  }

  Future<void> _onToggleArchiveWorkshop(
    ToggleArchiveWorkshopEvent event,
    Emitter<WorkshopsState> emit,
  ) async {
    emit(
      state.copyWith(
        toggleWorkshopArchiveData: state.toggleWorkshopArchiveData.setLoading(),
      ),
    );
    final result = await toggleWorkshopArchiveUseCase(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          toggleWorkshopArchiveData: state.toggleWorkshopArchiveData.setFaild(
            errorMessage: failure.message,
          ),
        ),
      ),
      (workshops) {
        final workshop = state.getAllWorkshopData.data!.data!.firstWhere(
              (e) => e.id.toString() == event.id,
        );

        final fromWorkshops = List.of(
          state.getAllWorkshopData.data!.data!
            ..removeWhere((e) => e.id == workshop.id),
        );

        final addToArchive = List.of(
          state.getAllArchivedWorkshopData.data!.data!..add(workshop),
        );

        emit(
          state.copyWith(
              toggleWorkshopArchiveData:state.toggleWorkshopArchiveData.setSuccess(),
            getAllWorkshopData: state.getAllWorkshopData.copyWith(
              data: state.getAllWorkshopData.data!.copyWith(
                data: fromWorkshops,
              ),
            ),
            getAllArchivedWorkshopData: state.getAllArchivedWorkshopData
                .copyWith(
              data: state.getAllWorkshopData.data!.copyWith(
                data: addToArchive,
              ),
            ),
          ),
        );



      },
    );
  }
}
