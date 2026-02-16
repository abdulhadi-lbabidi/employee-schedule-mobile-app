// dues_report_state.dart
import 'package:equatable/equatable.dart';
import '../../../data/ model/dues-report.dart';


abstract class DuesReportState extends Equatable {
  const DuesReportState();

  @override
  List<Object?> get props => [];
}

class DuesReportInitial extends DuesReportState {}

class DuesReportLoading extends DuesReportState {}

class DuesReportLoaded extends DuesReportState {
  final DuesReportModel report;

  const DuesReportLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class DuesReportError extends DuesReportState {
  final String message;

  const DuesReportError(this.message);

  @override
  List<Object?> get props => [message];
}
