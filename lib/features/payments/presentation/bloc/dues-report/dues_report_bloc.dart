// dues_report_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/get_dues_report.dart';
import 'dues_report_event.dart';
import 'dues_report_state.dart';

@injectable

class DuesReportBloc extends Bloc<DuesReportEvent, DuesReportState> {
  final GetDuesReport getDuesReport;

  DuesReportBloc(this.getDuesReport) : super(DuesReportInitial()) {
    on<LoadDuesReport>(_onLoad);
  }

  Future<void> _onLoad(
      LoadDuesReport event,
      Emitter<DuesReportState> emit,
      ) async {
    emit(DuesReportLoading());

    final result = await getDuesReport();
    print("DuesReportBloc: $result");

    result.fold(
          (failure) => emit(DuesReportError(failure.message)),
          (report) => emit(DuesReportLoaded(report)),
    );
  }
}
