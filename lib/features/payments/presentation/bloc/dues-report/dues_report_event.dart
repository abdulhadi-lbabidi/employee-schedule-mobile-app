// dues_report_event.dart
import 'package:equatable/equatable.dart';

abstract class DuesReportEvent extends Equatable {
  const DuesReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadDuesReport extends DuesReportEvent {}
