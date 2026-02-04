import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/di/injection.dart';
import '../../../data/datasources/workshop_locale_data_source.dart';
import '../../../domain/usecases/add_workshop.dart';
import '../../../domain/usecases/get_workshops.dart';
import '../../../domain/usecases/delete_workshop.dart';
import '../../../domain/usecases/toggle_workshop_archive.dart';
import 'workshops_event.dart';
import 'workshops_state.dart';

@injectable
class WorkshopsBloc extends Bloc<WorkshopsEvent, WorkshopsState> {
  final GetWorkshopsUseCase getWorkshopsUseCase;
  final AddWorkshopUseCase addWorkshopUseCase;
  final DeleteWorkshopUseCase deleteWorkshopUseCase;
  final ToggleWorkshopArchiveUseCase toggleWorkshopArchiveUseCase;

  WorkshopsBloc(
     this.getWorkshopsUseCase,
     this.addWorkshopUseCase,
     this.deleteWorkshopUseCase,
     this.toggleWorkshopArchiveUseCase,
  ) : super(WorkshopsInitial()) {
    on<LoadWorkshopsEvent>(_onLoadWorkshops);
    // on<FetchWorkshopsEvent>(_onLoadWorkshops);

    on<AddWorkshopEvent>(_onAddWorkshop);
    on<DeleteWorkshopEvent>(_onDeleteWorkshop);
    on<ToggleArchiveWorkshopEvent>(_onToggleArchiveWorkshop);
  }

  Future<void> _onLoadWorkshops(
    WorkshopsEvent event,
    Emitter<WorkshopsState> emit,
  )
  async {
    emit(WorkshopsLoading());
    final result = await getWorkshopsUseCase();

    result.fold((failure) => emit(WorkshopsError(failure.message)),
            (
      workshops,
    )
        {
      emit(WorkshopsLoaded(workshops));
      sl<WorkshopLocaleDataSource>().setLocaleWorkShop(workshops);
    });
  }

  Future<void> _onAddWorkshop(
    AddWorkshopEvent event,
    Emitter<WorkshopsState> emit,
  ) async {
    try {
      await addWorkshopUseCase(
        name: event.name,
        latitude: event.latitude,
        longitude: event.longitude,
        radius: event.radius,
      );
      add(LoadWorkshopsEvent());
    } catch (e) {
      emit(WorkshopsError('فشل إضافة الورشة'));
    }
  }

  Future<void> _onDeleteWorkshop(
    DeleteWorkshopEvent event,
    Emitter<WorkshopsState> emit,
  )
  async {
    try {
      await deleteWorkshopUseCase(event.id);
      add(LoadWorkshopsEvent());
    } catch (e) {
      emit(WorkshopsError('فشل حذف الورشة'));
    }
  }

  Future<void> _onToggleArchiveWorkshop(
    ToggleArchiveWorkshopEvent event,
    Emitter<WorkshopsState> emit,
  ) async {
    try {
      await toggleWorkshopArchiveUseCase(event.id, event.isArchived);
      add(LoadWorkshopsEvent());
    } catch (e) {
      emit(WorkshopsError('فشل أرشفة الورشة'));
    }
  }
}
