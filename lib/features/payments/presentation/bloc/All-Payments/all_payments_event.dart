import 'package:equatable/equatable.dart';

abstract class AllPaymentsEvent extends Equatable {
  const AllPaymentsEvent();
  @override
  List<Object?> get props => [];
}

class FetchAllPayments extends AllPaymentsEvent {}