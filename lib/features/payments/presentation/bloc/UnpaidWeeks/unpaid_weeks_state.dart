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
  final UnpaidWeeksResponse response;
  const UnpaidWeeksLoaded(this.response);

  @override
  List<Object?> get props => [response];
}
class UnpaidWeeksError extends UnpaidWeeksState {
  final String message;
  const UnpaidWeeksError(this.message);

  @override
  List<Object?> get props => [message];
}