import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/data_state_model.dart';
import '../../domain/entities/penalty_entity.dart';
import '../../domain/usecases/penalty_usecases.dart';

// Events
abstract class PenaltyEvent {}
class LoadAllPenalties extends PenaltyEvent {}
class LoadEmployeePenalties extends PenaltyEvent { final int employeeId; LoadEmployeePenalties(this.employeeId); }
class IssuePenaltyEvent extends PenaltyEvent {
  final int employeeId;
  final int workshopId; // 🔹 إضافة رقم الورشة
  final double amount;
  final String reason;
  final int adminId;
  final DateTime date;
  IssuePenaltyEvent({
    required this.employeeId,
    required this.workshopId, // 🔹 إضافة رقم الورشة
    required this.amount,
    required this.reason,
    required this.adminId,
    required this.date,
  });
}

// State
class PenaltyState {
  final DataStateModel<List<PenaltyEntity>> penalties;
  final DataStateModel<void> issuePenaltyStatus;

  PenaltyState({
    this.penalties = const DataStateModel.setDefultValue(defultValue: []),
    this.issuePenaltyStatus = const DataStateModel.setDefultValue(defultValue: null),
  });

  PenaltyState copyWith({
    DataStateModel<List<PenaltyEntity>>? penalties,
    DataStateModel<void>? issuePenaltyStatus,
  }) {
    return PenaltyState(
      penalties: penalties ?? this.penalties,
      issuePenaltyStatus: issuePenaltyStatus ?? this.issuePenaltyStatus,
    );
  }
}

@injectable
class PenaltyBloc extends Bloc<PenaltyEvent, PenaltyState> {
  final GetAllPenaltiesUseCase getAllPenaltiesUseCase;
  final GetEmployeePenaltiesUseCase getEmployeePenaltiesUseCase;
  final IssuePenaltyUseCase issuePenaltyUseCase;

  PenaltyBloc(
    this.getAllPenaltiesUseCase,
    this.getEmployeePenaltiesUseCase,
    this.issuePenaltyUseCase,
  ) : super(PenaltyState()) {
    on<LoadAllPenalties>(_onLoadAll);
    on<LoadEmployeePenalties>(_onLoadEmployee);
    on<IssuePenaltyEvent>(_onIssue);
  }

  Future<void> _onLoadAll(LoadAllPenalties event, Emitter<PenaltyState> emit) async {
    emit(state.copyWith(penalties: state.penalties.setLoading()));
    final result = await getAllPenaltiesUseCase();
    result.fold(
      (l) => emit(state.copyWith(penalties: state.penalties.setFaild(errorMessage: l.message))),
      (r) => emit(state.copyWith(penalties: state.penalties.setSuccess(data: r))),
    );
  }

  Future<void> _onLoadEmployee(LoadEmployeePenalties event, Emitter<PenaltyState> emit) async {
    emit(state.copyWith(penalties: state.penalties.setLoading()));
    final result = await getEmployeePenaltiesUseCase(event.employeeId);
    result.fold(
      (l) => emit(state.copyWith(penalties: state.penalties.setFaild(errorMessage: l.message))),
      (r) => emit(state.copyWith(penalties: state.penalties.setSuccess(data: r))),
    );
  }

  Future<void> _onIssue(IssuePenaltyEvent event, Emitter<PenaltyState> emit) async {
    emit(state.copyWith(issuePenaltyStatus: state.issuePenaltyStatus.setLoading()));
    final result = await issuePenaltyUseCase(
      employeeId: event.employeeId,
      workshopId: event.workshopId, // 🔹 تمرير رقم الورشة
      amount: event.amount,
      reason: event.reason,
      adminId: event.adminId,
      date: event.date,
    );
    result.fold(
      (l) => emit(state.copyWith(issuePenaltyStatus: state.issuePenaltyStatus.setFaild(errorMessage: l.message))),
      (r) {
        emit(state.copyWith(issuePenaltyStatus: state.issuePenaltyStatus.setSuccess()));
        add(LoadAllPenalties());
      },
    );
  }
}
