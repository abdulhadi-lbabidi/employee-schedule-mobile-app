import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../data/ model/get_unpaid_weeks.dart';
import '../../../domain/usecases/get_unpaid_weeks_params.dart';
import '../../../domain/usecases/get_unpaid_weeks_usecase.dart';
import 'unpaid_weeks_event.dart';
import 'unpaid_weeks_state.dart';

@injectable
class UnpaidWeeksBloc extends Bloc<UnpaidWeeksEvent, UnpaidWeeksState> {
  final GetUnpaidWeeksUseCase getUnpaidWeeksUseCase;

  UnpaidWeeksBloc(this.getUnpaidWeeksUseCase) : super(UnpaidWeeksInitial()) {
    on<LoadUnpaidWeeks>((event, emit) async {
      emit(UnpaidWeeksLoading());
      final result = await getUnpaidWeeksUseCase(
        GetUnpaidWeeksParams(employeeId: event.employeeId),
      );
      result.fold(
            (failure) => emit(UnpaidWeeksError(failure.message)),
            (weeks) => emit(UnpaidWeeksLoaded(weeks as List<UnpaidWeeks>)),
      );
    });
  }
}