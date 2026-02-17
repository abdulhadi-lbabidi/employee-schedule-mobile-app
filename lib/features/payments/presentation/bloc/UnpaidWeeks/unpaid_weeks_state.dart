import 'package:equatable/equatable.dart';
import '../../../data/ model/get_unpaid_weeks.dart';

abstract class UnpaidWeeksState extends Equatable {
  const UnpaidWeeksState();
  @override
  List<Object?> get props => [];
}

class UnpaidWeeksInitial extends UnpaidWeeksState {}
class UnpaidWeeksLoading extends UnpaidWeeksState {}
class UnpaidWeeksLoaded extends UnpaidWeeksState {
  final List<UnpaidWeeks> weeks;
  const UnpaidWeeksLoaded(this.weeks);
}
class UnpaidWeeksError extends UnpaidWeeksState {
  final String message;
  const UnpaidWeeksError(this.message);
}